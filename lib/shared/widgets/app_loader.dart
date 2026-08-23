import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../resources/styles/app_colors.dart';

class AppLoader {
  AppLoader._();

  static void popUpLoader(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black12,
      context: context,
      builder: (_) {
        return LoadingAnimationWidget.flickr(
          size: 80,
          leftDotColor: AppColors.white,
          rightDotColor: AppColors.primary,
        );
      },
    );
  }

  static Widget onScreenLoader() {
    return Center(
      child: LoadingAnimationWidget.flickr(
        size: 80,
        leftDotColor: AppColors.white,
        rightDotColor: AppColors.primary,
      ),
    );
  }

  static Widget circularLoader() {
    return Center(
      child: LoadingAnimationWidget.beat(size: 30, color: AppColors.primary),
    );
  }

  static Widget onScreenLoaderWithScaffold() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: LoadingAnimationWidget.flickr(
          size: 80,
          leftDotColor: AppColors.white,
          rightDotColor: AppColors.primary,
        ),
      ),
    );
  }
}
