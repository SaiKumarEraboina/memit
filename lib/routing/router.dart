import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memit/common_widgets/custom_bottom_navigation.dart';
import 'package:memit/constants/constants.dart';
import 'package:memit/features/auth/presentation/pages/auth_page.dart';
import 'package:memit/features/create_memes/presentation/collage_catalogue_screen.dart';
import 'package:memit/features/create_memes/presentation/create_memes_screen.dart';
import 'package:memit/features/create_memes/presentation/editor/image_editor_screen.dart';
import 'package:memit/features/create_memes/presentation/editor/video_editor_screen.dart';
import 'package:memit/features/create_memes/presentation/file_input_screen.dart';
import 'package:memit/features/create_memes/presentation/meme_data_screen.dart';
import 'package:memit/features/create_memes/presentation/pre_screen.dart';
import 'package:memit/features/create_memes/presentation/select_posts_screen.dart';
import 'package:memit/features/explore/explore_screen.dart';
import 'package:memit/features/home/presentation/home_screen.dart';
import 'package:memit/features/notifications/presentation/notifications_screen.dart';
import 'package:memit/features/posts/presentation/components/home_page.dart';
import 'package:memit/features/profile/componnents/profile_page.dart';
import 'package:memit/features/profile/domain/entities/profile_user.dart';
import 'package:memit/features/profile/edit_profile_screen.dart';
import 'package:memit/routing/app_routes.dart';
import 'package:memit/themes/lignt_mode.dart';

class AppRouter extends StatelessWidget {
  AppRouter({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: AppRoutes.memeDataScreen,
        builder: (context, state) {
          final collagePath = state.extra as String;
          return MemeDataScreen(collagePath: collagePath);
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) {
          final profileUser = state.extra as ProfileUser;
          return EditProfilePage(profileUser: profileUser);
        },
      ),
      GoRoute(
          path: AppRoutes.selectPosts,
          name: 'selectPosts',
          builder: (context, state) {
            final type = state.extra as CollageType;
            return SelectPostsScreen(type: type);
          },
          routes: [
            //Video editor screen
            GoRoute(
                path: '/videoEditor',
                name: 'videoEditor',
                builder: (context, state) {
                  final file = state.extra as File?;
                  return VideoEditorScreen(file: file);
                }),

            GoRoute(
                path: '/imageEditor',
                name: 'imageEditor',
                builder: (context, state) {
                  final file = state.extra as File?;
                  return ImageEditorScreen(file: file);
                }),

            GoRoute(
                path: '/postMeme',
                name: 'postMeme',
                builder: (context, state) {
                  final file = state.extra as File?;
                  return CreateMemesScreen(file: file!);
                })
          ]),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            CustomBottomNavigation(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.explore,
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.createMemes,
                builder: (context, state) => PreCreateMemeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.notifications,
                builder: (context, state) => const NotificationScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      routerConfig: _router,
    );
  }
}
