import 'dart:convert';

import 'package:healthy_app_flutter/models/User.dart';

class AppState {
  AppState({required this.isLogin, required this.user});

  final bool isLogin;
  final UserModel user;

  static AppState? fromJson(dynamic json) {
    late var userData;
    if (json != null) {
      userData = jsonDecode(json['user']);
    }
    return json != null
        ? AppState(
            isLogin: json['isLogin'] == "true",
            user: UserModel(
              userData['uuid'],
              userData['email'],
              userData['name'],
              userData['gender'],
              userData['noio'],
              userData['quequan'],
              userData['age'],
            ))
        : null;
  }

  dynamic toJson() {
    return {
      'isLogin': jsonEncode(isLogin),
      'user': jsonEncode(user.toJson()),
    };
  }

  factory AppState.init() =>
      AppState(isLogin: false, user: UserModel("", "", "", "", "", "", 0));
}
