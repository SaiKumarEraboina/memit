import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memit/common_widgets/responsive_center.dart';
import 'package:memit/constants/app_sizes.dart';
import 'package:memit/constants/breakpoints.dart' show Breakpoint;
import 'package:memit/routing/app_routes.dart';

class MaximizedCollageScreen extends StatelessWidget {
  final Widget layout;

  const MaximizedCollageScreen({super.key, required this.layout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFF3F5),
      appBar: AppBar(
        title: const Text('Add Image'),
        actions: [
          TextButton(
            onPressed: () {
              context.push(AppRoutes.createMemes, extra: '');
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
