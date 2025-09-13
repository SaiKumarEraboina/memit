import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TestScreen extends StatefulWidget {
  final String outputPath;
  const TestScreen({super.key, required this.outputPath});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    final file = File(widget.outputPath);

    final controller = VideoPlayerController.file(file);
    _initializeVideoPlayerFuture = controller.initialize().then((_) {
      controller.setLooping(true);
      controller.play();
      setState(() {});
    });
    _controller = controller;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video from File")),
      body: Center(
        child:
            _controller == null
                ? const CircularProgressIndicator()
                : FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
      ),
      floatingActionButton:
          _controller == null
              ? null
              : FloatingActionButton(
                onPressed: () {
                  setState(() {
                    if (_controller!.value.isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                  });
                },
                child: Icon(
                  _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
    );
  }
}
