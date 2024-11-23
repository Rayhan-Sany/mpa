import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerScreen extends StatefulWidget {
  final String videoId;

  const YoutubePlayerScreen({super.key, required this.videoId});

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the YouTube player controller
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        enableCaption: true,
      ),
    );
    _controller.loadVideoById(videoId: widget.videoId);
    // Lock orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Reset orientation and UI mode when disposing
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // Close the YouTube player controller
    // _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        panEnabled: false, // Disable panning if not needed
        boundaryMargin: const EdgeInsets.all(0),
        minScale: 1.0, // Minimum zoom scale
        maxScale: 3.0,
        // Maximum zoom scale
        child: YoutubePlayerControllerProvider(
          controller: _controller,
          child: YoutubePlayer(
            controller: _controller,
            aspectRatio: 16 / 9, // Aspect ratio for the video
          ),
        ),
      ),
    );
  }
}
