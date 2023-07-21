import 'package:healthy_app_flutter/models/User.dart';

class AppState {
  AppState({required this.isLogin, required this.user});

  final bool isLogin;
  final UserModel user;

  factory AppState.init() =>
      AppState(isLogin: false, user: UserModel("", "", "", "", "", "", 0));
}
