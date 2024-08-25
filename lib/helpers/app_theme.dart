import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
  primaryColor: const Color(0xFFF5F5F5),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
    bodyColor: Colors.black87,
    displayColor: Colors.black87,
  ),
  colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.yellow,
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.black),
  inputDecorationTheme: InputDecorationTheme(
    filled: false,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF707070), width: .3)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF707070), width: .3)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF5FA3D7), width: .3)),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Colors.red, width: .3),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Colors.red, width: .3),
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: const Color(0xFFF5F5F5), // Match scaffold background
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    // titleTextStyle:
    //     GoogleFonts.latoTextTheme().titleLarge?.copyWith(
    //           color: Colors.black87,
    //         ),
    // contentTextStyle:
    //     GoogleFonts.latoTextTheme().bodyMedium?.copyWith(
    //           color: Colors.black87,
    //         ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.yellow, // Use seedColor
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minimumSize: Size(0, 50.h),
    ),
  ),
);

final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  primaryColor: const Color(0xFF212121),
  scaffoldBackgroundColor: const Color(0xFF212121),
  textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.yellow,
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.white),
  dialogTheme: DialogTheme(
    backgroundColor: const Color(0xFF212121), // Match scaffold background
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    // titleTextStyle:
    //     GoogleFonts.latoTextTheme().titleLarge?.copyWith(
    //           color: Colors.white70,
    //         ),
    // contentTextStyle:
    //     GoogleFonts.latoTextTheme().bodyMedium?.copyWith(
    //           color: Colors.white70,
    //         ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: false, //const Color(0xFF181818),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF707070), width: .3)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF707070), width: .3)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF5FA3D7), width: .3)),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Colors.red, width: .3),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Colors.red, width: .3),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.yellow, // Use seedColor
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minimumSize: Size(0, 50.h),
    ),
  ),
);
