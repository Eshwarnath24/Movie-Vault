import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ott/pages/signin.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _obscureText = true;

  Widget _createTextField(IconData icon, String hintText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Color.fromRGBO(45, 45, 45, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white70),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 15, color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
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
                                _createTextField(Icons.person_4_rounded, "Enter the Full Name*"),
                                
                                _createTextField(Icons.email, "Enter Email*"),

                                _createTextField(Icons.phone_android, "Mobile Number*"),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  margin: EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(45, 45, 45, 1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        size: 20,
                                        color: Colors.white70,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          obscureText: _obscureText,
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Create Password*",
                                            hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white70,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        child: Icon(
                                          _obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 20,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Signin(), 
                                      ),
                                    );
                                    
                                  },
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
                        // This Center widget holds the content for the bottom of the screen.
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
                                  MaterialButton(
                                    onPressed: () {},
                                    shape: CircleBorder(),
                                    height: 60,
                                    minWidth: 60,
                                    color: Color.fromRGBO(45, 45, 45, 1),
                                    child: SvgPicture.asset(
                                      'assets/images/google.svg',
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),

                                  SizedBox(width: 50),

                                  // apple
                                  MaterialButton(
                                    onPressed: () {},
                                    shape: CircleBorder(),
                                    height: 60,
                                    minWidth: 60,
                                    color: Color.fromRGBO(45, 45, 45, 1),
                                    child: SvgPicture.asset(
                                      'assets/images/apple.svg',
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),

                                  SizedBox(width: 50),

                                  // facebook
                                  MaterialButton(
                                    onPressed: () {},
                                    shape: CircleBorder(),
                                    height: 60,
                                    minWidth: 60,
                                    color: Color.fromRGBO(45, 45, 45, 1),
                                    child: SvgPicture.asset(
                                      'assets/images/facebook.svg',
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
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
                                        builder: (context) =>
                                            Signin(), // replace with your page
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
