import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ott/pages/Authorization/signin.dart';
import 'package:ott/pages/Bottom%20Navbar/downloadPage.dart';
import 'package:ott/pages/Firebase/database.dart';
import 'package:ott/pages/Main/movieVaultHome.dart';
import 'package:ott/pages/Bottom%20Navbar/profile.dart';
import 'package:ott/pages/Menu/contactSupport.dart';
import 'package:ott/pages/Menu/deleteAccount.dart';
import 'package:ott/pages/Menu/language.dart';
import 'package:ott/pages/subscription/subscriptionPage.dart';
import 'package:ott/pages/Bottom%20Navbar/searchPage.dart';

class MovieVault extends StatefulWidget {
  const MovieVault({super.key});

  @override
  State<MovieVault> createState() => _MovieVaultState();
}

class _MovieVaultState extends State<MovieVault> {
  int _navigationIndex = 0;
  Widget _navigatingPage = HomePage();
  String _tittleName = "Movie Vault";

  MyDatabase db = MyDatabase();
  String? password; // make nullable

  @override
  void initState() {
    super.initState();
    _loadPassword();
  }

  Future<void> _loadPassword() async {
    password = await db.getUserPassword();
    setState(() {}); // rebuild widget if needed
  }

  void changeTittleName(String newName) {
    setState(() {
      _tittleName = newName;
    });
  }

  void changeNavigatingPage(Widget page) {
    setState(() {
      _navigatingPage = page;
    });
  }

  void SignOut() async {
    // add loader
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseAuth.instance.signOut();

      // context mounted
      if (context.mounted) {
        // pop loader
        Navigator.pop(context);

        // Navigate to sign in page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Signin()),
        );
      }
    } on FirebaseAuthException catch (_) {
      // pop loader
      Navigator.pop(context);

      // alert error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sorry unable to signout, Please try again!')),
      );
    }
  }

  Widget _createMenuOptions(
    String option,
    IconData icon,
    VoidCallback onTap, { // take a function instead of a page
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(236, 85, 85, 85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: onTap, // just call the passed function
            title: Text(option, style: TextStyle(color: color ?? Colors.white)),
            trailing: Icon(icon, color: color ?? Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text(_tittleName)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "No new notifications",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color.fromRGBO(40, 40, 40, 1),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Color.fromARGB(227, 30, 30, 30),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(color: Colors.black87),
                child: Stack(
                  alignment: Alignment(0, 9),
                  children: [
                    CircleAvatar(
                      radius: 60,
                      child: Icon(Icons.person_4, size: 70),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 60),

              _createMenuOptions("Delete Account", Icons.delete_forever, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeleteAccount(
                      title: "Delete Account",
                      password: password!,
                    ),
                  ),
                );
              }),

              _createMenuOptions(
                "Contact Support",
                Icons.support_agent_rounded,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ContactSupport(title: "Contact Support"),
                    ),
                  );
                },
              ),
              _createMenuOptions("Languages", Icons.g_translate_rounded, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => changeLanguage(title: "Subscribe"),
                  ),
                );
              }),

              _createMenuOptions("Subscribe", Icons.workspace_premium, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubscriptionPage()),
                );
              }),
              // _createMenuOptions("Profile", Icons.account_circle_rounded),
              SizedBox(height: 50),

              _createMenuOptions(
                "Log out",
                Icons.arrow_forward_rounded,
                SignOut,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),

        body: _navigatingPage,

        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 50, 50, 50),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: false,
              currentIndex: _navigationIndex,
              onTap: (index) {
                setState(() {
                  _navigationIndex = index;
                });

                if (_navigationIndex == 0) {
                  changeTittleName("Movie Vault");
                  setState(() {
                    _navigatingPage = HomePage();
                  });
                } else if (_navigationIndex == 1) {
                  changeTittleName("Download");
                  setState(() {
                    _navigatingPage = DownloadsPage();
                  });
                } else if (_navigationIndex == 2) {
                  changeTittleName("Search");
                  setState(() {
                    _navigatingPage = OttSearchPage();
                  });
                } else if (_navigationIndex == 3) {
                  changeTittleName("Profile");

                  setState(() {
                    _navigatingPage = Profile(
                      changePage: changeNavigatingPage,
                      changeTittle: changeTittleName,
                    );
                  });
                }
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.downloading_rounded),
                  label: 'Download',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
