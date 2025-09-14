import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memit/constants/constants.dart';
import 'package:memit/features/create_memes/presentation/trimmer_view.dart';
import 'package:memit/global/helpers.dart';
import 'package:pro_image_editor/shared/services/content_recorder/utils/isolate_thread_utils.dart';
import 'package:video_player/video_player.dart';

class SelectPostsScreen extends StatefulWidget {
  final CollageType type;
  const SelectPostsScreen({super.key, required this.type});

  @override
  State<SelectPostsScreen> createState() => _SelectPostsScreenState();
}

class _SelectPostsScreenState extends State<SelectPostsScreen> {
  List<File?> selectedFiles = [];
  List<Uint8List?> webImages = [];
  List<VideoPlayerController?> videoControllers = [];

  bool isLoading = false;

  int get requiredImages {
    switch (widget.type) {
      case CollageType.single:
        return 1;
      case CollageType.twoGrid:
        return 2;
      case CollageType.threeGrid:
        return 3;
      case CollageType.fourGrid:
        return 4;
    }
  }

  @override
  void initState() {
    super.initState();
    selectedFiles = List.filled(requiredImages, null);
    webImages = List.filled(requiredImages, null);
    videoControllers = List.filled(requiredImages, null);
  }

  @override
  void dispose() {
    for (var controller in videoControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  Future<void> pickImage(int index) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: (widget.type == CollageType.single ||
              widget.type == CollageType.twoGrid)
          ? [
              'jpg',
              'png',
              'jpeg',
              'mp4',
              'mov',
            ]
          : [
              'jpg',
              'png',
              'jpeg',
            ],
      withData: kIsWeb,
    );
    if (result != null) {
      final PlatformFile file = result.files.first;

      final isVideo = file.extension?.toLowerCase() == 'mp4' ||
          file.extension?.toLowerCase() == 'mov';

      if (isVideo) {
        final File? outputFile = await Navigator.push<File?>(
          context,
          MaterialPageRoute(builder: (_) => TrimmerView(File(file.path!))),
        );

        VideoPlayerController? controller;
        controller = VideoPlayerController.file(File(outputFile!.path));
        await controller.initialize();

        setState(() {
          selectedFiles[index] = outputFile;
          videoControllers[index] = controller;
        });
      } else {
        //navigate to image editor screen.
        File? outputFile =
            await context.pushNamed('imageEditor', extra: File(file.path!));
        if (outputFile != null) {
          setState(() {
            selectedFiles[index] = outputFile;
          });
        }
      }
    }
  }

  Widget buildMediaPreview(int index) {
    final file = selectedFiles[index];
    final webImg = webImages[index];
    final controller = videoControllers[index];
    if (file == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey[500]),
            if (widget.type == CollageType.single ||
                widget.type == CollageType.twoGrid)
              Text('Image/Video')
            else
              Text('Image')
          ],
        ),
      );
    }

    final bool isVideo = isVideoFile(file);

    if (isVideo) {
      if (controller != null && controller.value.isInitialized) {
        return Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                });
              },
              child: Icon(
                controller.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.white.withOpacity(0.7),
                size: 48,
              ),
            ),
          ],
        );
      } else {
        return const Center(
            child: Icon(Icons.videocam, size: 40, color: Colors.grey));
      }
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: kIsWeb && webImg != null
            ? Image.memory(webImg,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity)
            : Image.file(File(file.path),
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity),
      );
    }
  }

  Widget buildImagePicker(int index) {
    return GestureDetector(
      onTap: () => pickImage(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: buildMediaPreview(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (widget.type) {
      case CollageType.single:
        content = AspectRatio(
          aspectRatio: 1,
          child: buildImagePicker(0),
        );
        break;
      case CollageType.twoGrid:
        content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Expanded(
                  child:
                      AspectRatio(aspectRatio: 1, child: buildImagePicker(0))),
              const SizedBox(height: 8),
              Expanded(
                  child:
                      AspectRatio(aspectRatio: 1, child: buildImagePicker(1))),
            ],
          ),
        );
        break;
      case CollageType.threeGrid:
        content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            children: [
              Expanded(child: buildImagePicker(0)),
              const SizedBox(height: 8),
              Expanded(child: buildImagePicker(1)),
              const SizedBox(height: 8),
              Expanded(child: buildImagePicker(2)),
            ],
          ),
        );
        break;
      case CollageType.fourGrid:
        content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            spacing: 4,
            children: [
              Expanded(child: buildImagePicker(0)),
              Expanded(child: buildImagePicker(1)),
              Expanded(child: buildImagePicker(2)),
              Expanded(child: buildImagePicker(3)),
            ],
          ),
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : GestureDetector(
                  onTap: _handleOnTap,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Done',
                      style: TextStyle(
                          color: isEnabled() ? Colors.black : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
        ],
        title: const Text('Select Posts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
  }

  bool isEnabled() {
    // Return enabled color only if all required files are picked (not null)
    bool allPicked = selectedFiles.length == requiredImages &&
        selectedFiles.every((file) => file != null);

    return allPicked;
  }

  void _handleOnTap() async {
    if (!isEnabled()) return;

    switch (widget.type) {
      case CollageType.single:
        // Just send the output file to next screen
        if (selectedFiles[0] != null) {
          context.pushNamed('postMeme', extra: selectedFiles[0]);
        }
        break;

      case CollageType.twoGrid:
        {
          final file1 = selectedFiles[0];
          final file2 = selectedFiles[1];
          final isVideo1 = file1 != null && isVideoFile(file1);
          final isVideo2 = file2 != null && isVideoFile(file2);

          if (!isVideo1 && !isVideo2) {
            // Both images: create vertical collage image

            setState(() {
              isLoading = true;
            });

            final String? collage =
                await mergeImagesAsCollage([file1!.path, file2!.path]);

            setState(() {
              isLoading = false;
            });

            context.pushNamed('postMeme', extra: File(collage!));
          } else if (isVideo1 && isVideo2) {
            // Both videos: create vertical collage video

            setState(() {
              isLoading = true;
            });

            final String? collage =
                await mergeTwoVideos(file1.path, file2.path);

            setState(() {
              isLoading = false;
            });

            if (collage != null) {
              context.pushNamed('postMeme', extra: File(collage));
            }
          } else if (!isVideo1 && isVideo2) {
            // Image top, video bottom

            setState(() {
              isLoading = true;
            });
            final String? collage =
                await mergeImageOnTopVideoBottom(file2.path, file1!.path);

            setState(() {
              isLoading = false;
            });
            if (collage != null) {
              context.pushNamed('postMeme', extra: File(collage));
            }
          } else if (isVideo1 && !isVideo2) {
            // Video top, image bottom

            setState(() {
              isLoading = true;
            });

            final String? collage = await mergeVideoOnTopImageBottom(
              file1.path,
              file2!.path,
            );

            setState(() {
              isLoading = false;
            });
            if (collage != null) {
              context.pushNamed('postMeme', extra: File(collage));
            }
          }
          break;
        }

      // For threeGrid and fourGrid, you can implement similar logic as needed.
      case CollageType.threeGrid:
        {
          final file1 = selectedFiles[0];
          final file2 = selectedFiles[1];
          final file3 = selectedFiles[2];

          setState(() {
            isLoading = true;
          });

          final String? collage = await mergeImagesAsCollage(
              [file1!.path, file2!.path, file3!.path]);

          setState(() {
            isLoading = false;
          });

          context.pushNamed('postMeme', extra: File(collage!));

          break;
        }
      case CollageType.fourGrid:
        {
          final file1 = selectedFiles[0];
          final file2 = selectedFiles[1];
          final file3 = selectedFiles[2];
          final file4 = selectedFiles[3];

          setState(() {
            isLoading = true;
          });

          final String? collage = await mergeImagesAsCollage(
              [file1!.path, file2!.path, file3!.path, file4!.path]);

          setState(() {
            isLoading = false;
          });

          context.pushNamed('postMeme', extra: File(collage!));
          break;
        }
    }
  }
}
