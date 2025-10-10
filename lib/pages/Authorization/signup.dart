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
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // check is empty
    if (userNameController.text.isEmpty &&
        emailController.text.isEmpty &&
        mobileNumController.text.isEmpty &&
        passwordController.text.isEmpty) {
      // pop loading
      Navigator.pop(context);

      // show alert
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter Credentials')));
    } else {
      // create user
      try {
        UserCredential? userCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

        // add user details
        createUserDoc(userCredentials);

        // if mounted
        if (context.mounted) {
          // pop loading
          Navigator.pop(context);

          // clear controller
          userNameController.clear();
          emailController.clear();
          mobileNumController.clear();
          passwordController.clear();

          // navigate to movie vault home page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieVault()),
          );
        }
      } on FirebaseAuthException catch (e) {
        // pop loading
        Navigator.pop(context);

        // show alert
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error : ${e.code}')));
      }
    }
  }

  void createUserDoc(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid) // using UID as the document ID
          .set({
            "email": userCredential.user!.email,
            "password": passwordController.text.trim(),
            "userName": userNameController.text.trim(),
            "phoneNumber": "+91" + mobileNumController.text.trim(),
            "address": "",
          });
    }
  }

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
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Color.fromARGB(255, 50, 50, 50),
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
      shape: CircleBorder(),
      height: 60,
      minWidth: 60,
      color: Color.fromRGBO(45, 45, 45, 1),
      child: SvgPicture.asset(assetPath, width: 25, height: 25),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(29, 29, 29, 1),
        width: double.infinity,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),

            // learn

            // We use LayoutBuilder and ConstrainedBox to make our Column take up at least the full screen height.
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      // This will push the two main child widgets to the top and bottom of the screen.
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // This column holds all the content for the top part of the screen.

                        // till here
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
                                    child: Icon(
                                      Icons.arrow_right_alt_rounded,
                                      size: 34,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Back",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 2 / 5,
                              child: Text(
                                "To Create an Account!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 3 / 5,
                              child: Text(
                                "Enter the following details to Signup...",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            SizedBox(height: 30),
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
                                SizedBox(height: 8),

                                _createTextField(
                                  controller: emailController,
                                  hintText: "Email*",
                                  icon: Icons.email,
                                  obscureText: false,
                                ),
                                SizedBox(height: 8),

                                _createTextField(
                                  controller: mobileNumController,
                                  hintText: "Mobile Number*",
                                  icon: Icons.phone_android,
                                  obscureText: false,
                                ),
                                SizedBox(height: 8),

                                _createTextField(
                                  controller: passwordController,
                                  hintText: "Create Password*",
                                  icon: Icons.lock,
                                  obscureText: true,
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                            SizedBox(height: 15),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                "By Clicking Sign-Up button, you agree to privacy policy",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
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
                                  shape: CircleBorder(),
                                  child: Icon(
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
                              Text(
                                "Sign in with",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // google
                                  socialCircle('assets/images/google.svg'),
                                  SizedBox(width: 50),

                                  // apple
                                  socialCircle('assets/images/apple.svg'),
                                  SizedBox(width: 50),

                                  // facebook
                                  socialCircle('assets/images/facebook.svg'),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Already have an account?",
                                style: TextStyle(color: Colors.white70),
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Signin(),
                                      ),
                                    );
                                  },
                                  child: Text(
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
