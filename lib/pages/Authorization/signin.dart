import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ott/pages/Authorization/forgotPassword.dart';
import 'package:ott/pages/Firebase/database.dart';
import 'package:ott/pages/Main/movieVault.dart';
import 'package:ott/pages/Authorization/signup.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _rememberMe = false;

  MyDatabase db = MyDatabase();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> userSignIn() async {
    // add loader
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // user sign in
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Navigator.pop(context);
      // show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter email and password')),
      );
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (context.mounted) {
          // pop loader
          Navigator.pop(context);

          // clear controllers
          emailController.clear();
          passwordController.clear();

          final currentPassword = await db.getUserPassword();
          if (passwordController.text.trim() != currentPassword) {
            db.updateUserInfo({'password': passwordController.text.trim()});
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieVault()),
          );
        }
      } on FirebaseAuthException catch (e) {
        print(e.code);
        // pop loader
        Navigator.pop(context);

        // show error
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error : ${e.code}')));
      }
    }
  }

  Widget _buildTextField({
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
                _buildTextField(
                  controller: emailController,
                  hintText: 'Email*',
                  icon: Icons.email,
                  obscureText: false,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: passwordController,
                  hintText: 'Password*',
                  icon: Icons.lock,
                  obscureText: true,
                ),
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
                            builder: (context) => ForgetPassword(),
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
                        onPressed: userSignIn,
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
                    child: Column(
                      children: [
                        Text(
                          "If you don't have an account you can",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          ),
                          child: Text(
                            "Sign-Up here!",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
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
