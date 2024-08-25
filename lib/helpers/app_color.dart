import 'dart:ui';

import 'package:flutter/material.dart';

extension CustomThemeData on ThemeData {
  Color get red => Colors.red;
  Color get black => Colors.black;
  Color get textColorSecondary {
    return brightness == Brightness.light ? Colors.white : Colors.black;
  }

  Color get grey {
    return brightness == Brightness.light
        ? const Color(0xFFF7F8F9)
        : Colors.black12;
  }

  Color get textColor {
    return brightness == Brightness.light ? Colors.black : Colors.white;
  }

  double get borderWidth {
    return brightness == Brightness.light ? 1.0 : 0.3;
  }
}
