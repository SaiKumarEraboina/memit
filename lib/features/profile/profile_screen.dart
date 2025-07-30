import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memit/common_widgets/responsive_scrollable_card.dart';
import 'package:memit/features/profile/posts_grid.dart';
import 'package:memit/features/profile/profile_header.dart';
import 'package:memit/features/profile/tabbar_section.dart';
import 'package:memit/routing/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Shiva@1214',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),
            IconButton(onPressed: () {}, icon: Icon(Icons.currency_rupee)),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.check_circle_outline_outlined),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
            IconButton(
              onPressed: () {
                confirmLogout(context);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: ResponsiveScrollableCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ProfileHeaderSection(),
              TabBarSection(),
              SizedBox(height: 20),
              SizedBox(
                height: 500, // 👈 Add a fixed height
                child: PostsGridSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(), // Close the dialog
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                  FirebaseAuth.instance.signOut();
                  context.go(AppRoutes.auth);
                  // Perform logout logic here
                  // FirebaseAuth.instance.signOut();
                },
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }
}
