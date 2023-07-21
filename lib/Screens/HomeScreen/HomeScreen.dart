import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthy_app_flutter/Screens/HomeScreen/HomeScreenUI.dart';
import 'package:healthy_app_flutter/Widgets/FloatingInput/FloatingInput.dart';
import 'package:healthy_app_flutter/core/actions/actions.dart';
import 'package:healthy_app_flutter/models/models.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  DatabaseReference userDatabase = FirebaseDatabase.instance.ref('/users');

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return StoreConnector(
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        return HomeScreenUI(
            userInfo: vm.userInfo,
            name: vm.userInfo.name,
            age: vm.userInfo.age,
            gender: vm.userInfo.gender,
            noio: vm.userInfo.noio,
            quequan: vm.userInfo.quequan,
            saveInformation: (UserModel user) {
              vm.onUserModelChange(user);
              userDatabase.onValue.listen((event) {
                final data = event.snapshot.value;
                var users = new Map();
                Map<String, dynamic>.from(data as dynamic)
                    .forEach((key, value) => users[key] = value);
                for (var k in users.keys) {
                  if (users[k]['user']['email'] == user.email) {
                    var userUpdates =
                        FirebaseDatabase.instance.ref().child('/users/${k}');
                    userUpdates.update({
                      "user": {
                        "gender": user.gender,
                        "name": user.name,
                        "noio": user.noio,
                        "quequan": user.quequan,
                        "age": user.age,
                        "email": user.email,
                        "uuid": user.uuid
                      }
                    }).then((_) {
                      Fluttertoast.showToast(
                        msg: "Lưu thông tin thành công",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16,
                      );
                    });
                  }
                }
              });
            },
            logout: () {
              vm.changeLogin(false);
              vm.onUserModelChange(UserModel("", "", "", "", "", "", 0));
            });
      },
    );
  }
}

class _ViewModel {
  final UserModel userInfo;
  final Function(UserModel) onUserModelChange;
  final Function(bool) changeLogin;

  _ViewModel(
      {required this.onUserModelChange,
      required this.userInfo,
      required this.changeLogin});

  static _ViewModel fromStore(store) {
    return _ViewModel(
        onUserModelChange: (UserModel user) {
          store.dispatch(UpdateUserAction(user));
        },
        userInfo: store.state.user,
        changeLogin: (bool isLogin) {
          store.dispatch(UpdateIsLoginAction(isLogin));
        });
  }
}
