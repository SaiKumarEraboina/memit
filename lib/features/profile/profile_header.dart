import 'package:flutter/material.dart';
import 'package:memit/features/profile/profile_bio.dart';
import 'package:memit/features/profile/profile_stat.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Cover photo
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1503264116251-35a269479413?auto=format&fit=crop&w=1200&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Positioned CircleAvatar
            Positioned(
              bottom: -40,
              child: const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  'https://plus.unsplash.com/premium_photo-1719943510748-4b4354fbcf56?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fG5hdHVyZXxlbnwwfHwwfHx8MA%3D%3D',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 48), // Space below the avatar

        // Bio and Stats
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ProfileBioSection(),
        ),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileStat(title: "Posts", count: "24"),
            ProfileStat(title: "Followers", count: "1200"),
            ProfileStat(title: "Following", count: "180"),
            ProfileStat(title: "Likes", count: "30"),
          ],
        ),
      ],
    );
  }
}
