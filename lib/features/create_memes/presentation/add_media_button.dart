import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddMediaButton extends StatelessWidget {
  const AddMediaButton({
    super.key,
    required this.onPickMedia,
    required this.index,
  });

  final Future<void> Function(int) onPickMedia;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPickMedia(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/add_circle.svg'),
          const SizedBox(height: 8),
          const Text(
            'Add Image/Video here',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
