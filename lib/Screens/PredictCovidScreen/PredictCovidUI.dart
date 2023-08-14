import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app_flutter/Widgets/Button/Button.dart';
import 'package:healthy_app_flutter/models/models.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PredictCovidUI extends StatefulWidget {
  PredictCovidUI({super.key, required this.userState, required this.logout});
  UserModel userState;
  void Function() logout;

  @override
  State<PredictCovidUI> createState() {
    return _PredictCovidUIState();
  }
}

class _PredictCovidUIState extends State<PredictCovidUI> {
  DatabaseReference predictCovidDatabase =
      FirebaseDatabase.instance.ref('/predict');

  bool sot = false;
  bool ho = false;
  bool viemhong = false;
  bool khotho = false;
  bool daudau = false;
  String gender = '';
  double result = -1;
  List<String> predict_input = [
    '00000',
    '00001',
    '00010',
    '00011',
    '00100',
    '00101',
    '00110',
    '00111',
    '01000',
    '01001',
    '01010',
    '01011',
    '01100',
    '01101',
    '01110',
    '01111',
    '10000',
    '10001',
    '10010',
    '10011',
    '10100',
    '10101',
    '10110',
    '10111',
    '11000',
    '11001',
    '11010',
    '11011',
    '11100',
    '11101',
    '11110',
    '11111',
  ];

  List<double> list_result_predict_male = [
    0.0843,
    0.1913,
    0.1771,
    0.3271,
    0.1890,
    0.3484,
    0.3348,
    0.4871,
    0.1843,
    0.3340,
    0.3197,
    0.4621,
    0.3408,
    0.4877,
    0.4752,
    0.5837,
    0.2099,
    0.3734,
    0.3612,
    0.5081,
    0.3709,
    0.5225,
    0.5170,
    0.6216,
    0.3689,
    0.5135,
    0.5046,
    0.6068,
    0.5161,
    0.6195,
    0.6120,
    0.6786
  ];

  List<double> list_result_predict_female = [
    0.1243,
    0.2641,
    0.2481,
    0.4108,
    0.2593,
    0.4289,
    0.4149,
    0.5535,
    0.2542,
    0.4146,
    0.3982,
    0.5304,
    0.4139,
    0.5496,
    0.5350,
    0.6290,
    0.2847,
    0.4496,
    0.4412,
    0.5690,
    0.4463,
    0.5791,
    0.5739,
    0.6590,
    0.4453,
    0.5721,
    0.5632,
    0.6468,
    0.5698,
    0.6564,
    0.6481,
    0.7027
  ];

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Map<String, String> headers = {"Content-type": "application/json"};
  void predictCovid() async {
    int sotInput = sot == false ? 0 : 1;
    int hoInput = ho == false ? 0 : 1;
    int viemhongInput = viemhong == false ? 0 : 1;
    int khothoInput = khotho == false ? 0 : 1;
    int daudauInput = daudau == false ? 0 : 1;
    int genderInput = gender == 'female' ? 0 : 1;

    if (defaultTargetPlatform == TargetPlatform.android) {
      final model = await Interpreter.fromAsset('assets/model/model.tflite');
      var input = [
        [
          sotInput,
          hoInput,
          viemhongInput,
          khothoInput,
          daudauInput,
          genderInput
        ]
      ];
      var output = List.filled(1 * 3, 0).reshape([1, 3]);
      model.run(input, output);
      setState(() {
        result = output[0][1];
      });
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      var input_arr = [
        sotInput,
        hoInput,
        viemhongInput,
        khothoInput,
        daudauInput
      ];
      String binaryString = input_arr.join('');
      if (genderInput == 1) {
        for (var i = 0; i < 32; i++) {
          if (predict_input[i] == binaryString) {
            setState(() {
              result = list_result_predict_male[i];
            });
            break;
          }
        }
      } else {
        for (var i = 0; i < 32; i++) {
          if (predict_input[i] == binaryString) {
            setState(() {
              result = list_result_predict_female[i];
            });
            break;
          }
        }
      }

      final response =
          await http.post(Uri.http("localhost:8000", "/api/add-predict"),
              headers: headers,
              body: json.encode({
                'name': widget.userState.name,
                "age": widget.userState.age,
                "gender": widget.userState.gender,
                "noio": widget.userState.noio,
                "sot": sotInput,
                "ho": hoInput,
                "viemhong": viemhongInput,
                "khotho": khothoInput,
                "daudau": daudauInput,
                "result": result
              }));
    }

    // var newReference = predictCovidDatabase.push();
    // newReference.set({
    //   "user": {
    //     "name": widget.userState.name,
    //     "email": widget.userState.email,
    //     "age": widget.userState.age,
    //     "gender": widget.userState.gender,
    //     "quequan": widget.userState.quequan,
    //     "noio": widget.userState.noio,
    //   },
    //   "trieuchung": {
    //     "sot": sotInput,
    //     "ho": hoInput,
    //     "viemhong": viemhongInput,
    //     "khotho": khothoInput,
    //     "daudau": daudauInput,
    //   },
    //   "result": result
    // });

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.isPhysicalDevice) {
        final response =
            await http.post(Uri.http("localhost:8000", "/api/add-predict"),
                headers: headers,
                body: json.encode({
                  'name': widget.userState.name,
                  "age": widget.userState.age,
                  "gender": widget.userState.gender,
                  "noio": widget.userState.noio,
                  "sot": sotInput,
                  "ho": hoInput,
                  "viemhong": viemhongInput,
                  "khotho": khothoInput,
                  "daudau": daudauInput,
                  "result": result
                }));
      } else {
        final response =
            await http.post(Uri.http("10.0.2.2:8000", "/api/add-predict"),
                headers: headers,
                body: json.encode({
                  'name': widget.userState.name,
                  "age": widget.userState.age,
                  "gender": widget.userState.gender,
                  "noio": widget.userState.noio,
                  "sot": sotInput,
                  "ho": hoInput,
                  "viemhong": viemhongInput,
                  "khotho": khothoInput,
                  "daudau": daudauInput,
                  "result": result
                }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 1;
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: widthScreen * 0.1),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Các triệu chứng mà bạn đang mắc phải',
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sốt",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Checkbox(
                      value: sot,
                      onChanged: (bool? value) {
                        setState(() {
                          sot = value!;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Ho",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Checkbox(
                      value: ho,
                      onChanged: (bool? value) {
                        setState(() {
                          ho = value!;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Viêm họng",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Checkbox(
                      value: viemhong,
                      onChanged: (bool? value) {
                        setState(() {
                          viemhong = value!;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Khó thở",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Checkbox(
                      value: khotho,
                      onChanged: (bool? value) {
                        setState(() {
                          khotho = value!;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Đau đầu",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Checkbox(
                      value: daudau,
                      onChanged: (bool? value) {
                        setState(() {
                          daudau = value!;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: result > -1,
                  child: Text(
                    "Bạn có khả năng dương tính là ${(result * 100).toStringAsFixed(2)} %",
                    style: TextStyle(
                      color: result * 100 > 50
                          ? const Color(0xffd72020)
                          : const Color(0xff13c26a),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Button(
                  clickBtn: () {
                    setState(() {
                      gender = widget.userState.gender;
                    });
                    predictCovid();
                  },
                  textColor: Color(0xFFFFFFFF),
                  textContent: "Chẩn đoán",
                  backgroundColor: Color(0xFF1f0ec7),
                  borderColor: Color(0xFF1f0ec7),
                ),
              ]),
        ),
      ),
    );
  }
}
