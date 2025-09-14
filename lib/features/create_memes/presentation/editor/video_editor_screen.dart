import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memit/features/create_memes/presentation/trimmer_view.dart';

class VideoEditorScreen extends StatefulWidget {
  final File? file;
  const VideoEditorScreen({super.key, this.file});

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  @override
  Widget build(BuildContext context) {
    return TrimmerView(widget.file!);
  }
}
