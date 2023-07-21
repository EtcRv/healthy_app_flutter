import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app_flutter/Widgets/Button/Button.dart';
import 'package:healthy_app_flutter/models/models.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

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

  void predictCovid() async {
    int sotInput = sot == false ? 0 : 1;
    int hoInput = ho == false ? 0 : 1;
    int viemhongInput = viemhong == false ? 0 : 1;
    int khothoInput = khotho == false ? 0 : 1;
    int daudauInput = daudau == false ? 0 : 1;
    int genderInput = gender == 'female' ? 0 : 1;
    final model = await Interpreter.fromAsset('assets/model/model.tflite');
    var input = [
      [sotInput, hoInput, viemhongInput, khothoInput, daudauInput, genderInput]
    ];
    var output = List.filled(1 * 3, 0).reshape([1, 3]);
    model.run(input, output);
    setState(() {
      result = output[0][1];
    });
    var newReference = predictCovidDatabase.push();
    newReference.set({
      "user": {
        "name": widget.userState.name,
        "email": widget.userState.email,
        "age": widget.userState.age,
        "gender": widget.userState.gender,
        "quequan": widget.userState.quequan,
        "noio": widget.userState.noio,
      },
      "trieuchung": {
        "sot": sotInput,
        "ho": hoInput,
        "viemhong": viemhongInput,
        "khotho": khothoInput,
        "daudau": daudauInput,
      },
      "result": result
    });
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
