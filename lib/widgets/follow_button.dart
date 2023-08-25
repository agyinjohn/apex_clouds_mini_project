import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? funtion;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
   final double widthI ;
  final String text;
  const FollowButton(
      {required this.borderColor,
      this.funtion,
      this.widthI = 250,
      required this.text,
      required this.textColor,
      required this.backgroundColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4),
      child: TextButton(
        onPressed: funtion,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: borderColor),
              color: backgroundColor),
          alignment: Alignment.center,
          width: widthI,
          height: 30,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
