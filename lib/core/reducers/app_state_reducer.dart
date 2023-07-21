import 'package:healthy_app_flutter/core/reducers/isLogin_reducer.dart';
import 'package:healthy_app_flutter/core/reducers/user_reducer.dart';
import 'package:healthy_app_flutter/models/App_State.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    isLogin: isLoginReducer(state.isLogin, action),
    user: userReducer(state.user, action),
  );
}
