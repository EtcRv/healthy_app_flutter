import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:healthy_app_flutter/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:healthy_app_flutter/Screens/ForgetPasswordScreen/ForgetPasswordScreen.dart';
import 'package:healthy_app_flutter/Screens/HomeScreen/HomeScreen.dart';
import 'package:healthy_app_flutter/Screens/LoginScreen/LoginScreen.dart';
import 'package:healthy_app_flutter/Screens/PredictCovidScreen/PredictCovidScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthy_app_flutter/Screens/RegisterScreen/RegisterScreen.dart';
import 'package:healthy_app_flutter/core/reducers/app_state_reducer.dart';
import 'package:healthy_app_flutter/models/App_State.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
    debug: true,
  );

  AppState? initialState;
  try {
    initialState = await persistor.load();
  } catch (e) {
    initialState = null;
  }

  final store = Store<AppState>(
    appReducer,
    initialState: initialState ?? AppState.init(),
    middleware: [persistor.createMiddleware()],
  );
  runApp(StoreProvider(store: store, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        builder: (BuildContext context, vm) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // TRY THIS: Try running your application with "flutter run". You'll see
              // the application has a blue toolbar. Then, without quitting the app,
              // try changing the seedColor in the colorScheme below to Colors.green
              // and then invoke "hot reload" (save your changes or press the "hot
              // reload" button in a Flutter-supported IDE, or press "r" if you used
              // the command line to start the app).
              //
              // Notice that the counter didn't reset back to zero; the application
              // state is not lost during the reload. To reset the state, use hot
              // restart instead.
              //
              // This works for code too, not just values: Most code changes can be
              // tested with just a hot reload.
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routes: {
              '/': (context) => const AuthenticationScreen(),
              '/login': (context) => LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/forgetpassword': (context) => const ForgetPasswordScreen(),
              '/home': (context) => HomeScreen(),
              '/predict': (context) => const PredictCovidScreen(),
            },
            initialRoute: vm.isLogin ? '/home' : '/',
            builder: EasyLoading.init(),
          );
        });
  }
}

class _ViewModel {
  final bool isLogin;
  _ViewModel({
    required this.isLogin,
  });

  static _ViewModel fromStore(store) {
    return _ViewModel(
      isLogin: store.state.isLogin,
    );
  }
}
