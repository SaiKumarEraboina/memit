import 'package:flutter/material.dart';

class BioBox extends StatelessWidget {
  const BioBox({super.key, required this.newBio});

  final String newBio;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 60,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
      child: Text(newBio.isNotEmpty ? newBio:'Empty Bio..'),
    );
  }
}
