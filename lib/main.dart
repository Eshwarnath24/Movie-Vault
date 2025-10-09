import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ott/firebase_options.dart';
import 'package:ott/pages/Authorization/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
