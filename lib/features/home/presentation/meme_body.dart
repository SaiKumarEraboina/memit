import 'package:flutter/material.dart';

class MemeBody extends StatelessWidget { 
  final String postUrl;
  const MemeBody({super.key, required this.postUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          child: Image.network(
            postUrl,
            fit: BoxFit.cover,
            // height: 250,
            width: double.infinity, 
            errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/image_not_found.png'),
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

