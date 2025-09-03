import 'package:flutter/material.dart';
import 'package:ott/pages/editPassword.dart';
import 'package:ott/pages/editProfile.dart';
import 'package:ott/pages/signin.dart';

class Profile extends StatefulWidget {
  final void Function(Widget) changePage;
  final void Function(String) changeTittle;

  const Profile({
    super.key,
    required this.changePage,
    required this.changeTittle,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _showNotification = false;

  Widget _createProfileOptions(
    String Option,
    IconData icon,
    Widget navigatingPage,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(236, 85, 85, 85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: () {
              print("Add $Option tapped");
              if (Option == "Logout") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signin()),
                );
              } else {
                widget.changeTittle(Option);
                widget.changePage(navigatingPage);
              }
            },
            title: Text(Option, style: TextStyle(color: Colors.white)),
            leading: Icon(icon, color: Colors.white),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
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
              Text(
                "Eshwarnath Gajula",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "User123@gmail.com",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView(
              children: [
                _createProfileOptions(
                  "Edit Profile",
                  Icons.person,
                  EditProfile(),
                ),
                _createProfileOptions(
                  "Edit Password",
                  Icons.lock,
                  EditPassword(),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(236, 85, 85, 85),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Material(
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: () {
                          print("Add  tapped");
                        },
                        title: Text(
                          "Notification On",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(Icons.notifications, color: Colors.white),
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: _showNotification,
                            onChanged: (bool value) {
                              setState(() {
                                _showNotification = value;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                _createProfileOptions(
                  "Logout",
                  Icons.logout_outlined,
                  Signin(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
