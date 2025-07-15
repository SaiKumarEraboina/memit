
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

  bool get hasMedia => selectedFile != null || webImageBytes != null;
  bool get hasNoMedia => !hasMedia;

  void dispose() {
    videoController?.dispose();
  }

  // Show dialog to pick from gallery or template
  Future<void> showAddDialog(BuildContext context, {VoidCallback? onUpdate}) async {
    showDialog(
      context: context,
      builder: (ctx) => AddImageDialog(
        onGalleryTap: () async {
          Navigator.of(ctx).pop();
          await _pickMediaFromGallery(context);
          onUpdate?.call();
        },
        onTemplateTap: () {
          // Handle template logic if needed
        },
      ),
    );
  }

  // Opens editor depending on media type
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
      final cropped = await Navigator.push<File>(
        context,
        MaterialPageRoute(builder: (_) => ImageCropperScreen(selectedFile!)),
      );
      if (cropped != null) selectedFile = cropped;
    } else if (!isVideo && webImageBytes != null) {
      final cropped = await Navigator.push<Uint8List>(
        context,
        MaterialPageRoute(builder: (_) => ImageCropperScreen.memory(webImageBytes!)),
      );
      if (cropped != null) webImageBytes = cropped;
    }
  }

  // Pick image or video from file picker
  Future<void> _pickMediaFromGallery(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'mp4', 'mov'],
      withData: true,
    );
    if (result == null) return;

    final fileBytes = result.files.single.bytes;
    final filePath = result.files.single.path;
    final isPickedVideo = ['mp4', 'mov'].contains(result.files.single.extension);

    isVideo = isPickedVideo;

    if (kIsWeb) {
      webImageBytes = isVideo ? null : fileBytes;
      selectedFile = null;
    } else if (filePath != null) {
      selectedFile = File(filePath);
      webImageBytes = null;
      if (isVideo) await _initializeVideo(selectedFile!);
    }
  }

  // Initialize video for preview
  Future<void> _initializeVideo(File file) async {
    videoController?.dispose();
    videoController = VideoPlayerController.file(file);
    await videoController!.initialize();
    videoController!.setLooping(true);
    await videoController!.play();
  }
}
