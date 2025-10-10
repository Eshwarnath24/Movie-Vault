import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ott/pages/Bottom%20Navbar/editPassword.dart';
import 'package:ott/pages/Bottom%20Navbar/editProfile.dart';
import 'package:ott/pages/Firebase/auth_page.dart';
import 'package:ott/pages/Firebase/database.dart';

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
  MyDatabase db = MyDatabase();
  late List<Map<String, dynamic>> userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final data = await db.getCurrentUserInfo();
    if (mounted) {
      setState(() {
        userInfo = data;
        print(userInfo);
      });
    }
  }

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
            onTap: () async {
              print("Add $Option tapped");
              if (Option == "Logout") {
                await FirebaseAuth.instance.signOut(); // 🔹 Sign out user
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => navigatingPage,
                  ), // 🔹 Navigate to sign-in page
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
                userInfo[0]['userName'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                userInfo[0]['email'],
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
                  EditProfile(
                    changePage: widget.changePage,
                    changeTittle: widget.changeTittle,
                    userInfo: userInfo,
                  ),
                ),
                _createProfileOptions(
                  "Edit Password",
                  Icons.lock,
                  EditPassword(
                    changePage: widget.changePage,
                    changeTittle: widget.changeTittle,
                    userInfo: userInfo,
                  ),
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
                  AuthPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
