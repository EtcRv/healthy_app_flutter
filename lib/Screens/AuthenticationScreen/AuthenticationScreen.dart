import 'package:flutter/material.dart';
import 'package:healthy_app_flutter/Screens/LoginScreen/LoginScreen.dart';
import 'package:healthy_app_flutter/Screens/RegisterScreen/RegisterScreen.dart';
import 'package:healthy_app_flutter/Widgets/Button/Button.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                width: widthScreen,
                child: const Image(
                  image: AssetImage('assets/images/dienluc.jpg'),
                  width: 150,
                  height: 150,
                  alignment: Alignment.topLeft,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: widthScreen,
                    child: const Column(
                      children: [
                        Image(
                          image: AssetImage('assets/images/covid19.png'),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "An toàn cho bản thân và xã hội trước Covid-19",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 242),
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Column(
                      children: [
                        Button(
                          clickBtn: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          textColor: Colors.white,
                          textContent: "Đăng nhập",
                          backgroundColor: Color(0xFF007AFF),
                          borderColor: Color(0xFF007AFF),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Button(
                          clickBtn: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          textColor: Color(0xFF007AFF),
                          textContent: "Đăng ký",
                          backgroundColor: Colors.white,
                          borderColor: Color(0xFF007AFF),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
