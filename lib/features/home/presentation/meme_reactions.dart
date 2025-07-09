import 'package:flutter/material.dart';

class ReactionBar extends StatelessWidget {
  final bool isLiked;
  final VoidCallback toggleLike;
  final VoidCallback toggleSave;
  final int likeCount;
  final bool isSaved;
  const ReactionBar({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.toggleLike,
    required this.toggleSave,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: toggleLike,
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: isLiked ? Colors.deepOrange : null,
            ),
          ),
          const SizedBox(width: 4),
          (likeCount > 999)
              ? Text('${(likeCount / 1000).toStringAsFixed(1)}k')
              : Text('$likeCount'),
          const SizedBox(width: 16),
          const Icon(Icons.mode_comment_outlined, size: 20),
          const SizedBox(width: 4),
          const Text("1k"),
          const SizedBox(width: 16),
          const Icon(Icons.ios_share_outlined, size: 20),
          const SizedBox(width: 4),
          const Text("65"),
          const Spacer(),
          IconButton(
            onPressed: toggleSave,
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? Colors.blue : null,
            ),
          ),
        ],
      ),
    );
  }
}
