import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ott/pages/Firebase/auth_page.dart';

class DeleteAccount extends StatefulWidget {
  final String title;
  const DeleteAccount({super.key, required this.title});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      child: Icon(Icons.person_sharp, size: 70),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Are you sure,  you want to delete \nthis account ?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "The entire history of this account will be deleted.",
                      style: TextStyle(fontSize: 15, color: Colors.white54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white30,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 18),
                    MaterialButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Delete"),
                              content: Text(
                                "Are you sure you want to delete your account? This action cannot be undone.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),

                                TextButton(
                                  onPressed: () async {
                                    try {
                                      final user =
                                          FirebaseAuth.instance.currentUser;

                                      if (user != null) {
                                        // Delete from Firestore (Users collection)
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(user.uid)
                                            .delete();

                                        // Delete from Authentication
                                        await user.delete();

                                        print("Account deleted");

                                        // Navigate to Signin page and clear navigation stack
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AuthPage(),
                                          ),
                                        );
                                      } else {
                                        print("No user is logged in");
                                      }
                                    } catch (e) {
                                      print("Error deleting user: $e");
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Failed to delete account: $e",
                                          ),
                                        ),
                                      );
                                    }
                                  },

                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      color: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
