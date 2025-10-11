import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ott/pages/Authorization/signin.dart';
import 'package:ott/pages/Main/movieVault.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    mobileNumController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> UserRegistation() async {
    // show loader
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // check is empty
    if (userNameController
            .text
            .isEmpty || // Changed from && to || for better validation
        emailController.text.isEmpty ||
        mobileNumController.text.isEmpty ||
        passwordController.text.isEmpty) {
      // pop loading
      Navigator.pop(context);

      // show alert
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
    } else {
      // create user
      try {
        UserCredential? userCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

        // add user details
        await createUserDoc(userCredentials); // Added await here

        // if mounted
        if (context.mounted) {
          // pop loading
          Navigator.pop(context);

          // navigate to movie vault home page
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MovieVault()),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        // pop loading
        Navigator.pop(context);

        // show alert
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error : ${e.message ?? e.code}')),
        );
      }
    }
  }

  // --- THIS FUNCTION HAS BEEN UPDATED ---
  Future<void> createUserDoc(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid) // using UID as the document ID
          .set({
            "email": userCredential.user!.email,
            "userName": userNameController.text.trim(),
            "phoneNumber": "+91${mobileNumController.text.trim()}",
            "address": "",
            "continueMovies": [],
            // +++ THIS IS THE LINE YOU ASKED FOR +++
            "subscriptionPlan": "No plan",
          });
    }
  }
  // --- END OF UPDATE ---

  Widget _createTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool obscureText,
  }) {
    bool _obscure = obscureText;

    return StatefulBuilder(
      builder: (context, setState) {
        return TextField(
          controller: controller,
          obscureText: _obscure,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color.fromARGB(255, 50, 50, 50),
            prefixIcon: Icon(icon, color: Colors.white54),
            suffixIcon: obscureText
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    child: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white54,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }

  Widget socialCircle(String assetPath) {
    return MaterialButton(
      onPressed: () {},
      shape: const CircleBorder(),
      height: 60,
      minWidth: 60,
      color: const Color.fromRGBO(45, 45, 45, 1),
      child: SvgPicture.asset(assetPath, width: 25, height: 25),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The rest of your UI build method remains the same...
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(29, 29, 29, 1),
        width: double.infinity,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Transform.rotate(
                                    angle: 3.14,
                                    child: const Icon(
                                      Icons.arrow_right_alt_rounded,
                                      size: 34,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "Back",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 2 / 5,
                              child: const Text(
                                "To Create an Account!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 3 / 5,
                              child: const Text(
                                "Enter the following details to Signup...",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _createTextField(
                                  controller: userNameController,
                                  hintText: "User Name*",
                                  icon: Icons.person_4_rounded,
                                  obscureText: false,
                                ),
                                const SizedBox(height: 8),
                                _createTextField(
                                  controller: emailController,
                                  hintText: "Email*",
                                  icon: Icons.email,
                                  obscureText: false,
                                ),
                                const SizedBox(height: 8),
                                _createTextField(
                                  controller: mobileNumController,
                                  hintText: "Mobile Number*",
                                  icon: Icons.phone_android,
                                  obscureText: false,
                                ),
                                const SizedBox(height: 8),
                                _createTextField(
                                  controller: passwordController,
                                  hintText: "Create Password*",
                                  icon: Icons.lock,
                                  obscureText: true,
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: const Text(
                                "By Clicking Sign-Up button, you agree to privacy policy",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: UserRegistation,
                                  color: Colors.blueAccent,
                                  height: 50,
                                  minWidth: 50,
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Sign in with",
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  socialCircle('assets/images/google.svg'),
                                  const SizedBox(width: 50),
                                  socialCircle('assets/images/apple.svg'),
                                  const SizedBox(width: 50),
                                  socialCircle('assets/images/facebook.svg'),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Already have an account?",
                                style: TextStyle(color: Colors.white70),
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Signin(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Sign-In here!",
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
