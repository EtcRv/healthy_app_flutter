import 'package:healthy_app_flutter/core/actions/actions.dart';
import 'package:redux/redux.dart';

final isLoginReducer = combineReducers<bool>([
  TypedReducer<bool, UpdateIsLoginAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return action.isLogin;
}
