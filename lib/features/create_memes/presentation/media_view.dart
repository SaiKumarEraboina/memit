
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaViewer extends StatelessWidget {
  const MediaViewer({
    super.key,
    required this.isVideo,
    required this.videoController,
    required this.imageFile,
    required this.webImageBytes,
    required this.onTap,
  });

  final bool isVideo;
  final VideoPlayerController? videoController;
  final File? imageFile;
  final Uint8List? webImageBytes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isVideo) {
      // Display video inside zoomable viewer
      if (videoController != null && videoController!.value.isInitialized) {
        return InteractiveViewer(
          panEnabled: true,
          scaleEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: AspectRatio(
            aspectRatio: videoController!.value.aspectRatio,
            child: VideoPlayer(videoController!),
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    } else {
      // Display image (from web or local)
      return InteractiveViewer(
        panEnabled: true,
        scaleEnabled: true,
        minScale: 0.5,
        maxScale: 4.0,
        child: GestureDetector(
          onTap: onTap,
          child: kIsWeb
              ? Image.memory(webImageBytes!, fit: BoxFit.cover)
              : Image.file(imageFile!, fit: BoxFit.cover),
        ),
      );
    }
  }
}
