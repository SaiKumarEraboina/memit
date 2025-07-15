import 'package:flutter/material.dart';
import 'package:memit/features/create_memes/presentation/add_media_button.dart';
import 'package:memit/features/create_memes/presentation/media_controller.dart';
import 'package:memit/features/create_memes/presentation/media_view.dart';

class SelectMediaFromSource extends StatefulWidget {
  const SelectMediaFromSource({super.key});

  @override
  State<SelectMediaFromSource> createState() => _SelectMediaFromSourceState();
}

class _SelectMediaFromSourceState extends State<SelectMediaFromSource> {
  final controller = SelectMediaController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleTap(BuildContext context) {
    if (controller.hasMedia) {
      controller.openEditor(context).then((_) => setState(() {}));
    } else {
      controller.showAddDialog(
        context,
        onUpdate: () => setState(() {}),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleTap(context),
      child: controller.hasNoMedia
          ? const AddMediaButton()
          : MediaViewer(
              isVideo: controller.isVideo,
              videoController: controller.videoController,
              imageFile: controller.selectedFile,
              webImageBytes: controller.webImageBytes,
              onTap: () => controller.openEditor(context),
            ),
    );
  }
}
