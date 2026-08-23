import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../resources/styles/app_colors.dart';
import '../resources/styles/app_text_style.dart';

class CustomDropdown extends StatelessWidget {
  final String? label;
  final String? hint;
  final List<String> items;
  final RxString selectedValue;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Widget? customIcon;
  final Widget? prefixIcon;
  final double? borderRadius;
  final bool readOnly;

  const CustomDropdown({
    super.key,
    this.label,
    this.hint,
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.padding,
    this.backgroundColor,
    this.customIcon,
    this.prefixIcon,
    this.borderRadius,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 2,
            ),
        decoration: BoxDecoration(
          color: readOnly
              ? AppColors.darkCardColor
              : backgroundColor ??
              AppColors.withOpacity(
                AppColors.darkCardColor,
                0.5,
              ),
          borderRadius: BorderRadius.circular(
            borderRadius ?? 8,
          ),
        ),
        child: Row(
          children: [
            if (prefixIcon != null) ...[
              Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                ),
                child: prefixIcon!,
              ),
            ],
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: items.contains(selectedValue.value) &&
                    selectedValue.value.isNotEmpty
                    ? selectedValue.value
                    : null,
                dropdownColor: AppColors.darkCardColor,
                decoration: InputDecoration(
                  labelText:
                  selectedValue.value.isEmpty
                      ? label
                      : null,
                  labelStyle:
                  AppTextStyle.hintStyle(),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                  EdgeInsets.zero,
                ),
                hint: Text(
                  hint ?? '',
                  style: AppTextStyle.hintStyle(),
                ),
                style: AppTextStyle.titleRegular(),
                icon: customIcon ??
                    const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: AppColors.primary,
                    ),
                items: items.map(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style:
                        AppTextStyle.titleRegular(),
                      ),
                    );
                  },
                ).toList(),
                onChanged: readOnly
                    ? null
                    : (value) {
                  if (value != null) {
                    selectedValue.value =
                        value;

                    onChanged?.call(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}