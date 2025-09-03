import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'moviePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      children: treandingPosters.asMap().entries.map((entry) {
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
                                  ? Colors.blueAccent
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
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailPage(),
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 150, // ✅ fixed width
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  continueMovies[index],
                                  fit: BoxFit.cover,
                                  height: 250,
                                ),
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
                              "Trending Movies",
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
                            margin: const EdgeInsets.symmetric(horizontal: 8),
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
    );
  }
}
