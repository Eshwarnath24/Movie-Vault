import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ott/pages/Firebase/movie_database.dart';
import 'package:ott/pages/Main/movie.dart';
import 'package:ott/pages/Main/moviePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _carouselIndex = 0;
  final MovieDatabase movieDB = MovieDatabase();

  // These lists will hold the movies fetched from Firestore
  List<Movie> carouselMovies = [];
  List<Movie> trendingMovies = [];
  List<Movie> continueMovies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies(); // Fetch movies when the page loads
  }

  /// Fetch movies from Firestore
  void _loadMovies() async {
    final fetchedCarousel = await movieDB.fetchMovies("CarouselMovies");
    final fetchedTrending = await movieDB.fetchMovies("TrendingMovies");
    final fetchedContinue = await movieDB.fetchContinueMovies();

    if (!mounted) return;
    setState(() {
      carouselMovies = fetchedCarousel;
      trendingMovies = fetchedTrending;
      continueMovies = fetchedContinue;
    });
  }

  /// Add a movieId to the user's continueMovies array and refresh the local list
  Future<void> _addToContinueWatching(String movieId) async {
    final user = FirebaseAuth.instance.currentUser;

    print("yes from home");
    print(user!.uid);
    print("yes");

    if (user == null) return;

    await movieDB.addContinueMovie(movieId);
    final updatedContinueList = await movieDB.fetchContinueMovies();

    if (!mounted) return;
    setState(() {
      continueMovies = updatedContinueList;
    });
  }

  Widget _buildMovieSection(String title, List<Movie> movies) {
    return movies.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return GestureDetector(
                      onTap: () async {
                        // Add to continue (by movieId) then navigate
                        await _addToContinueWatching(movie.movieId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(movie: movie),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            movie.bannerUrl,
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
          );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(
          context,
        ).copyWith(scrollbars: false, overscroll: false),
        child: ListView(
          children: [
            // Carousel Section
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
                  items: carouselMovies.map((movie) {
                    return GestureDetector(
                      onTap: () async {
                        // Add by movieId then navigate
                        await _addToContinueWatching(movie.movieId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(movie: movie),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(movie.bannerUrl, fit: BoxFit.cover),
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
                                movie.title.toUpperCase(),
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
                      ),
                    );
                  }).toList(),
                ),

                // Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: carouselMovies.asMap().entries.map((entry) {
                    return Container(
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
                    );
                  }).toList(),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Continue Watching Section
            _buildMovieSection("Continue Watching", continueMovies),

            const SizedBox(height: 25),

            // Trending Movies Section
            _buildMovieSection("Trending Movies", trendingMovies),
          ],
        ),
      ),
    );
  }
}
