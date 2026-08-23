import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/resources/styles/app_colors.dart';
import '../../../shared/routes/app_pages.dart';
import '../bindings/initial_binding.dart';

class InitApp extends StatelessWidget {
  const InitApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Container(
        color: AppColors.bgColor,
        child: SafeArea(
          child: GetMaterialApp(
            color: AppColors.bgColor,
            defaultTransition: Transition.rightToLeft,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },

            theme: ThemeData(
              snackBarTheme: SnackBarThemeData(
                backgroundColor: AppColors.withOpacity(AppColors.black, 0.9),
              ),
              fontFamily: GoogleFonts.inter().fontFamily,
              useMaterial3: true,
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: AppColors.withOpacity(AppColors.primary, 0.3),
                cursorColor: AppColors.borderColor,
                selectionHandleColor: AppColors.primary,
              ),
            ),
            initialBinding: InitialBinding(),
            initialRoute: AppRoutes().splashView,
            getPages: AppPages().routes,
          ),
        ),
      ),
    );
  }
}
