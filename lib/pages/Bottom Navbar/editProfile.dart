import 'package:flutter/material.dart';
import 'package:ott/pages/Bottom%20Navbar/profile.dart';
import 'package:ott/pages/Firebase/database.dart';

class EditProfile extends StatefulWidget {
  final void Function(Widget) changePage;
  final void Function(String) changeTittle;
  final List<Map<String, dynamic>> userInfo;

  const EditProfile({
    super.key,
    required this.changePage,
    required this.changeTittle,
    required this.userInfo,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  MyDatabase db = MyDatabase();
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = [
      TextEditingController(text: widget.userInfo[0]['userName']),
      TextEditingController(text: widget.userInfo[0]['email']),
      TextEditingController(text: widget.userInfo[0]['phoneNumber']),
      TextEditingController(text: widget.userInfo[0]['address']),
    ];
  }

  Widget _createProfileEditOptions(int index, IconData icon, String hintText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Color.fromRGBO(45, 45, 45, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(icon, size: 20, color: Colors.white70),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controllers[index],
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
              ),
            ),
          ),
          SizedBox(width: 10),
          Icon(
            Icons.mode_edit_outline_outlined,
            size: 20,
            color: Colors.white70,
          ),
          SizedBox(width: 10),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                child: Icon(Icons.person_sharp, size: 70),
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Edit",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.edit, size: 12),
                ],
              ),
            ],
          ),
          SizedBox(height: 40),

          Expanded(
            child: ListView(
              children: [
                _createProfileEditOptions(0, Icons.person, "User Name*"),
                _createProfileEditOptions(1, Icons.mail, "Email*"),
                _createProfileEditOptions(
                  2,
                  Icons.phone_android_rounded,
                  "Phone Number*",
                ),
                _createProfileEditOptions(
                  3,
                  Icons.maps_home_work_outlined,
                  "Address",
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        try {
                          await db.updateUserInfo({
                            'userName': controllers[0].text.trim(),
                            'email': controllers[1].text.trim(),
                            'phoneNumber': controllers[2].text.trim(),
                            'address': controllers[3].text.trim(),
                          });

                          widget.changePage(
                            Profile(
                              changePage: widget.changePage,
                              changeTittle: widget.changeTittle,
                            ),
                          );
                          widget.changeTittle("Profile");
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to update info"),
                            ),
                          );
                        }
                      },

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
