import 'package:flutter/material.dart';
import '../resources/styles/app_colors.dart';
import '../resources/styles/app_text_style.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.fontSize,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: padding ?? EdgeInsets.zero,
        foregroundColor: textColor ?? AppColors.primary,
      ),
      child: Text(
        text,
        style: textStyle ??
            AppTextStyle.titleRegular(
              fontSize: fontSize ?? 14,
              color: textColor ?? AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}