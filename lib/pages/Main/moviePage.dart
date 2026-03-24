import 'package:flutter/material.dart';
import 'package:ott/pages/Main/movie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header with Play button
            _Header(movie: movie),

            const SizedBox(height: 16),

            // Rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    movie.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < movie.rating.round()
                            ? Icons.star
                            : Icons.star_border,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                movie.description,
                style: const TextStyle(height: 1.4, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 20),

            // Watch Now button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerPage(
                          videoUrl: movie.videoUrl,
                          movieTitle: movie.title,
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded, size: 22),
                      SizedBox(width: 6),
                      Text(
                        'WATCH TRAILER',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Trailer disclaimer
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'This plays the official YouTube trailer. No full movies are hosted or streamed.',
                style: TextStyle(color: Colors.white38, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Episodes
            movie.episodes.isNotEmpty ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Episodes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(),
            const SizedBox(height: 12),

            ...List.generate(
              movie.episodes.length,
              (i) => _EpisodeTile(
                index: i + 1,
                title: movie.episodes[i].title,
                duration: movie.episodes[i].duration,
                imageUrl: movie.episodes[i].imageUrl,
                videoUrl: movie.episodes[i].videoUrl,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Movie movie;
  const _Header({required this.movie});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Show banner image instead of auto-playing video
          Image.asset(
            movie.bannerUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(Icons.movie, size: 60, color: Colors.white38),
                ),
              );
            },
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(120),
                  Colors.transparent,
                  Colors.black.withAlpha(180),
                ],
              ),
            ),
          ),
          // Play trailer button
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerPage(
                      videoUrl: movie.videoUrl,
                      movieTitle: movie.title,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white54),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
                    SizedBox(width: 6),
                    Text(
                      'Play Trailer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 8,
            left: 8,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text(
                      "Back",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Movie title
          Positioned(
            bottom: 12,
            left: 16,
            right: 16,
            child: Text(
              movie.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(blurRadius: 8, color: Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  final int index;
  final String title;
  final String duration;
  final String imageUrl;
  final String videoUrl;

  const _EpisodeTile({
    required this.index,
    required this.title,
    required this.duration,
    required this.imageUrl,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // Thumbnail
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 120,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoPlayerPage(
                            videoUrl: videoUrl,
                            movieTitle: title,
                          ),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$index. $title',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(duration, style: const TextStyle(color: Colors.white54)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.download_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Download',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Separate trailer player screen
class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String movieTitle;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    this.movieTitle = '',
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl.trim());

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? 'dQw4w9WgXcQ',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.movieTitle.isNotEmpty
              ? '${widget.movieTitle} — Trailer'
              : 'Official Trailer',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) {
          return SafeArea(
            child: Column(
              children: [
                AspectRatio(aspectRatio: 16 / 9, child: player),
                const SizedBox(height: 16),
                Text(
                  widget.movieTitle.isNotEmpty
                      ? '${widget.movieTitle} — Official Trailer'
                      : 'Official Trailer',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Video sourced from official YouTube channels.',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
