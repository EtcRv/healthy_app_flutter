import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:healthy_app_flutter/Widgets/Button/Button.dart';
import 'package:healthy_app_flutter/Widgets/FloatingInput/FloatingInput.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../LoginScreen/LoginScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name = '';
  String email = '';
  String password = '';
  String rePassword = '';
  String error = '';
  String success = '';
  DatabaseReference userDatabase = FirebaseDatabase.instance.ref('/users');

  void register() async {
    if (email == '' || password == '' || name == '' || rePassword == '') {
      setState(() {
        error = 'Xin hãy nhập đủ các trường bên trên!';
      });
    } else if (!email.contains('@')) {
      setState(() {
        error = 'Trường email nhập không đúng dạng!';
      });
    } else if (password != rePassword) {
      setState(() {
        error = 'Hai mật khẩu nhập không giống nhau!';
      });
    } else {
      setState(() {
        error = '';
      });
      if (Platform.isAndroid) {
        try {
          EasyLoading.show(status: 'loading...');
          UserCredential newUser = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          var newReference = userDatabase.push();
          newReference.set({
            "user": {
              "uuid": newUser.user?.uid,
              "name": name,
              "email": email,
              "age": 0,
              "gender": 'male',
              "quequan": '',
              "noio": ''
            }
          }).then((value) {
            Fluttertoast.showToast(
              msg: "Tạo tài khoản thành công",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16,
            );
            EasyLoading.dismiss();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          });
          EasyLoading.dismiss();
        } on FirebaseAuthException catch (e) {
          EasyLoading.dismiss();
          if (e.code == 'weak-password') {
            setState(() {
              error = 'The password provided is too weak.';
            });
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              error = 'The account already exists for that email.';
            });
          }
        }
      } else if (Platform.isWindows) {
        EasyLoading.show(status: 'loading...');
        final url = Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA4l4-gZJNsElJBSpmnRLsHlbY90ZAN2l4');

        final response = await http.post(
          url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': false,
          }),
        );
        final responseData = json.decode(response.body);
        if (responseData['error'] != null &&
            responseData['error']['code'] == 400) {
          if (responseData['error']['message'] == "EMAIL_EXISTS") {
            setState(() {
              error = 'The account already exists for that email.';
            });
          }
        } else {
          final dburl = Uri.parse(
              "https://healthy-app-5dab0-default-rtdb.asia-southeast1.firebasedatabase.app/users.json");
          final db_response = await http.post(dburl,
              body: json.encode({
                "user": {
                  "uuid": responseData['localId'],
                  "name": name,
                  "email": email,
                  "age": 0,
                  "gender": 'male',
                  "quequan": '',
                  "noio": ''
                }
              }));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
        EasyLoading.dismiss();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
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
            padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Tạo tài khoản!',
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
                  'Hãy nhập các thông tin dưới đây để tạo tài khoản mới',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingInput(
                  labelText: 'Họ và tên',
                  setInputValue: ((value) {
                    setState(() {
                      name = value;
                    });
                  }),
                  isPassword: false,
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
                  height: 20,
                ),
                FloatingInput(
                  labelText: 'Nhập lại mật khẩu',
                  setInputValue: ((value) {
                    setState(() {
                      rePassword = value;
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
                Visibility(
                  visible: success != '',
                  child: Text(
                    success,
                    style: const TextStyle(
                      color: Color(0xff13c26a),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Button(
                    clickBtn: () {
                      register();
                    },
                    textColor: Color(0xFFFFFFFF),
                    textContent: "ĐĂNG KÝ",
                    backgroundColor: Color(0xFF1f0ec7),
                    borderColor: Color(0xFF1f0ec7),
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
                      "Bạn đã có tài khoản?",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff76727a),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "Đăng nhập",
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
  }
}
