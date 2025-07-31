import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memit/constants/constants.dart';
import 'package:memit/routing/app_routes.dart';

class FileInputScreen extends StatefulWidget {
  final CollageType? collageType;

  const FileInputScreen({super.key, this.collageType});

  @override
  State<FileInputScreen> createState() => _FileInputScreenState();
}

class _FileInputScreenState extends State<FileInputScreen> {
  File? image;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image'),
        actions: [
          TextButton(
            onPressed: () {
              context.push(AppRoutes.memeDataScreen, extra: image?.path);
            },
            child: Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: pickImage,
          child:
              image == null
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_circle_outline, size: 64),
                      SizedBox(height: 10),
                      Text("Tap to upload an image"),
                    ],
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.file(image!, height: 300),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: pickImage,
                        child: const Text("Change Image"),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
