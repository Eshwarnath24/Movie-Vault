import 'package:flutter/material.dart';
import 'package:ott/pages/Bottom%20Navbar/profile.dart';

class EditProfile extends StatefulWidget {
  final void Function(Widget) changePage;
  final void Function(String) changeTittle;

  const EditProfile({
    super.key,
    required this.changePage,
    required this.changeTittle,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<TextEditingController> controllers = [
    TextEditingController(text: "Eshwarnath Gajula"),
    TextEditingController(text: "user123@gmail.com"),
    TextEditingController(text: "1234567890"),
    TextEditingController(text: "123-B Block DHA-Amrita"),
  ];

  Widget _createProfileEditOptions(
    int index,
    IconData icon,
  ) {
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
              controller: controllers[index], // ✅ shows pre-filled value
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(border: InputBorder.none),
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
                _createProfileEditOptions(0, Icons.person),
                _createProfileEditOptions(1, Icons.mail),
                _createProfileEditOptions(
                  2,
                  Icons.phone_android_rounded,
                ),
                _createProfileEditOptions(
                  3,
                  Icons.maps_home_work_outlined,
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        print("Save tapped");
                        widget.changePage(
                          Profile(
                            changePage: widget.changePage,
                            changeTittle: widget.changeTittle,
                          ),
                        );
                        widget.changeTittle("Profile");
                        // You can save the controller.text value here
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
