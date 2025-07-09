import 'package:flutter/material.dart';
import 'package:memit/constants/app_sizes.dart';

class MemeHeader extends StatelessWidget {
  final String imageUrl;
  final String username;
  const MemeHeader({super.key, required this.imageUrl, required this.username});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.network(
            imageUrl,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 48,
                height: 48,
                color: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.grey),
              );
            },
          ),
        ),

        gapW12,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                maxLines: 1,
                style: TextStyle(
                  overflow: TextOverflow.fade,
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0,
                ),
              ),
              Text(
                'User Name Pro',
                style: TextStyle(
                  overflow: TextOverflow.fade,
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),

        // ElevatedButton(
        //   onPressed: () {},
        //   child: Text('Following'),
        // ),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded)),
      ],
    );
  }
}
