import 'package:flutter/material.dart';
import '../resources/styles/app_colors.dart';
import '../resources/styles/app_space_between.dart';
import '../resources/styles/app_text_style.dart';


class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double height;
  final double width;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isLoading;
  final Color? loadingIndicatorColor;

  /// Existing custom border support
  final BorderSide? borderSide;

  /// New border properties
  final Color? borderColor;
  final double borderWidth;

  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final TextAlign? textAlign;
  final double? elevation;
  final TextStyle? textStyle;
  final bool isPlainTextButton;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.height = 54,
    this.width = double.infinity,
    this.borderRadius = 28,
    this.padding,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.loadingIndicatorColor,
    this.borderSide,
    this.borderColor,
    this.borderWidth = 1,
    this.boxShadow,
    this.gradient,
    this.textAlign,
    this.elevation,
    this.textStyle,
    this.isPlainTextButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    final EdgeInsetsGeometry resolvedPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

    final Widget childText = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                loadingIndicatorColor ??
                    textColor ??
                    (isPlainTextButton ? AppColors.primary : AppColors.white),
              ),
            ),
          )
        : Text(
            text,
            textAlign: textAlign ?? TextAlign.center,
            style:
                textStyle ??
                AppTextStyle.titleBold(
                  fontSize: fontSize ?? 16,
                  fontWeight: fontWeight ?? FontWeight.bold,
                  color: isDisabled
                      ? (isPlainTextButton
                            ? AppColors.withOpacity(AppColors.primary, 0.1)
                            : AppColors.textColor)
                      : (textColor ??
                            (isPlainTextButton
                                ? AppColors.primary
                                : AppColors.black)),
                ),
          );

    final List<Widget> children = [];

    if (prefixIcon != null && !isLoading) {
      children.add(prefixIcon!);
      children.add(gapW8);
    }

    children.add(childText);

    if (suffixIcon != null && !isLoading) {
      children.add(gapW8);
      children.add(suffixIcon!);
    }

    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPlainTextButton
              ? Colors.transparent
              : (gradient != null
                    ? null
                    : (backgroundColor ?? AppColors.primary)),
          foregroundColor:
              foregroundColor ??
              (isPlainTextButton ? AppColors.primary : AppColors.white),
          elevation: isPlainTextButton ? 0 : (elevation ?? 0),
          shadowColor: AppColors.borderColor,
          padding: resolvedPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side:
                borderSide ??
                (borderColor != null
                    ? BorderSide(color: borderColor!, width: borderWidth)
                    : BorderSide.none),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
