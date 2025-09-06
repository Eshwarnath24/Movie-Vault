import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ott/pages/Main/movie.dart';
import 'package:ott/pages/Main/moviePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Movie> caroselMovies = [
    Movie(
      title: "Pokiri",
      bannerUrl: "assets/images/pokiri.jpg",
      rating: 4.7,
      genres: ["Action", "Thriller", "Romance"],
      description:
          "An undercover cop infiltrates the underworld to take down a dangerous gangster.",
      videoUrl: "https://www.youtube.com/watch?v=BRQhY0xfq1Y",
      episodes: [],
    ),
    Movie(
      title: "Athadu",
      bannerUrl: "assets/images/athadu.jpg",
      rating: 4.6,
      genres: ["Action", "Thriller", "Drama"],
      description:
          "A professional assassin on the run assumes another man's identity and finds love and redemption.",
      videoUrl: "https://www.youtube.com/watch?v=ZyqNQQjVfqU",
      episodes: [],
    ),
    Movie(
      title: "Okkadu",
      bannerUrl: "assets/images/okkadu.jpg",
      rating: 4.5,
      genres: ["Action", "Romance", "Drama"],
      description:
          "A kabaddi player rescues a girl from an influential faction leader and fights against all odds.",
      videoUrl: "https://www.youtube.com/watch?v=lx4tRtSXxIY",
      episodes: [],
    ),
    Movie(
      title: "Srimanthudu",
      bannerUrl: "assets/images/srimanthudu.jpg",
      rating: 4.6,
      genres: ["Action", "Drama", "Family"],
      description:
          "A wealthy young man adopts a village and works to improve it.",
      videoUrl: "https://www.youtube.com/watch?v=kz9K2V2EJv4",
      episodes: [],
    ),
    Movie(
      title: "Murari",
      bannerUrl: "assets/images/murari.jpg",
      rating: 4.4,
      genres: ["Drama", "Family", "Romance"],
      description:
          "A young man struggles to overcome a family curse while finding love and peace.",
      videoUrl: "https://www.youtube.com/watch?v=kzFCXs0-9M0",
      episodes: [],
    ),
  ];

  final List<Movie> trendingMovies = [
    Movie(
      title: "Joker",
      bannerUrl: "assets/images/joker.jpg",
      rating: 4.5,
      genres: ["Drama", "Crime", "Thriller"],
      description: "Arthur Fleck, a failed comedian, descends into madness...",
      videoUrl: "https://www.youtube.com/watch?v=zAGVQLHvwOY",
      episodes: [],
    ),
    Movie(
      title: "Master",
      bannerUrl: "assets/images/master.jpg",
      rating: 4.2,
      genres: ["Action", "Thriller"],
      description: "An alcoholic professor is sent to a juvenile school...",
      videoUrl: "https://www.youtube.com/watch?v=1_iUFT3nWHk",
      episodes: [],
    ),
    Movie(
      title: "Star Wars",
      bannerUrl: "assets/images/star_wars.jpg",
      rating: 4.8,
      genres: ["Sci-Fi", "Adventure"],
      description:
          "The epic space saga of Jedi, Sith, and the balance of the Force...",
      videoUrl: "https://www.youtube.com/watch?v=8Qn_spdM5Zg",
      episodes: [],
    ),
    Movie(
      title: "Titanic",
      bannerUrl: "assets/images/titanic.jpg",
      rating: 4.7,
      genres: ["Romance", "Drama"],
      description: "A love story unfolds on the doomed RMS Titanic...",
      videoUrl: "https://www.youtube.com/watch?v=kVrqfYjkTdQ",
      episodes: [],
    ),
  ];

  final List<Movie> continueMovies = [];

  int _carouselIndex = 0;

  void _addToContinueWatching(Movie movie) {
    setState(() {
      continueMovies.remove(movie);
      continueMovies.insert(0, movie);
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(movie: movie),
                          ),
                        );
                        _addToContinueWatching(movie);
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
            // 🔹 Carousel Section
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
                  items: caroselMovies.map((movie) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(movie: movie),
                          ),
                        );
                        _addToContinueWatching(movie);
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

                // 🔹 Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: caroselMovies.asMap().entries.map((entry) {
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

            // 🔹 Continue Watching Section
            _buildMovieSection("Continue Watching", continueMovies),

            const SizedBox(height: 25),

            // 🔹 Trending Movies Section
            _buildMovieSection("Trending Movies", trendingMovies),
          ],
        ),
      ),
    );
  }
}
