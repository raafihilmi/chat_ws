import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final Color colorText;
  final Color colorBg;

  const MyButton({super.key, required this.text, required this.onTap, required this.colorText,required this.colorBg});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: colorBg,
            borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: colorText),
          ),
        ),
      ),
    );
  }
}
