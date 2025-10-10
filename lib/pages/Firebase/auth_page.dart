import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ott/pages/Authorization/signin.dart';
import 'package:ott/pages/Main/movieVault.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();

    // 🔹 Clear all previous routes after this widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthPageView()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Temporary empty widget (since we'll replace with AuthPageView)
    return const SizedBox.shrink();
  }
}

// 🔹 This widget handles FirebaseAuth state stream safely
class AuthPageView extends StatelessWidget {
  const AuthPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Optional: show a loading spinner
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            // 🔹 User is logged in → Go to MovieVault
            return const MovieVault();
          } else {
            // 🔹 User not logged in → Go to Signin page
            return const Signin();
          }
        },
      ),
    );
  }
}
