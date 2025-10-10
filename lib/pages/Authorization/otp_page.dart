import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPPage extends StatefulWidget {
  final String verificationId;
  OTPPage({super.key, required this.verificationId});
  // OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool otpVerified = false;

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void checkOTP() async {
    // add loader
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    final otp = otpControllers.map((c) => c.text).join().toString();

    if (otp.trim().length < 6) {
      // pop loader
      Navigator.pop(context);

      // error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid OTP Entered')));
    } else {
      try {
        PhoneAuthCredential credential = await PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: otp,
        );

        if (context.mounted) {
          // pop loader
          Navigator.pop(context);

          // ask to make new password
          setState(() {
            otpVerified = true;
          });
        }
      } on FirebaseAuthException catch (e) {
        // pop loader
        Navigator.pop(context);

        // error
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error : ${e.code}')));
      }
    }
  }

  Widget askOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline, color: Colors.blue, size: 70),
        const SizedBox(height: 20),
        const Text(
          "Verify Your OTP",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Enter the 6-digit code sent to your number",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 50,
              height: 50,
              child: TextField(
                controller: otpControllers[index],
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: const Color.fromRGBO(40, 40, 40, 1),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    FocusScope.of(context).nextFocus();
                  } else if (value.isEmpty && index > 0) {
                    FocusScope.of(context).previousFocus();
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: checkOTP,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
          ),
          child: const Text(
            "Verify OTP",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 25),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Resend Code",
            style: TextStyle(color: Colors.blueAccent, fontSize: 15),
          ),
        ),
      ],
    );
  }

  void resetPassword() async {
    // add loader
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // Basic validation
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      // pop loader
      Navigator.pop(context);

      // show error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter password')));
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      // pop loader
      Navigator.pop(context);

      // show error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }

    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(
        newPasswordController.text.trim(),
      );

      if (context.mounted) {
        // pop loader
        Navigator.pop(context);

        // ask to make new password
        setState(() {
          otpVerified = true;
        });
      }
    } on FirebaseAuthException catch (e) {
      // pop loader
      Navigator.pop(context);

      // show error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error : ${e.code}')));
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

  Widget changePassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Icon(Icons.lock_outline, color: Colors.blue, size: 150)),
        const SizedBox(height: 40),
        _buildTextField(
          controller: newPasswordController,
          hintText: "New Password",
          icon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: confirmPasswordController,
          hintText: "Confirm New Password",
          icon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: resetPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Save", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          !otpVerified ? "OTP Verification" : "Set New Password",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: !otpVerified ? askOTP() : changePassword(),
      ),
    );
  }
}
