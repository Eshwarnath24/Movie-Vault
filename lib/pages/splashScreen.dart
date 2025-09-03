import 'package:flutter/material.dart';
import 'package:ott/pages/signin.dart';
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

    _controller = VideoPlayerController.asset('assets/videos/logo.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
        // **Start playing the video automatically**
        _controller.play();
      });

    // **Add a listener to navigate when the video completes**
    _controller.addListener(() {
      // Check if the video has finished playing
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Signin()),
        );
      }
    });
  }

  @override
  void dispose() {
    // Ensure you dispose of the controller to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // **Set the background to black**
      backgroundColor: Color.fromRGBO(29, 29, 29, 1),
      body: Center(
        // Show the video if it's initialized, otherwise show an empty container
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }
}