import 'package:flutter/material.dart';
import 'package:memit/common_widgets/responsive_center.dart';
import 'package:memit/constants/app_sizes.dart';
import 'package:memit/constants/breakpoints.dart' show Breakpoint;

class MaximizedCollageScreen extends StatelessWidget {
  final Widget layout;

  const MaximizedCollageScreen({super.key, required this.layout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFF3F5),
      appBar: AppBar(title: const Text('Add Image')),
      body: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p12,
        ),
        child: Card(color: Colors.white, child: layout),
      ),
    );
  }
}
