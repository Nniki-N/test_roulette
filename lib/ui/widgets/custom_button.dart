import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    required this.text,
    double width = double.infinity,
    this.height = 50,
  }) : super(key: key) {
    this.width = width != double.infinity ? width : double.infinity;
  }

  final String text;
  late final double width;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: foregroundColor,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}