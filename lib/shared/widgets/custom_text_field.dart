import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../resources/styles/app_colors.dart';
import '../resources/styles/app_text_style.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final int? maxLength;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final String? prefixText;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final TextAlign textAlign;
  final bool isDateField;
  final Widget? logoIcon;
  final Alignment? alignment;
  final double? height;
  final double? width;
  final double? contentPaddingVertical;
  final double? contentPaddingHorizontal;
  final double? fontSize;
  final InputDecoration? decoration;
  final BoxDecoration? boxDecoration;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<DateTime>? onDatePickedValidator;
  final bool isMultiline;
  final Color? focusedBorderColor;
  final Color? readOnlyFillColor;
  final Color? readOnlyBorderColor;
  final Color? fillTextColor;
  final Color? fillColor;
  final bool isMandatory;

  const CustomTextField({
    super.key,
    this.controller,
    this.maxLength,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.isDateField = false,
    this.logoIcon,
    this.alignment,
    this.height,
    this.width,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.fontSize,
    this.decoration,
    this.boxDecoration,
    this.errorText,
    this.inputFormatters,
    this.onDatePickedValidator,
    this.isMultiline = false,
    this.focusedBorderColor,
    this.readOnlyFillColor,
    this.readOnlyBorderColor,
    this.fillColor,
    this.fillTextColor,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget textField = Focus(
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        obscureText: obscureText,
        readOnly: readOnly || isDateField,
        textInputAction: textInputAction,
        onTap: isDateField
            ? () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColors.primary,
                    surface: AppColors.darkCardColor,
                    onSurface: AppColors.textColor,
                  ),
                  textTheme: TextTheme(
                    titleMedium: TextStyle(
                      color: AppColors.textColor,
                    ),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null && controller != null) {
            final validationMessage =
            onDatePickedValidator?.call(pickedDate);

            if (validationMessage == null) {
              controller!.text = DateFormat(
                'dd-MM-yyyy',
              ).format(pickedDate);

              onChanged?.call(controller!.text);
            } else {
              controller!.clear();
              onChanged?.call('');
            }
          }
        }
            : onTap,
        focusNode: focusNode,
        onChanged: onChanged,
        keyboardType: keyboardType,
        textAlign: textAlign,
        style: AppTextStyle.titleRegular(
          fontSize: fontSize ?? 18,
          fontWeight: FontWeight.normal,
          color: fillTextColor ?? AppColors.textColor,
        ),
        cursorColor: AppColors.borderColor,
        inputFormatters: inputFormatters,
        maxLines: isMultiline ? null : 1,
        minLines: isMultiline ? 3 : 1,
        decoration:
        decoration ??
            InputDecoration(
              counterText: '',
              hintText: hintText,
              label: labelText != null
                  ? RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: labelText!,
                      style: AppTextStyle.hintStyle(),
                    ),
                    if (isMandatory)
                      TextSpan(
                        text: '  *',
                        style: TextStyle(
                          color: AppColors.withOpacity(
                            AppColors.red,
                            0.7,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              )
                  : null,
              hintStyle: AppTextStyle.hintStyle(),
              filled: true,
              fillColor: readOnly
                  ? readOnlyFillColor ?? AppColors.darkCardColor
                  : fillColor ??
                  AppColors.withOpacity(
                    AppColors.darkCardColor,
                    0.5,
                  ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color:
                  focusedBorderColor ??
                      AppColors.withOpacity(
                        AppColors.inactiveBorder,
                        0.1,
                      ),
                  width: 0.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.withOpacity(
                    AppColors.primary,
                    0.5,
                  ),
                  width: 0.5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: contentPaddingHorizontal ?? 18,
                vertical: contentPaddingVertical ?? 16,
              ),
              prefixIcon: logoIcon ?? prefixIcon,
              prefixText: prefixText,
              prefixStyle: AppTextStyle.titleRegular(
                fontSize: fontSize ?? 17,
                fontWeight: FontWeight.normal,
                color: AppColors.textColor,
              ),
              suffixIcon: suffixIcon != null
                  ? Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  top: 5,
                  bottom: 5,
                ),
                child: suffixIcon,
              )
                  : null,
              errorText: errorText,
            ),
      ),
    );

    return Align(
      alignment: alignment ?? Alignment.centerLeft,
      child: SizedBox(
        width: width,
        height: isMultiline ? null : (height ?? 55),
        child: Container(
          decoration: boxDecoration,
          child: textField,
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
    );
  }
}