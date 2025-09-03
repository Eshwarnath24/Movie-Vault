import 'package:flutter/material.dart';
import 'package:ott/pages/Bottom%20Navbar/profile.dart';

class EditPassword extends StatefulWidget {
  final void Function(Widget) changePage;
  final void Function(String) changeTittle;

  const EditPassword({
    super.key,
    required this.changePage,
    required this.changeTittle,
  });

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  List<bool> obscureText = [true, true, true];

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
