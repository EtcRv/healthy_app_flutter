import 'package:flutter/material.dart';
import 'package:healthy_app_flutter/Widgets/Button/Button.dart';
import 'package:healthy_app_flutter/Widgets/FloatingInput/FloatingInput.dart';

import '../LoginScreen/LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name = '';
  String email = '';
  String password = '';
  String rePassword = '';

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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Tạo tài khoản!',
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
                  'Hãy nhập các thông tin dưới đây để tạo tài khoản mới',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingInput(
                  labelText: 'Họ và tên',
                  setInputValue: ((value) {
                    setState(() {
                      name = value;
                    });
                  }),
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
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingInput(
                  labelText: 'Mật khẩu',
                  setInputValue: ((value) {
                    setState(() {
                      password = value;
                    });
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingInput(
                  labelText: 'Nhập lại mật khẩu',
                  setInputValue: ((value) {
                    setState(() {
                      rePassword = value;
                    });
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Button(
                    clickBtn: () {},
                    textColor: Color(0xFFFFFFFF),
                    textContent: "ĐĂNG KÝ",
                    backgroundColor: Color(0xFF1f0ec7),
                    borderColor: Color(0xFF1f0ec7),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Bạn đã có tài khoản?",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff76727a),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff76727a),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
