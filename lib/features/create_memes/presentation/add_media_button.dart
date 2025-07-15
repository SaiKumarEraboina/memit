import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddMediaButton extends StatelessWidget {
  const AddMediaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Add your asset SVG icon for visual indication
        SvgPicture.asset('assets/icons/add_circle.svg'),
        const SizedBox(height: 8),
        const Text('Add Image/Video here', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
