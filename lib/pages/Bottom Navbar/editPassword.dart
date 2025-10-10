import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ott/pages/Bottom%20Navbar/profile.dart';
import 'package:ott/pages/Firebase/database.dart';

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
  MyDatabase db = MyDatabase();
  List<bool> obscureText = [true, true, true];
  List<TextEditingController> contollers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  Future<void> changeUserPassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // 1) Check all 3 fields are filled
    if (contollers[0].text.isEmpty ||
        contollers[1].text.isEmpty ||
        contollers[2].text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all the fields")));
      return;
    }

    // 2) Check new password and confirm password match
    if (contollers[1].text != contollers[2].text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New password and confirm password do not match"),
        ),
      );
      return;
    }

    // 3) Check old password matches with Firestore data
    final userInfo = widget.userInfo[0];
    if (userInfo['password'] != contollers[0].text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Old password is incorrect")));
      return;
    }

    try {
      // Update password directly in Firebase Auth
      await user.updatePassword(contollers[1].text);

      // Update password in Firestore user table
      MyDatabase db = MyDatabase();
      await db.updateUserInfo({'password': contollers[1].text});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password updated successfully")));

      // Navigate back to Profile
      widget.changePage(
        Profile(
          changePage: widget.changePage,
          changeTittle: widget.changeTittle,
        ),
      );
      widget.changeTittle("Profile");
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update password: $e")));
    }
  }

  Widget _createEditPasswordOpts(String hintText, int index) {
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
              print("Tapped");
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
                      color: Colors.blue, // button background
                      textColor: Colors.white, // text color
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
