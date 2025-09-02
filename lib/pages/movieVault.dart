import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MovieVault extends StatefulWidget {
  const MovieVault({super.key});

  @override
  State<MovieVault> createState() => _MovieVaultState();
}

class _MovieVaultState extends State<MovieVault> {
  final List<String> treandingPosters = [
    "assets/images/joker.jpg",
    "assets/images/master.jpg",
    "assets/images/star_wars.jpg",
    "assets/images/titanic.jpg",
  ];

  final List<String> continueMovies = [
    "assets/images/joker.jpg",
    "assets/images/master.jpg",
    "assets/images/star_wars.jpg",
    "assets/images/titanic.jpg",
  ];

  final List<String> treandingMovies = [
    "assets/images/joker.jpg",
    "assets/images/master.jpg",
    "assets/images/star_wars.jpg",
    "assets/images/titanic.jpg",
  ];

  int _carouselIndex = 0;
  int _navigationIndex = 0;

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
              print("Add ${Option} tapped");
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
          title: const Text("Movie Vault"),
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

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false, overscroll: false),
            child: ListView.builder(
              itemCount: 1, // we'll add more sections later
              itemBuilder: (context, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 300,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.7,
                            aspectRatio: 4 / 6,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            onPageChanged: (index, reason) {
                              setState(() {
                                _carouselIndex = index;
                              });
                            },
                          ),
                          items: treandingPosters.map((posterPath) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(posterPath, fit: BoxFit.cover),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    right: 20,
                                    child: Text(
                                      posterPath
                                          .split('/')
                                          .last
                                          .split('.')
                                          .first
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        // Indicator Dots (unchanged)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: treandingPosters.asMap().entries.map((
                            entry,
                          ) {
                            return GestureDetector(
                              onTap: () {}, // can hook to jump later
                              child: Container(
                                width: _carouselIndex == entry.key ? 16 : 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(4),
                                  color: _carouselIndex == entry.key
                                      ? Colors.redAccent
                                      : Colors.grey,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                    SizedBox(height: 25),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Continue Watching",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 250, // same as carousel height
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: continueMovies.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                width: 150, // ✅ fixed width
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    continueMovies[index],
                                    fit: BoxFit.cover,
                                    height: 250,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 25),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Treanding Movies",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 250, // same as carousel height
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: treandingMovies.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                width: 150, // ✅ fixed width
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    treandingMovies[index],
                                    fit: BoxFit.cover,
                                    height: 250,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),

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
                  if (ModalRoute.of(context)?.settings.name != "/movieVault") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MovieVault()),
                    );
                  }
                } else if (_navigationIndex == 1) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         Downloads(),
                  //   ),
                  // );
                } else if (_navigationIndex == 2) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         Search(),
                  //   ),
                  // );
                } else if (_navigationIndex == 3) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         MySpace(),
                  //   ),
                  // );
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
                  label: 'My Space',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
