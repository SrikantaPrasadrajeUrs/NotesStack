import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final TextStyle textStyle;
  final Color buttonBackgroundColor;
  final double height;
  final double width;
  final BoxBorder? border;

  const CustomButton({super.key,
    this.height = 50,
    this.width = 200,
    this.border,
    required this.onPressed, required this.text, required this.textStyle, required this.buttonBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonBackgroundColor,
          borderRadius: BorderRadius.circular(30),
          border: border,
        ),
        child: Text(text, style: textStyle),
      ),
    );
  }
}
