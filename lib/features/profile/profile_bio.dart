
import 'package:flutter/material.dart';

class ProfileBioSection extends StatelessWidget {
  const ProfileBioSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.center,
        child: Text( 
          "Shiva\n flutter_world"
          "Flutter Dev 🚀\nLove coding and coffee ☕",
          style: TextStyle(fontSize: 14,),textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
