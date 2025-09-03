import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  Widget _createProfileOptions(String Option, IconData icon,) {
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
            },
            title: Text(Option, style: TextStyle(color: Colors.white)),
            leading: Icon(icon, color:Colors.white,),
            trailing: Icon(Icons.arrow_forward_ios_rounded, color:Colors.white, size: 20,),
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
              SizedBox(height: 8,),
              Text(
                "Eshwarnath Gajula",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "User123@gmail.com",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 40,),
          Expanded(
            child: ListView(
              children: [
                _createProfileOptions("Edit Profile", Icons.person),
                _createProfileOptions("Edit Password", Icons.lock),
                _createProfileOptions("Logout", Icons.logout_outlined),
              ],
            ),
          )
        ],
      ),
    );
  }
}