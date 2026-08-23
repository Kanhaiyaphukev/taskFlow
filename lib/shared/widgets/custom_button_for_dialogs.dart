import 'package:flutter/material.dart';

import '../resources/styles/app_colors.dart';


class CustomButtonForDialogs extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onPressed;

  const CustomButtonForDialogs({
    super.key,
    required this.title,
    this.fontSize,
    this.backgroundColor = AppColors.primary,
    this.borderColor = AppColors.borderColor,
    this.textColor = AppColors.black,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize ?? 14,
              fontWeight:  FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
