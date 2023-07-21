import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:healthy_app_flutter/Screens/PredictCovidScreen/PredictCovidUI.dart';
import 'package:healthy_app_flutter/Widgets/Button/Button.dart';
import 'package:healthy_app_flutter/core/actions/actions.dart';
import 'package:healthy_app_flutter/core/selectors/selectors.dart';
import 'package:healthy_app_flutter/models/App_State.dart';
import 'package:healthy_app_flutter/models/User.dart';
import 'package:redux/redux.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PredictCovidScreen extends StatefulWidget {
  const PredictCovidScreen({super.key});

  @override
  State<PredictCovidScreen> createState() {
    return _PredictCovidScreenState();
  }
}

class _PredictCovidScreenState extends State<PredictCovidScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        builder: (BuildContext context, _ViewModel vm) {
          return PredictCovidUI(
            userState: vm.userInfo,
            logout: () {
              vm.changeLogin(false);
              vm.onUserModelChange(UserModel("", "", "", "", "", "", 0));
            },
          );
        });
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
