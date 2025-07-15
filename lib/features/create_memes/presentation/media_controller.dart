// 📁 select_media_controller.dart

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:memit/features/create_memes/presentation/add_image_dialog.dart';
import 'package:memit/features/create_memes/presentation/trimmer_view.dart';
import 'package:memit/features/home/presentation/image_cropper.dart';

class SelectMediaController {
  File? selectedFile;
  Uint8List? webImageBytes;
  bool isVideo = false;
  VideoPlayerController? videoController;

  /// Check if user has picked any media
  bool get hasMedia => selectedFile != null || webImageBytes != null;
  bool get hasNoMedia => !hasMedia;

  /// Dispose the video controller when widget is disposed
  void dispose() {
    videoController?.dispose();
  }

  /// Show dialog to pick media
  void showAddDialog(BuildContext context, {required VoidCallback onUpdate}) {
    showDialog(
      context: context,
      builder:
          (ctx) => AddImageDialog(
            onGalleryTap: () => _pickFromGallery(ctx, onUpdate),
            onTemplateTap: () {},
          ),
    );
  }

  /// Pick media from gallery using FilePicker
  Future<void> _pickFromGallery(
    BuildContext dialogContext,
    VoidCallback onUpdate,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'mp4', 'mov'],
      withData: true,
    );

    if (result == null) return;

    final isVideoFile = ['mp4', 'mov'].contains(result.files.single.extension);

    if (kIsWeb) {
      webImageBytes = isVideoFile ? null : result.files.single.bytes;
      selectedFile = null;
      isVideo = isVideoFile;
    } else {
      final filePath = result.files.single.path;
      if (filePath == null) return;
      selectedFile = File(filePath);
      webImageBytes = null;
      isVideo = isVideoFile;

      if (isVideo) {
        await _initializeVideo(selectedFile!);
      }
    }

    onUpdate();
    Navigator.of(dialogContext).pop();
  }

  /// Open image cropper or video trimmer
  Future<void> openEditor(BuildContext context) async {
    if (isVideo && selectedFile != null) {
      final trimmedPath = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => TrimmerView(selectedFile!)),
      );

      if (trimmedPath != null) {
        selectedFile = File(trimmedPath);
        await _initializeVideo(selectedFile!);
      }
    } else if (!isVideo && selectedFile != null) {
      final croppedFile = await Navigator.push<File>(
        context,
        MaterialPageRoute(builder: (_) => ImageCropperScreen(selectedFile!)),
      );
      if (croppedFile != null) selectedFile = croppedFile;
    } else if (!isVideo && webImageBytes != null) {
      final croppedBytes = await Navigator.push<Uint8List>(
        context,
        MaterialPageRoute(
          builder: (_) => ImageCropperScreen.memory(webImageBytes!),
        ),
      );
      if (croppedBytes != null) webImageBytes = croppedBytes;
    }
  }

  /// Prepare video controller
  Future<void> _initializeVideo(File file) async {
    videoController?.dispose();
    videoController = VideoPlayerController.file(file);
    await videoController!.initialize();
    videoController!.setLooping(true);
    await videoController!.play();
  }
}
