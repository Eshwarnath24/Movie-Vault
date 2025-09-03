import 'package:flutter/material.dart';
import 'package:ott/pages/Main/movieVaultHome.dart';
import 'package:ott/pages/Bottom%20Navbar/profile.dart';

class MovieVault extends StatefulWidget {
  const MovieVault({super.key});

  @override
  State<MovieVault> createState() => _MovieVaultState();
}

class _MovieVaultState extends State<MovieVault> {
  int _navigationIndex = 0;
  Widget _navigatingPage = HomePage();
  String _tittleName = "Movie Vault";

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

  Widget _createMenuOptions(String Option, IconData icon, {Color? color}) {
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
            title: Text(Option, style: TextStyle(color: color ?? Colors.white)),
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

              _createMenuOptions("Add Account", Icons.person_add_alt),
              _createMenuOptions(
                "Contact Support",
                Icons.support_agent_rounded,
              ),
              _createMenuOptions("Languages", Icons.g_translate_rounded),
              _createMenuOptions("Profile", Icons.account_circle_rounded),

              SizedBox(height: 50),

              _createMenuOptions("Log out", Icons.arrow_forward_rounded),
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
                  // setState(() {
                  //   _navigatingPage = HomePage();
                  // });
                } else if (_navigationIndex == 2) {
                  // setState(() {
                  //   _navigatingPage = HomePage();
                  // });
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
