import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:memit/constants/constants.dart';
import 'package:memit/features/create_memes/presentation/add_media_button.dart';
import 'package:memit/features/create_memes/presentation/media_preview.dart';
import 'package:memit/routing/app_routes.dart';


class FileInputScreen extends StatefulWidget {
  final CollageType collageType;

  const FileInputScreen({super.key, required this.collageType});

  @override
  State<FileInputScreen> createState() => _FileInputScreenState();
}

class _FileInputScreenState extends State<FileInputScreen> {
  List<File?> files = List.generate(3, (_) => null); // images

  Future<void> pickMedia(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
    allowedExtensions: [
      'jpg', 'jpeg', 'png', // images
      'mp4', 'mov', 'avi', 'mkv' // videos
    ],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        files[index] = File(result.files.single.path!);
      });
    }
  }

  /// Generates a collage image file and returns its path
  Future<String?> createCollage() async {
    final selectedFiles = files.whereType<File>().toList();
    if (selectedFiles.isEmpty) return null;

    // Decode images
    List<img.Image> decodedImages = selectedFiles.map((file) {
      return img.decodeImage(file.readAsBytesSync())!;
    }).toList();

    late img.Image collage;

    switch (widget.collageType) {
      case CollageType.single:
        collage = decodedImages.first;
        break;

      case CollageType.halfSplit:
        int maxWidth = decodedImages.map((im) => im.width).reduce((a, b) => a > b ? a : b);
        int totalHeight = decodedImages.fold(0, (sum, im) => sum + im.height);

        collage = img.Image(width: maxWidth, height: totalHeight);

        int y = 0;
        for (var im in decodedImages) {
          img.compositeImage(collage, im, dstX: 0, dstY: y);
          y += im.height;
        }
        break;

      case CollageType.oneByTwo:
        img.Image top = decodedImages[0];
        img.Image left = decodedImages.length > 1
            ? decodedImages[1]
            : img.Image(width: top.width ~/ 2, height: top.height ~/ 2);
        img.Image right = decodedImages.length > 2
            ? decodedImages[2]
            : img.Image(width: top.width ~/ 2, height: top.height ~/ 2);

        int collageWidth = top.width;
        int collageHeight = top.height + left.height;

        collage = img.Image(width: collageWidth, height: collageHeight);

        img.compositeImage(collage, top, dstX: 0, dstY: 0);
        img.compositeImage(collage, left, dstX: 0, dstY: top.height);
        img.compositeImage(collage, right, dstX: left.width, dstY: top.height);
        break;

      default:
        return null;
    }

    // Save collage to temp file
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/collage_${DateTime.now().millisecondsSinceEpoch}.png';
    File(path).writeAsBytesSync(img.encodePng(collage));

    return path;
  }

  Widget _buildCollageLayout() {
    switch (widget.collageType) {
      case CollageType.single:
        return files[0] == null
            ? AddMediaButton(onPickMedia: pickMedia, index: 0)
            : MediaPreview(file: files[0]!);

      case CollageType.halfSplit:
        return Column(
          children: [
            Expanded(
              child: files[0] == null
                  ? AddMediaButton(onPickMedia: pickMedia, index: 0)
                  : MediaPreview(file: files[0]!),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            Expanded(
              child: files[1] == null
                  ? AddMediaButton(onPickMedia: pickMedia, index: 1)
                  : MediaPreview(file: files[1]!),
            ),
          ],
        );

      case CollageType.oneByTwo:
        return Column(
          children: [
            Expanded(
              child: files[0] == null
                  ? AddMediaButton(onPickMedia: pickMedia, index: 0)
                  : MediaPreview(file: files[0]!),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: files[1] == null
                        ? AddMediaButton(onPickMedia: pickMedia, index: 1)
                        : MediaPreview(file: files[1]!),
                  ),
                  const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
                  Expanded(
                    child: files[2] == null
                        ? AddMediaButton(onPickMedia: pickMedia, index: 2)
                        : MediaPreview(file: files[2]!),
                  ),
                ],
              ),
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Collage'),
        actions: [
          TextButton(
            onPressed: files.whereType<File>().isNotEmpty
                ? () async {
                    final collagePath = await createCollage();
                    if (collagePath != null) {
                      context.push(
                        AppRoutes.memeDataScreen,
                        extra: collagePath,
                      );
                    }
                  }
                : null,
            child: const Text('Next', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(child: _buildCollageLayout()),
        ),
      ),
    );
  }
}
