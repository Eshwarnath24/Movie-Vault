import 'package:flutter/material.dart';
import 'package:ott/pages/Authorization/signin.dart'; // Make sure this path is correct for your project
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.asset('assets/videos/logo.mp4')
      ..initialize().then((_) {
        // Safety Check: Ensure the widget is still mounted before calling setState.
        if (mounted) {
          setState(() {});
          // Mute the video to comply with browser autoplay policies.
          _controller.setVolume(0.0);
          _controller.play();
        }
      });

    // Add the listener to navigate when the video ends.
    _controller.addListener(_checkVideo);
  }

  void _checkVideo() {
    // Check if the video has finished playing.
    if (_controller.value.isInitialized &&
        _controller.value.position >= _controller.value.duration) {
      // Important: Remove the listener before navigating to prevent errors
      // on the disposed widget.
      _controller.removeListener(_checkVideo);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Signin()),
      );
    }
  }

  @override
  void dispose() {
    // Clean up the controller and listener when the widget is disposed.
    _controller.removeListener(_checkVideo);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(), // Show an empty container while the video is loading
      ),
    );
  }
}