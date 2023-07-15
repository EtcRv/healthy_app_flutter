import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PredictCovidScreen extends StatefulWidget {
  const PredictCovidScreen({super.key});

  @override
  State<PredictCovidScreen> createState() {
    return _PredictCovidScreenState();
  }
}

class _PredictCovidScreenState extends State<PredictCovidScreen> {
  bool sot = false;
  bool ho = false;
  bool viemhong = false;
  bool khotho = false;
  bool daudau = false;
  bool gender = false;

  @override
  void initState() {
    super.initState();
  }

  void predictCovid() async {
    int sotInput = sot == false ? 0 : 1;
    int hoInput = ho == false ? 0 : 1;
    int viemhongInput = viemhong == false ? 0 : 1;
    int khothoInput = khotho == false ? 0 : 1;
    int daudauInput = daudau == false ? 0 : 1;
    int genderInput = gender == false ? 0 : 1;
    final model = await Interpreter.fromAsset('assets/model/model.tflite');
    var input = [
      [sotInput, hoInput, viemhongInput, khothoInput, daudauInput, genderInput]
    ];
    var output = List.filled(1 * 3, 0).reshape([1, 3]);
    model.run(input, output);
    print(output);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Predict Test Covid"),
      ),
      body: Column(children: [
        Expanded(
          child: Row(
            children: [
              const Text("Sốt"),
              const SizedBox(
                width: 16,
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
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: Row(
            children: [
              const Text("Ho"),
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
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: Row(
            children: [
              const Text("Viêm họng"),
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
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: Row(
            children: [
              const Text("Khó thở"),
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
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: Row(
            children: [
              const Text("Đau đầu"),
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
        ),
        const SizedBox(
          height: 16,
        ),
        TextButton(
          onPressed: () {
            predictCovid();
          },
          child: Text("Predict"),
        )
      ]),
    );
  }
}
