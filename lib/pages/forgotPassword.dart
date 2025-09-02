import 'package:flutter/material.dart';

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
                  onTap: () => Navigator.pop(context), // ✅ this will now work
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

                // Toggle buttons
                Center(
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(10),
                    fillColor: const Color.fromARGB(255, 66, 66, 66),
                    selectedColor: Colors.white,
                    color: Colors.white70,
                    isSelected: isSelected,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                        }
                      });
                    },
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 95,
                          vertical: 6,
                        ),
                        child: Text("Email"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 95,
                          vertical: 6,
                        ),
                        child: Text("Phone"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Change text field based on selection
                isSelected[0]
                    ? _buildTextField('Enter Email*', icon: Icons.email)
                    : _buildTextField(
                        'Enter Phone Number*',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
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