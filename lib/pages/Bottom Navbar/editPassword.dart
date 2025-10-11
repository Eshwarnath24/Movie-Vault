import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ott/pages/Bottom%20Navbar/profile.dart';

class EditPassword extends StatefulWidget {
  final void Function(Widget) changePage;
  final void Function(String) changeTittle;
  final List<Map<String, dynamic>> userInfo;

  const EditPassword({
    super.key,
    required this.changePage,
    required this.changeTittle,
    required this.userInfo,
  });

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  List<bool> obscureText = [true, true, true];
  List<TextEditingController> contollers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  // --- THIS FUNCTION HAS BEEN CORRECTED ---
  Future<void> changeUserPassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle case where user is somehow not logged in
      return;
    }

    // 1) Check if fields are filled and new passwords match
    if (contollers[0].text.isEmpty ||
        contollers[1].text.isEmpty ||
        contollers[2].text.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all the fields")),
        );
      }
      return;
    }

    if (contollers[1].text != contollers[2].text) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("New password and confirm password do not match"),
          ),
        );
      }
      return;
    }

    // 2) Securely re-authenticate the user before changing the password
    try {
      // Create a credential using the user's email and the old password they entered.
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: contollers[0].text.trim(),
      );

      // Re-authenticate with Firebase to verify their identity.
      await user.reauthenticateWithCredential(credential);

      // 3) If re-authentication is successful, update the password in Firebase Auth.
      await user.updatePassword(contollers[1].text.trim());

      // We no longer need to update Firestore because the password isn't stored there.

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated successfully")),
        );

        // Navigate back to Profile
        widget.changePage(
          Profile(
            changePage: widget.changePage,
            changeTittle: widget.changeTittle,
          ),
        );
        widget.changeTittle("Profile");
      }
    } on FirebaseAuthException catch (e) {
      // Provide user-friendly feedback for common errors.
      String errorMessage = "Failed to update password. Please try again.";
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = "The old password you entered is incorrect.";
      }

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  // --- No changes are needed below this line ---

  Widget _createEditPasswordOpts(String hintText, int index) {
    // ... your existing widget code
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Color.fromRGBO(45, 45, 45, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.lock, size: 20, color: Colors.white70),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: contollers[index],
              obscureText: obscureText[index],
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 15, color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                obscureText[index] = !obscureText[index];
              });
            },
            child: Icon(
              obscureText[index] ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... your existing build method
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 40, bottom: 8, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 60, child: Icon(Icons.person_sharp, size: 70)),
          SizedBox(height: 40),
          Expanded(
            child: ListView(
              children: [
                _createEditPasswordOpts("Old Password*", 0),
                _createEditPasswordOpts("New Password*", 1),
                _createEditPasswordOpts("Confirm Password*", 2),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: changeUserPassword,
                      minWidth: MediaQuery.of(context).size.width / 4,
                      color: Colors.blue,
                      textColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text("SAVE", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}