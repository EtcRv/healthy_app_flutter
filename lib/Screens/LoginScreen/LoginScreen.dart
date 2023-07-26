import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthy_app_flutter/Screens/ForgetPasswordScreen/ForgetPasswordScreen.dart';
import 'package:healthy_app_flutter/Screens/RegisterScreen/RegisterScreen.dart';
import 'package:healthy_app_flutter/Widgets/Button/Button.dart';
import 'package:healthy_app_flutter/Widgets/FloatingInput/FloatingInput.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthy_app_flutter/core/actions/actions.dart';
import 'package:healthy_app_flutter/models/App_State.dart';
import 'package:healthy_app_flutter/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthy_app_flutter/core/reducers/user_reducer.dart';
import 'package:redux/redux.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  DatabaseReference userDatabase = FirebaseDatabase.instance.ref('/users');
  String email = '';
  String password = '';
  String error = '';
  String uuid = '';
  String name = '';
  String gender = '';
  String noio = '';
  String quequan = '';
  int age = 0;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(''),
            backgroundColor: Colors.white,
          ),
          body: SizedBox(
            width: widthScreen,
            height: heightScreen,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: Colors.white,
                height: heightScreen,
                padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Xin chào!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Hãy đăng nhập để tiếp tục',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FloatingInput(
                      labelText: 'Email',
                      setInputValue: ((value) {
                        setState(() {
                          email = value;
                        });
                      }),
                      isPassword: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FloatingInput(
                      labelText: 'Mật khẩu',
                      setInputValue: ((value) {
                        setState(() {
                          password = value;
                        });
                      }),
                      isPassword: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: error != '',
                      child: Text(
                        error,
                        style: const TextStyle(
                          color: Color(0xffd72020),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Button(
                        clickBtn: () async {
                          if (email == '' || password == '') {
                            setState(() {
                              error = 'Xin hãy nhập đủ các trường bên trên!';
                            });
                          } else if (!email.contains('@')) {
                            setState(() {
                              error = 'Trường email nhập không đúng dạng!';
                            });
                          } else {
                            setState(() {
                              error = '';
                            });
                            try {
                              EasyLoading.show(status: 'loading...');
                              UserCredential credential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);

                              userDatabase.onValue.listen((event) {
                                final data = event.snapshot.value;
                                var users = new Map();
                                Map<String, dynamic>.from(data as dynamic)
                                    .forEach(
                                        (key, value) => users[key] = value);
                                for (var k in users.keys) {
                                  if (users[k]['user']['email'] == email) {
                                    vm.onUserModelChange(UserModel(
                                        users[k]['user']['uuid'],
                                        email,
                                        users[k]['user']['name'],
                                        users[k]['user']['gender'],
                                        users[k]['user']['noio'],
                                        users[k]['user']['quequan'],
                                        users[k]['user']['age']));
                                    vm.changeIsLogin(true);
                                    EasyLoading.dismiss();
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  }
                                }
                              });
                              EasyLoading.dismiss();
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                setState(() {
                                  error = 'No user found for that email.';
                                });
                              } else if (e.code == 'wrong-password') {
                                setState(() {
                                  error =
                                      'Wrong password provided for that user.';
                                });
                              }
                            }
                          }
                        },
                        textColor: Color(0xFFFFFFFF),
                        textContent: "ĐĂNG NHẬP",
                        backgroundColor: Color(0xFF1f0ec7),
                        borderColor: Color(0xFF1f0ec7),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: widthScreen,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/forgetpassword');
                        },
                        child: const Text(
                          "Quên mật khẩu?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 0,
                          width: widthScreen / 3,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color(0xff7c7979),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Hoặc',
                          style: TextStyle(
                            color: Color(0xFF1d0bd4),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 0,
                          width: widthScreen / 3,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color(0xff7c7979),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: widthScreen,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Đăng nhập bằng tài khoản',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xff76727a),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              try {
                                final GoogleSignInAccount? googleUser =
                                    await GoogleSignIn().signIn();
                                final GoogleSignInAuthentication? googleAuth =
                                    await googleUser?.authentication;

                                final credential =
                                    GoogleAuthProvider.credential(
                                  idToken: googleAuth?.idToken,
                                );

                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential);

                                var flag = false;
                                userDatabase.onValue.listen((event) {
                                  final data = event.snapshot.value;
                                  var users = new Map();
                                  Map<String, dynamic>.from(data as dynamic)
                                      .forEach(
                                          (key, value) => users[key] = value);
                                  for (var k in users.keys) {
                                    if (users[k]['user']['email'] ==
                                        userCredential.user!.email) {
                                      flag = true;
                                      vm.onUserModelChange(UserModel(
                                          users[k]['user']['uuid'],
                                          users[k]['user']['email'],
                                          users[k]['user']['name'],
                                          users[k]['user']['gender'],
                                          users[k]['user']['noio'],
                                          users[k]['user']['quequan'],
                                          users[k]['user']['age']));
                                      vm.changeIsLogin(true);
                                      Navigator.pushReplacementNamed(
                                          context, '/home');
                                    }
                                  }
                                  if (!flag) {
                                    var newReference = userDatabase.push();
                                    newReference.set({
                                      "user": {
                                        "uuid": userCredential.user!.uid,
                                        "name":
                                            userCredential.user!.displayName!,
                                        "email": userCredential.user!.email!,
                                        "age": 0,
                                        "gender": 'male',
                                        "quequan": '',
                                        "noio": ''
                                      }
                                    }).then((value) {
                                      vm.onUserModelChange(UserModel(
                                          userCredential.user!.uid,
                                          userCredential.user!.email!,
                                          userCredential.user!.displayName!,
                                          'male',
                                          '',
                                          '',
                                          0));
                                      vm.changeIsLogin(true);
                                      Navigator.pushReplacementNamed(
                                          context, '/home');
                                      Fluttertoast.showToast(
                                        msg: "Đăng nhập thành công",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        fontSize: 16,
                                      );
                                    });
                                  }
                                });
                              } catch (error) {
                                print("error: ${error}");
                              }
                            },
                            child: const Image(
                              image: AssetImage('assets/images/googleIcon.png'),
                              width: 60,
                              height: 60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Bạn chưa có tài khoản?",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xff76727a),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          },
                          child: const Text(
                            "Đăng ký",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff76727a),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final UserModel userInfo;
  final Function(UserModel) onUserModelChange;
  final Function(bool) changeIsLogin;
  _ViewModel(
      {required this.onUserModelChange,
      required this.userInfo,
      required this.changeIsLogin});

  static _ViewModel fromStore(store) {
    return _ViewModel(
      onUserModelChange: (UserModel user) {
        store.dispatch(UpdateUserAction(user));
      },
      changeIsLogin: (bool isLogin) {
        store.dispatch(UpdateIsLoginAction(isLogin));
      },
      userInfo: store.state.user,
    );
  }
}
