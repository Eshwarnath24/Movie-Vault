import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ott/pages/forgotPassword.dart';
import 'package:ott/pages/movieVault.dart';
import 'package:ott/pages/signup.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _rememberMe = false;

  Widget _buildTextField(
    String hintText, {
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Color.fromARGB(255, 50, 50, 50),
        prefixIcon: Icon(icon, color: Colors.white54),
        suffixIcon: isPassword
            ? Icon(Icons.visibility_off_outlined, color: Colors.white54)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: isPassword,
    );
  }

  Widget socialCircle(String assetPath) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey[850],
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          assetPath,
          height: 24,
          width: 24,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                SizedBox(height: 6),
                Text(
                  'Welcome\nBack!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    wordSpacing: 4,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Enter the following details to\nSignIn...',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                SizedBox(height: 80),
                _buildTextField('Enter Email', icon: Icons.email),
                SizedBox(height: 20),
                _buildTextField('Password', icon: Icons.lock, isPassword: true),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: _rememberMe,
                          onChanged: (bool value) {
                            setState(() {
                              _rememberMe = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        Text(
                          'Remember Me',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Forgotpassword(), 
                          ),
                        );
                      },
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward, size: 28),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieVault(), 
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Center(
                  child: Text(
                    'Sign In with',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialCircle("assets/images/google.svg"),
                    SizedBox(width: 50),
                    socialCircle("assets/images/Apple.svg"),
                    SizedBox(width: 50),
                    socialCircle("assets/images/facebook.svg"),
                  ],
                ),
                SizedBox(height: 40),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: RichText(
                      text: TextSpan(
                        text: "If you don't have an account you can ",
                        style: TextStyle(color: Colors.white70),
                        children: [
                          TextSpan(
                            text: 'Sign-Up here!',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigate to SignUp page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Signup(), // replace with your page
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
