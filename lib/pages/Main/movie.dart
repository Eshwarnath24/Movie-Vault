import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String movieId;
  final String title;
  final String description;
  final double rating;
  final String bannerUrl;
  final String videoUrl;
  final List<String> genres;
  final List<Episode> episodes;
  final DateTime? timestamp; // <-- Added for Firestore sorting

  Movie({
    required this.movieId,
    required this.title,
    required this.description,
    required this.rating,
    required this.bannerUrl,
    required this.videoUrl,
    required this.genres,
    this.episodes = const [],
    this.timestamp,
  });

  /// 🔹 Convert Firestore map → Movie object
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      movieId: map['movieId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      rating: (map['rating'] != null) ? (map['rating'] as num).toDouble() : 0.0,
      bannerUrl: map['bannerUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      genres: map['genres'] != null ? List<String>.from(map['genres']) : [],
      episodes: map['episodes'] != null
          ? List<Episode>.from(
              (map['episodes'] as List)
                  .map((e) => Episode.fromMap(Map<String, dynamic>.from(e))),
            )
          : [],
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : null,
    );
  }

  /// 🔹 Convert Movie object → Firestore map
  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'title': title,
      'description': description,
      'rating': rating,
      'bannerUrl': bannerUrl,
      'videoUrl': videoUrl,
      'genres': genres,
      'episodes': episodes.map((e) => e.toMap()).toList(),
      'timestamp': Timestamp.now(), // always save new timestamp
    };
  }
}

class Episode {
  final String title;
  final String duration;
  final String imageUrl;
  final String videoUrl;

  Episode({
    required this.title,
    required this.duration,
    required this.imageUrl,
    required this.videoUrl,
  });

  /// 🔹 Convert Firestore map → Episode object
  factory Episode.fromMap(Map<String, dynamic> map) {
    return Episode(
      title: map['title'] ?? '',
      duration: map['duration'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
    );
  }

  /// 🔹 Convert Episode object → Firestore map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'duration': duration,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    };
  }
}
