import 'package:flutter/material.dart';

class ProfileStat extends StatelessWidget {
  final String title;
  final String count;

  const ProfileStat({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(title),
      ],
    );
  }
}
