import 'package:flutter/material.dart';
import 'package:memit/features/profile/models/profile_model.dart';

class ProfileBioSection extends StatelessWidget {
  final ProfileModel profile;
  const ProfileBioSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Text(
            profile.name ?? 'Memit User',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Text(
            profile.bio ?? '',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
