import 'package:flutter/material.dart';
import 'package:memit/features/create_memes/presentation/image_option_card.dart';

class AddImageDialog extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onTemplateTap;

  const AddImageDialog({
    super.key,
    required this.onGalleryTap,
    required this.onTemplateTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Row(
            children: [
              Expanded(
                child: ImageOptionCard(
                  assetPath: 'assets/icons/gallery.svg',
                  onTap: onGalleryTap,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ImageOptionCard(
                  assetPath: 'assets/icons/template.svg',
                  onTap: onTemplateTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
