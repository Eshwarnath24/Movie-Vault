import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'OTT Downloads',
//       home: const DownloadsPage(),
//     );
//   }
// }~

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  // Mock Data for Downloads

  final List<Map<String, dynamic>> downloads = [
    {
      "title": "Master",
      "subtitle": "2h 59m • HD",
      "thumbnail": "assets/images/master.jpg",
      "status": "completed",
    },
    {
      "title": "Star Wars: A New Hope",
      "subtitle": "2h 1m • HD",
      "thumbnail": "assets/images/star_wars.jpg",
      "status": "in-progress",
      "progress": 0.4,
    },
    {
      "title": "Titanic",
      "subtitle": "3h 14m • HD",
      "thumbnail": "assets/images/titanic.jpg",
      "status": "failed",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () {
              // bulk delete logic later
            },
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

  Widget _buildDownloadItem(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              item["thumbnail"] != null &&
                  item["thumbnail"].toString().isNotEmpty
              ? Image.asset(
                  item["thumbnail"],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover, // ✅ Ensures image fills the box
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                )
              : _buildPlaceholder(),
        ),
        title: Text(
          item["title"],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item["subtitle"]),
            const SizedBox(height: 4),
            if (item["status"] == "in-progress")
              LinearProgressIndicator(
                value: item["progress"],
                minHeight: 5,
                backgroundColor: Colors.grey[300],
              ),
            if (item["status"] == "failed")
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

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[300],
      child: const Icon(Icons.movie, color: Colors.grey),
    );
  }

  Widget _buildActions(Map<String, dynamic> item) {
    switch (item["status"]) {
      case "completed":
        return IconButton(
          icon: const Icon(Icons.play_circle_fill, color: Colors.blue),
          onPressed: () {
            // play logic
          },
        );
      case "in-progress":
        return IconButton(
          icon: const Icon(Icons.pause_circle_filled, color: Colors.orange),
          onPressed: () {
            // pause logic
          },
        );
      case "failed":
        return IconButton(
          icon: const Icon(Icons.refresh, color: Colors.red),
          onPressed: () {
            // retry logic
          },
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
              // navigate to browse
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
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: const Border(top: BorderSide(color: Colors.grey)),
      ),
      child: const Text(
        "Storage used: 2.3 GB of 10 GB",
        style: TextStyle(color: Colors.black54),
      ),
    );
  }
}
