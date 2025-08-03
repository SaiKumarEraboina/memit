import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memit/common_widgets/responsive_scrollable_card.dart';
import 'package:memit/features/profile/bloc/profile_bloc.dart';
import 'package:memit/features/profile/bloc/profile_state.dart';
import 'package:memit/features/profile/models/profile_model.dart';
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
      child: BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen:
            (previous, current) =>
                current is ProfileLoadingState ||
                current is ProfileLoadedState ||
                current is ProfileErrorState,
        builder: (context, state) {
          if (state is ProfileErrorState) {
            return Center(child: Text('Something went wrong'));
          }

          if (state is ProfileLoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          late ProfileModel profile;

          if (state is ProfileLoadedState) {
            profile = state.profile;
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'memit User',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
                    context.push(AppRoutes.editProfile);
                  },
                  icon: Icon(Icons.edit),
                ),
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
                children:  [
                  ProfileHeaderSection(profile: profile),
                  TabBarSection(),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 500, // 👈 Add a fixed height
                    child: PostsGridSection(),
                  ),
                ],
              ),
            ),
          );
        },
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
