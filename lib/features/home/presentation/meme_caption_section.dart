import 'package:flutter/material.dart';

class MemeCaptionSection extends StatelessWidget {
  final int views;
  final int timeAgo;
  final List<String> hashtags;
  final String description;

  const MemeCaptionSection({
    super.key,
    required this.views,
    required this.timeAgo,
    required this.hashtags,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "• ${views.toString()} Views• $timeAgo hours ago",
          style: const TextStyle(color: Colors.grey),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hashtags.join(' '), // join list into string
              style: const TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 4),
            Text(description, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ],
    );
  }
}
