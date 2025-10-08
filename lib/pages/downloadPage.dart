import 'package:flutter/material.dart';
import 'searchPage.dart';

class MovieDownload {
  final String title;
  final String subtitle;
  final String thumbnail;
  final String status; // "completed", "in-progress", "failed"
  final double? progress; // only used if in-progress

  MovieDownload({
    required this.title,
    required this.subtitle,
    required this.thumbnail,
    required this.status,
    this.progress,
  });
}

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  final List<MovieDownload> downloads = [
    MovieDownload(
      title: "Master",
      subtitle: "2h 59m • HD",
      thumbnail: "assets/images/master.jpg",
      status: "completed",
    ),
    MovieDownload(
      title: "Star Wars: A New Hope",
      subtitle: "2h 1m • HD",
      thumbnail: "assets/images/star_wars.jpg",
      status: "in-progress",
      progress: 0.4,
    ),
    MovieDownload(
      title: "Titanic",
      subtitle: "3h 14m • HD",
      thumbnail: "assets/images/titanic.jpg",
      status: "failed",
    ),
  ];

  // final List<MovieDownload> downloads = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: downloads.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: downloads.length,
              itemBuilder: (context, index) {
                final item = downloads[index];
                return _buildDownloadItem(item);
              },
            ),
      bottomNavigationBar: _buildStorageInfo(),
    );
  }

  Widget _buildDownloadItem(MovieDownload item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            item.thumbnail,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.subtitle),
            const SizedBox(height: 4),
            if (item.status == "in-progress")
              LinearProgressIndicator(
                value: item.progress,
                minHeight: 5,
                backgroundColor: Colors.grey[300],
              ),
            if (item.status == "failed")
              const Text(
                "Download failed. Retry?",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
          ],
        ),
        trailing: _buildActions(item),
      ),
    );
  }

  Widget _buildActions(MovieDownload item) {
    switch (item.status) {
      case "completed":
        return IconButton(
          icon: const Icon(Icons.play_circle_fill, color: Colors.blue),
          onPressed: () {},
        );
      case "in-progress":
        return IconButton(
          icon: const Icon(Icons.pause_circle_filled, color: Colors.orange),
          onPressed: () {},
        );
      case "failed":
        return IconButton(
          icon: const Icon(Icons.refresh, color: Colors.red),
          onPressed: () {},
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.download_for_offline, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "No downloads yet!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Save your favorite shows to watch offline.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OttSearchPage()),
              );
            },
            child: const Text("Browse Content"),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: const Text(
        "Storage used: 2.3 GB of 10 GB",
        style: TextStyle(color: Colors.black54),
      ),
    );
  }
}
