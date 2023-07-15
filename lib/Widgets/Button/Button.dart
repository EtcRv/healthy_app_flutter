import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({
    super.key,
    required this.clickBtn,
    required this.textColor,
    required this.textContent,
    required this.backgroundColor,
    required this.borderColor,
  });

  final void Function() clickBtn;
  Color textColor;
  String textContent;
  Color backgroundColor;
  Color borderColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        clickBtn();
      },
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                width: 2,
                color: borderColor,
              )),
          backgroundColor: backgroundColor,
          fixedSize: Size.fromWidth(242)),
      child: Text(
        textContent,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
