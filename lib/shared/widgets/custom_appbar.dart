import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../resources/styles/app_colors.dart';
import '../resources/styles/app_text_style.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final double? titleFontSize;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
    this.backgroundColor,
    this.titleFontSize,
    this.actions,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
      backgroundColor ?? AppColors.bgColor,
      elevation: 0,
      centerTitle: true,

      leading: showBackButton
          ? Padding(
        padding: const EdgeInsets.only(
          top: 7,
          left: 15,
          bottom: 9,
        ),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            border: Border.all(
              color: AppColors.withOpacity(
                AppColors.secondary,
                0.2,
              ),
              width: 0.5,
            ),
            borderRadius:
            BorderRadius.circular(14),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.navigate_before,
              color: AppColors.textColor,
            ),
            iconSize: 26,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            onPressed:
            onBack ?? () => Get.back(),
          ),
        ),
      )
          : null,

      title: Text(
        title,
        style: AppTextStyle.titleBold(
          fontSize: titleFontSize ?? 18,
        ),
      ),

      actions: actions,
    );
  }
}