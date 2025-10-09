import 'package:flutter/material.dart';
import 'package:ott/pages/Authorization/splashScreen.dart';
import 'package:ott/pages/Main/movieVault.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(primary: Colors.blue),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color.fromRGBO(29, 29, 29, 1),
        primaryColor: Colors.white70,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(29, 29, 29, 1),
          foregroundColor: Colors.white70,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
