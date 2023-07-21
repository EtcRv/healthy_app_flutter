import 'package:healthy_app_flutter/core/actions/actions.dart';
import 'package:healthy_app_flutter/models/models.dart';
import 'package:redux/redux.dart';

final userReducer = combineReducers<UserModel>([
  TypedReducer<UserModel, UpdateUserAction>(_setLoaded),
]);

UserModel _setLoaded(UserModel state, action) {
  return action.updatedUser;
}
