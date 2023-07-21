import 'package:healthy_app_flutter/models/models.dart';

class UpdateUserAction {
  final UserModel updatedUser;
  UpdateUserAction(this.updatedUser);
}

class UpdateIsLoginAction {
  final bool isLogin;
  UpdateIsLoginAction(this.isLogin);
}
