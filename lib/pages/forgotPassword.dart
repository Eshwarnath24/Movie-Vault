import 'package:flutter/material.dart';
import 'package:ott/pages/signin.dart';
import 'codeSentPage.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 6),
                      Text('Back', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Forget\nPassword?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    wordSpacing: 4,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Select one of the following method\nto recover your password...',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 70),

                // ✅ Responsive ToggleButtons
                Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double buttonWidth = (constraints.maxWidth - 20) / 2;
                      return ToggleButtons(
                        borderRadius: BorderRadius.circular(10),
                        fillColor: const Color.fromARGB(255, 66, 66, 66),
                        selectedColor: Colors.white,
                        color: Colors.white70,
                        constraints: BoxConstraints(
                          minWidth: buttonWidth,
                          minHeight: 40,
                        ),
                        isSelected: isSelected,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < isSelected.length; i++) {
                              isSelected[i] = i == index;
                            }
                          });
                        },
                        children: const [Text("Email"), Text("Phone")],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 50),

                // TextField based on toggle selection
                isSelected[0]
                    ? _buildTextField('Enter Email*', icon: Icons.email)
                    : _buildTextField(
                        'Enter Phone Number*',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),

                const SizedBox(height: 8),
                const Text(
                  "We’ll send you a message code to set \na reset your new password",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 40),

                // Send Code Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Send Code",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CodeSentPage(),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Sign-in footer
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Signin(),
                          ),
                        ),
                        child: const Text(
                          "Sign-in here!",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hintText, {
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color.fromARGB(255, 44, 44, 44),
        prefixIcon: Icon(icon, color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: isPassword,
    );
  }
}
