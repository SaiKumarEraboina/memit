import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

import 'package:memit/features/create_memes/presentation/add_image_dialog.dart';
import 'package:memit/features/create_memes/presentation/trimmer_view.dart';
import 'package:memit/features/home/presentation/image_cropper.dart';

class SelectMediaFromSource extends StatefulWidget {
  const SelectMediaFromSource({super.key});

  @override
  State<SelectMediaFromSource> createState() => _SelectMediaFromSourceState();
}

class _SelectMediaFromSourceState extends State<SelectMediaFromSource> {
  File? _selectedMediaFile;
  Uint8List? _webImageBytes;
  bool _isVideo = false;
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_selectedMediaFile != null || _webImageBytes != null) {
          _openImageEditorScreen(context);
        } else {
          _showAddImageDialog(context);
        }
      },
      child:
          _selectedMediaFile == null && _webImageBytes == null
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/add_circle.svg'),
                  const Text('Add Image/video here'),
                ],
              )
              : SizedBox.expand(
                child:
                    _isVideo
                        ? _videoController != null &&
                                _videoController!.value.isInitialized
                            ? InteractiveViewer(
                              panEnabled: true,
                              scaleEnabled: true,
                              minScale: 0.5,
                              maxScale: 4.0,
                              child: AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              ),
                            )
                            : const Center(child: CircularProgressIndicator())
                        : InteractiveViewer(
                          panEnabled: true,
                          scaleEnabled: true,
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: GestureDetector(
                            onTap: () => _openImageEditorScreen(context),
                            child:
                                kIsWeb
                                    ? Image.memory(
                                      _webImageBytes!,
                                      fit: BoxFit.cover,
                                    )
                                    : Image.file(
                                      _selectedMediaFile!,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
              ),
    );
  }

  void _showAddImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AddImageDialog(
            onGalleryTap: () => _pickMediaFromGallery(ctx),
            onTemplateTap: () {
              // Add template logic here if needed
            },
          ),
    );
  }

  Future<void> _openImageEditorScreen(BuildContext context) async {
    if (_isVideo && _selectedMediaFile != null) {
      final trimmedPath = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => TrimmerView(_selectedMediaFile!)),
      );

      if (trimmedPath != null) {
        setState(() {
          _selectedMediaFile = File(trimmedPath);
        });
        await _initializeVideo(_selectedMediaFile!);
      }
    } else if (!_isVideo && _selectedMediaFile != null) {
      final croppedFile = await Navigator.push<File>(
        context,
        MaterialPageRoute(
          builder: (_) => ImageCropperScreen(_selectedMediaFile!),
        ),
      );

      if (croppedFile != null) {
        setState(() {
          _selectedMediaFile = croppedFile;
        });
      }
    } else if (!_isVideo && _webImageBytes != null) {
      final croppedBytes = await Navigator.push<Uint8List>(
        context,
        MaterialPageRoute(
          builder: (_) => ImageCropperScreen.memory(_webImageBytes!),
        ),
      );

      if (croppedBytes != null) {
        setState(() {
          _webImageBytes = croppedBytes;
        });
      }
    }
  }

  Future<void> _pickMediaFromGallery(BuildContext dialogContext) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'mp4', 'mov'],
      withData: true,
    );

    if (result == null) return;

    final fileBytes = result.files.single.bytes;
    final filePath = result.files.single.path;
    final isVideo = ['mp4', 'mov'].contains(result.files.single.extension);

    if (kIsWeb) {
      setState(() {
        _webImageBytes = isVideo ? null : fileBytes;
        _selectedMediaFile = null;
        _isVideo = isVideo;
      });
      // TODO: Add web video handling if needed
    } else {
      if (filePath == null) return;
      setState(() {
        _selectedMediaFile = File(filePath);
        _webImageBytes = null;
        _isVideo = isVideo;
      });

      if (isVideo) {
        await _initializeVideo(File(filePath));
      }
    }

    Navigator.of(dialogContext).pop();
  }

  Future<void> _initializeVideo(File file) async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(file);
    await _videoController!.initialize();
    _videoController!.setLooping(true);
    _videoController!.play();
    setState(() {});
  }
}
