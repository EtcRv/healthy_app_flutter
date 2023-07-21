import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:healthy_app_flutter/Widgets/Button/Button.dart';
import 'package:healthy_app_flutter/Widgets/FloatingInput/FloatingInput.dart';
import 'package:healthy_app_flutter/Widgets/FloatingInputWithInitValue/FloatingInputWithInitValue.dart';
import 'package:healthy_app_flutter/core/actions/actions.dart';
import 'package:healthy_app_flutter/models/models.dart';
import 'package:redux/redux.dart';

class HomeScreenUI extends StatefulWidget {
  HomeScreenUI(
      {super.key,
      required this.name,
      required this.age,
      required this.gender,
      required this.noio,
      required this.quequan,
      required this.saveInformation,
      required this.userInfo,
      required this.logout});
  String name = '';
  String noio = '';
  String quequan = '';
  String gender = 'male';
  int age = 0;
  void Function(UserModel user) saveInformation;
  void Function() logout;
  UserModel userInfo;

  @override
  State<HomeScreenUI> createState() {
    return _HomeScreenUIState();
  }
}

enum Gender { male, female }

class _HomeScreenUIState extends State<HomeScreenUI> {
  int _selectedIndex = 0;
  late Gender? _gender;
  late TextEditingController _ageController;
  String name = '';
  String noio = '';
  String quequan = '';
  String gender = '';
  int age = 0;

  @override
  void initState() {
    super.initState();
    _gender = widget.gender == 'male' ? Gender.male : Gender.female;
    _ageController = TextEditingController(text: widget.age.toString());
    name = widget.name;
    noio = widget.noio;
    quequan = widget.quequan;
    gender = widget.gender;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
      drawer: Drawer(
        width: 200,
        backgroundColor: Colors.white,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 30,
            ),
            ListTile(
              title: const Text('Thông tin cá nhân'),
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              title: const Text('Dự đoán Covid'),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/predict');
              },
            ),
            ListTile(
              title: const Text('Đăng xuất'),
              selected: _selectedIndex == 2,
              onTap: () {
                widget.logout();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Sửa thông tin cá nhân của bạn!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingInputWithInitValue(
                  labelText: 'Họ và tên',
                  setInputValue: ((value) {
                    setState(() {
                      name = value;
                    });
                  }),
                  isPassword: false,
                  initValue: name,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingInputWithInitValue(
                  labelText: 'Nơi ở',
                  setInputValue: ((value) {
                    setState(() {
                      noio = value;
                    });
                  }),
                  isPassword: false,
                  initValue: noio,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingInputWithInitValue(
                  labelText: 'Quê quán',
                  setInputValue: ((value) {
                    setState(() {
                      quequan = value;
                    });
                  }),
                  isPassword: false,
                  initValue: quequan,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _ageController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Tuổi tác',
                    floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                      (Set<MaterialState> states) {
                        return TextStyle(
                            color: Color(0xFF8d8888), letterSpacing: 1.3);
                      },
                    ),
                  ),
                  onChanged: (value) {
                    _ageController.text = value;
                    _ageController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _ageController.text.length));
                    setState(() {
                      age = value != null ? int.parse(value) : 0;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: widthScreen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Giới tính',
                        style: TextStyle(
                          color: Color(0xFF8d8888),
                          letterSpacing: 1.3,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                  value: Gender.male,
                                  groupValue: _gender,
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      widget.gender = 'male';
                                      _gender = value;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text('Nam'),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                  value: Gender.female,
                                  groupValue: _gender,
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      widget.gender = 'female';
                                      _gender = value;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text('Nữ'),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Button(
                  clickBtn: () {
                    widget.saveInformation(UserModel(
                        widget.userInfo.uuid,
                        widget.userInfo.email,
                        name,
                        gender,
                        noio,
                        quequan,
                        age));
                  },
                  textColor: Color(0xFFFFFFFF),
                  textContent: "Lưu thông tin",
                  backgroundColor: Color(0xFF1f0ec7),
                  borderColor: Color(0xFF1f0ec7),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
