import 'package:flutter/material.dart';

class PostsGridSection extends StatelessWidget {
  const PostsGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true, 
      physics: NeverScrollableScrollPhysics(), 
      itemCount: 40,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final url = 'https://picsum.photos/280/300?random=$index';

        return Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (ctx, child, progress) =>
              progress == null ? child : const Center(child: CircularProgressIndicator()),
          errorBuilder: (ctx, error, stack) =>
              const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
        );
      },
    );
  }
}
