import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;
  const SocialButton({super.key, required this.imagePath, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 100,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 2,
            spreadRadius: 2
          )
        ]
      ),
      child: Image.asset(imagePath),
    );
  }
}
