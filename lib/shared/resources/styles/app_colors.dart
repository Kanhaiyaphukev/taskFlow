import 'package:flutter/widgets.dart';

///To use colors only as per instance object even if it is same color give different name.
abstract class AppColors {
  static const Color primary = Color(0xFF00D1B2);
  static const Color secondary = Color(0xFFFF7F50);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFB3B3B3);
  static const Color bgColor = Color(0xFF090B0A);
  static const Color dashboardCardBg = Color(0xFF101A17);
  static const Color transparent = Color(0x00000000);
  static const Color grey = Color(0xFF6E6E6E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFFB2C36);
  static const Color black = Color(0xFF000000);
  static const Color green = Color(0xFF00C950);
  static const Color darkCardColor = Color(0xFF1C1C1E);
  static const Color hintColor = Color(0x80F5F5F5);
  static const Color inactiveBorder = Color(0xFF6C6C70);
  static const Color gold = Color(0xFFFFB800);

  static Color withOpacity(Color color, double opacity) {
    return color.withAlpha((opacity * 255).toInt());
  }

  /// Convert `#RRGGBB` to [Color] safely.
  static Color hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) return white;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return white;
    }
  }
}
