import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ott/pages/Main/movie.dart';
import 'package:ott/pages/Main/movie_list.dart';

class MovieDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ... (keep all other functions like uploadAllMovies, addMovie, etc. as they are)
  Future<void> uploadAllMovies() async {
    await _uploadMovies(trendingMovies, "TrendingMovies");
    await _uploadMovies(caroselMovies, "CarouselMovies");
    print("All movies processed successfully!");
  }

  Future<void> addMovie(Movie movie, String collectionName) async {
    final docRef = _firestore.collection(collectionName).doc(movie.movieId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set(movie.toMap());
      print("Uploaded $collectionName movie: ${movie.title}");
    } else {
      print("$collectionName movie already exists: ${movie.title}");
    }
  }

  Future<void> _uploadMovies(List<Movie> movies, String collectionName) async {
    for (var movie in movies) {
      await addMovie(movie, collectionName);
    }
  }

  Future<List<Movie>> fetchMovies(String collectionName) async {
    final snapshot = await _firestore.collection(collectionName).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

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

  Future<List<Movie>> fetchContinueMovies() async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? "guestUser";

    final snapshot = await _firestore
        .collection("Users")
        .doc(userId)
        .collection("ContinueMovies")
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Movie.fromMap(data);
    }).toList();
  }

  // ==================== THIS IS THE CORRECTED FUNCTION ====================
  /// 隼 Add movie to Continue Watching (with timestamp) for current user
  Future<void> addContinueMovie(Movie movie) async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? "guestUser";

    final docRef = _firestore
        .collection("Users")
        .doc(userId)
        .collection("ContinueMovies")
        .doc(movie.movieId);

    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      // FIX: Add the movie data AND the timestamp when creating the document
      final movieData = movie.toMap();
      movieData['timestamp'] = Timestamp.now();
      await docRef.set(movieData);
      print("Added to ContinueMovies for $userId: ${movie.title}");
    } else {
      // This part was already correct. It just updates the timestamp.
      await docRef.update({'timestamp': Timestamp.now()});
      print("Updated timestamp for ContinueMovies $userId: ${movie.title}");
    }
  }
}
