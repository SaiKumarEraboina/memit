import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageCropperScreen extends StatefulWidget {
  final File? imageFile;
  final Uint8List? imageBytes;

  const ImageCropperScreen(this.imageFile, {super.key}) : imageBytes = null;
  const ImageCropperScreen.memory(this.imageBytes, {super.key}) : imageFile = null;

  @override
  State<ImageCropperScreen> createState() => _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  final _cropController = CropController();
  Uint8List? _imageData; // nullable
  bool _isCropping = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (!kIsWeb && widget.imageFile != null) {
      _imageData = await widget.imageFile!.readAsBytes();
    } else if (kIsWeb && widget.imageBytes != null) {
      _imageData = widget.imageBytes!;
    }
    setState(() {}); // trigger rebuild after loading
  }

  void _cropImage() {
    setState(() => _isCropping = true);
    _cropController.crop();
  }

  Future<void> _onCropped(BuildContext context, Uint8List croppedData) async {
    setState(() => _isCropping = false);

    if (!mounted) return;

    if (!kIsWeb) {
      // Save cropped image to a file (for mobile/desktop)
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(croppedData);
      Navigator.pop(context, file); // Send file back
    } else {
      // For web, return bytes directly
      Navigator.pop(context, croppedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Crop Image')),
      body: Column(
        children: [
          Expanded(
            child: Crop(
  controller: _cropController,
  image: _imageData!,
  onCropped: (croppedData) => _onCropped(context, croppedData as Uint8List),
  maskColor: Colors.black.withAlpha(100),
  baseColor: Colors.white,
  radius: 20,
),


          ),
          if (!_isCropping)
            ElevatedButton(
              onPressed: _cropImage,
              child: const Text('Crop Image'),
            ),
          if (_isCropping)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
