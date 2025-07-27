import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
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
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.buttonBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: widget.border,
        ),
        child: Text(widget.text, style: widget.textStyle),
      ),
    );
  }
}
