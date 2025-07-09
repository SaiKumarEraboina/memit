import 'package:flutter/material.dart';
import 'package:memit/common_widgets/responsive_center.dart';
import 'package:memit/constants/app_sizes.dart';
import 'package:memit/constants/breakpoints.dart';

/// Scrollable widget that shows a responsive card with a given child widget.
/// Useful for displaying forms and other widgets that need to be scrollable.
class ResponsiveScrollableCard extends StatelessWidget {
  const ResponsiveScrollableCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.p16,
            vertical: Sizes.p12,
          ),
          child: SizedBox(
            child: 
            child,
          ),
        ),
      ),
    );
  }
}
