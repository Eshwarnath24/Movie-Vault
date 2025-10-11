import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ott/pages/Main/movie.dart';
import 'package:ott/pages/Main/movie_list.dart';

class MovieDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Upload all movies (trending + carousel) safely
  Future<void> uploadAllMovies() async {
    await _uploadMovies(trendingMovies, "TrendingMovies");
    await _uploadMovies(caroselMovies, "CarouselMovies");
    print("All movies processed successfully!");
  }

  Future<void> addMovie(Movie movie, String collectionName) async {
    final docRef = _firestore.collection(collectionName).doc(movie.movieId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set({
        "movieId": movie.movieId,
        "title": movie.title,
        "bannerUrl": movie.bannerUrl,
        "rating": movie.rating,
        "genres": movie.genres,
        "description": movie.description,
        "videoUrl": movie.videoUrl,
        "episodes": movie.episodes,
      });
      print("Uploaded $collectionName movie: ${movie.title}");
    } else {
      print("$collectionName movie already exists: ${movie.title}");
    }
  }

  /// Internal method to upload a list of movies to a collection
  Future<void> _uploadMovies(List<Movie> movies, String collectionName) async {
    for (var movie in movies) {
      addMovie(movie, collectionName);
    }
  }

  Future<List<Movie>> fetchMovies(String collectionName) async {
    final snapshot = await _firestore.collection(collectionName).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      // Convert Firestore list of maps into List<Episode>
      List<Episode> episodesList = [];
      if (data['episodes'] != null) {
        episodesList = (data['episodes'] as List)
            .map(
              (e) => Episode(
                title: e['title'] ?? '',
                duration: e['duration'] ?? '',
                imageUrl: e['imageUrl'] ?? '',
                videoUrl: e['videoUrl'] ?? '',
              ),
            )
            .toList();
      }

      return Movie(
        movieId: data['movieId'] ?? '',
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
        bannerUrl: data['bannerUrl'] ?? '',
        videoUrl: data['videoUrl'] ?? '',
        genres: data['genres'] != null ? List<String>.from(data['genres']) : [],
        episodes: episodesList,
      );
    }).toList();
  }
}
