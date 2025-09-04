class Movie {
  final String title;
  final String description;
  final double rating;
  final String bannerUrl;
  final String videoUrl;
  final List<String> genres;
  final List<Episode> episodes;

  Movie({
    required this.title,
    required this.description,
    required this.rating,
    required this.bannerUrl,
    required this.videoUrl,
    required this.genres,
    this.episodes = const [], // default empty list if no episodes
  });
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
}


