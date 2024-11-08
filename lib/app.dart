import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/splash_screen.dart';
import 'package:task_manager/ui/utils/app_color.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static  GlobalKey<NavigatorState>navigatorKey= GlobalKey<NavigatorState>();
  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(),
          inputDecorationTheme: _InputDecorationTheme(),
          elevatedButtonTheme: _elevatedButtonThemeData()),
      home: const SplashScreen(),
    );
  }

  ElevatedButtonThemeData _elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.themeColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          fixedSize: Size.fromWidth(double.maxFinite),
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(8))),
    );
  }

  InputDecorationTheme _InputDecorationTheme() {
    return InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        // Ensure good visibility on any background
        border: _InputBorder(),
        enabledBorder: _InputBorder(),
        errorBorder: _InputBorder(),
        focusedBorder: _InputBorder());
  }

  OutlineInputBorder _InputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
          // color: Colors.green.withOpacity(.4),
          color: Colors.grey),
    );
  }
}
