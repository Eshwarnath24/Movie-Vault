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

  bool _isSelectionMode = false;
  final Set<MovieDownload> _selectedItems = {};

  void _toggleSelection(MovieDownload item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
      if (_selectedItems.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _deleteSelectedItems() {
    setState(() {
      downloads.removeWhere((item) => _selectedItems.contains(item));
      _selectedItems.clear();
      _isSelectionMode = false;
    });
  }

  AppBar _buildAppBar() {
    if (_isSelectionMode) {
      // Contextual AppBar for selection mode
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() {
            _isSelectionMode = false;
            _selectedItems.clear();
          }),
        ),
        title: Text('${_selectedItems.length} selected'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _selectedItems.isNotEmpty ? _deleteSelectedItems : null,
            tooltip: "Delete selected items",
          ),
        ],
      );
    } else {
      // --- CHANGE: Normal AppBar now has no title and a custom title widget ---
      return AppBar(
        automaticallyImplyLeading: false,
        // The title is now a Column containing the storage info
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Storage used: 2.3 GB of 10 GB",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: 0.23, // 2.3 GB / 10 GB
              backgroundColor: Colors.grey.withOpacity(0.5),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 2,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => setState(() => _isSelectionMode = true),
            tooltip: "Select items",
          ),
        ],
        // --- CHANGE: Removed the bottom property ---
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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
    );
  }

  Widget _buildDownloadItem(MovieDownload item) {
    final isSelected = _selectedItems.contains(item);

    return Dismissible(
      key: ValueKey(item.title),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          downloads.remove(item);
          _selectedItems.remove(item);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${item.title} deleted')));
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isSelected ? Colors.blue.withOpacity(0.2) : null,
        child: ListTile(
          onTap: () {
            if (_isSelectionMode) {
              _toggleSelection(item);
            }
          },
          onLongPress: () {
            if (!_isSelectionMode) {
              setState(() {
                _isSelectionMode = true;
                _toggleSelection(item);
              });
            }
          },
          leading: _isSelectionMode
              ? Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) => _toggleSelection(item),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item.thumbnail,
                    width: 60,
                    height: 80,
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
          trailing: _isSelectionMode ? null : _buildActions(item),
        ),
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
                MaterialPageRoute(builder: (context) => const OttSearchPage()),
              );
            },
            child: const Text("Browse Content"),
          ),
        ],
      ),
    );
  }
}
