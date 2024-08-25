import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicktasks/helpers/app_theme.dart';

import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);
    return ScreenUtilInit(
      designSize: const Size(380, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp(
          title: 'Quick Tasks',
          themeMode: themeNotifier.currentTheme,
          theme: themeNotifier.currentTheme == ThemeMode.dark
              ? darkTheme
              : lightTheme,
          darkTheme: darkTheme,
          home: child,
        );
      },
      child: const HomeScreen(),
    );
  }
}
