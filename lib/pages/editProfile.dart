import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  Widget _createProfileEditOptions(String hintText, IconData icon) {
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
          SizedBox(width: 10),
          Icon(Icons.mode_edit_outline_outlined, size: 20, color: Colors.white70),
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
                  SizedBox(width: 5,),
                  Icon(Icons.edit, size: 12,),
                ],
              ),
            ],
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView(
              children: [
                _createProfileEditOptions(
                  "Eshwarnath Gajula",
                  Icons.person,
                ),
                _createProfileEditOptions(
                  "user123@gmail.com",
                  Icons.mail,
                ),
                _createProfileEditOptions(
                  "1234567890",
                  Icons.phone_android_rounded,
                ),
                _createProfileEditOptions(
                  "123-B Block DHA-Amrita",
                  Icons.maps_home_work_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}