import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MemeBody extends StatelessWidget {
  final String postUrl;

  const MemeBody({super.key, required this.postUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          child: CachedNetworkImage(
            imageUrl: postUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder:
                (context, url) => Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
            errorWidget:
                (context, url, error) => Image.asset(
                  'assets/images/image_not_found.png',
                  fit: BoxFit.cover,
                ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 18,
                ),
                SizedBox(width: 4),
                Text("Trending", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
