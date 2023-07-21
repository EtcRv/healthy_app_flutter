import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app_flutter/Widgets/Button/Button.dart';
import 'package:healthy_app_flutter/Widgets/FloatingInput/FloatingInput.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() {
    return _ForgetPasswordScreenState();
  }
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String email = '';
  String success = '';

  void getNewPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) => setState(() {
                success = 'Kiểm tra mail để cập nhật mật khẩu của bạn!';
              }));
    } catch (err) {
      print("err: ${err}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
          width: widthScreen,
          height: heightScreen,
          child: Container(
            color: Colors.white,
            height: heightScreen,
            padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Quên mật khẩu!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Hãy nhập email để lấy lại mật khẩu',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingInput(
                  labelText: 'Email',
                  setInputValue: ((value) {
                    setState(() {
                      email = value;
                    });
                  }),
                  isPassword: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: success != '',
                  child: Text(
                    success,
                    style: const TextStyle(
                      color: Color(0xff13c26a),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Button(
                    clickBtn: () {
                      getNewPassword();
                    },
                    textColor: Color(0xFFFFFFFF),
                    textContent: "LẤY MẬT KHẨU MỚI",
                    backgroundColor: Color(0xFF1f0ec7),
                    borderColor: Color(0xFF1f0ec7),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
