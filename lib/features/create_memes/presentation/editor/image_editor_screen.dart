import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pro_image_editor/core/models/editor_callbacks/pro_image_editor_callbacks.dart';
import 'package:pro_image_editor/core/models/editor_configs/pro_image_editor_configs.dart';
import 'package:pro_image_editor/features/main_editor/main_editor.dart';

class ImageEditorScreen extends StatefulWidget {
  final File? file;
  const ImageEditorScreen({super.key, this.file});

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProImageEditor.file(
      widget.file!,
      callbacks: ProImageEditorCallbacks(
        onImageEditingComplete: (Uint8List bytes) async {
          final tempDir = Directory.systemTemp;
          final file = await File(
            '${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ).writeAsBytes(bytes);

          context.pop(file);
        },
      ),
    ));
  }
}
