// lib/pages/Firebase/movie_database.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ott/pages/Main/movie.dart';
import 'package:ott/pages/Main/movie_list.dart';

class MovieDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Upload all movies
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

  // 🔹 Fetch all movies from a given collection
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

  // =============================================================
  // ✅ Add Movie ID to User's "continueMovies" array
  // =============================================================
  Future<void> addContinueMovie(String movieId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = _firestore.collection("Users").doc(user.uid);

    // First, remove the movie ID if it already exists.
    // This is crucial for re-ordering.
    await userRef.update({
      "continueMovies": FieldValue.arrayRemove([movieId]),
    });

    // Now, add it back to the end of the array.
    // This makes the last element the most recently watched.
    await userRef.update({
      "continueMovies": FieldValue.arrayUnion([movieId]),
    });

    print("✅ Updated continueMovies with movieId $movieId for ${user.uid}");
  }

  // =============================================================
  // ✅ Fetch all continue movies for current user
  // For each movieId → find in TrendingMovies or CarouselMovies
  // =============================================================
  Future<List<Movie>> fetchContinueMovies() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final userDoc = await _firestore.collection("Users").doc(user.uid).get();
    if (!userDoc.exists || userDoc.data()?['continueMovies'] == null) {
      return [];
    }

    final List<dynamic> movieIds = userDoc.data()?['continueMovies'] ?? [];
    List<Movie> continueMovies = [];

    // Iterate over the REVERSED list of IDs to get the most recent first.
    for (String movieId in movieIds.reversed) {
      // Try finding in TrendingMovies first
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection("TrendingMovies")
          .doc(movieId)
          .get();

      if (!doc.exists) {
        // Try CarouselMovies if not found
        doc = await _firestore.collection("CarouselMovies").doc(movieId).get();
      }

      if (doc.exists) {
        final data = doc.data()!;
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

        continueMovies.add(
          Movie(
            movieId: data['movieId'] ?? '',
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
            bannerUrl: data['bannerUrl'] ?? '',
            videoUrl: data['videoUrl'] ?? '',
            genres: data['genres'] != null
                ? List<String>.from(data['genres'])
                : [],
            episodes: episodesList,
          ),
        );
      }
    }

    print("🎬 Fetched ${continueMovies.length} continue movies");
    return continueMovies;
  }
}
