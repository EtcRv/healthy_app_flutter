import 'package:flutter/material.dart';

class FloatingInputWithInitValue extends StatefulWidget {
  FloatingInputWithInitValue(
      {super.key,
      required this.labelText,
      required this.setInputValue,
      required this.isPassword,
      required this.initValue,
      required this.keyboardType});
  var initValue;
  String labelText;
  void Function(String value) setInputValue;
  bool isPassword;
  TextInputType keyboardType;

  @override
  State<FloatingInputWithInitValue> createState() {
    return _FloatingInputWithInitValueState();
  }
}

class _FloatingInputWithInitValueState
    extends State<FloatingInputWithInitValue> {
  late TextEditingController _controller =
      TextEditingController(text: widget.initValue);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      controller: _controller,
      obscureText: widget.isPassword,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) {
            return TextStyle(color: Color(0xFF8d8888), letterSpacing: 1.3);
          },
        ),
      ),
      onChanged: (value) {
        widget.setInputValue(value);
        _controller.text = value;
        _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));
      },
    );
  }
}
