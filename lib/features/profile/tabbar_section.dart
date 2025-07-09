import 'package:flutter/material.dart';

class TabBarSection extends StatelessWidget {
  const TabBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      tabs: [
        Tab(icon: Icon(Icons.dashboard_outlined),text:'Posts' ,),
        Tab(icon: Icon(Icons.thumb_up_outlined),text:'Likes'),
        Tab(icon: Icon(Icons.bookmark_outline),text:'Saved'),
      ],
    );
  }
}
