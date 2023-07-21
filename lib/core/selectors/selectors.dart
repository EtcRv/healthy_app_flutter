import 'package:healthy_app_flutter/models/App_State.dart';
import 'package:healthy_app_flutter/models/User.dart';

bool isLoginSelector(AppState state) => state.isLogin;

UserModel userInfoSelector(AppState state) => state.user;
