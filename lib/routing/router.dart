import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:memit/common_widgets/custom_bottom_navigation.dart';
import 'package:memit/features/auth/authentication_screen.dart';
import 'package:memit/features/create_memes/presentation/collage_catalogue_screen.dart';
import 'package:memit/features/create_memes/presentation/create_memes_screen.dart';
import 'package:memit/features/explore/explore_screen.dart';
import 'package:memit/features/home/presentation/home_screen.dart';
import 'package:memit/features/notifications/presentation/notifications_screen.dart';
import 'package:memit/features/profile/profile_screen.dart';
import 'package:memit/routing/app_routes.dart';

final goRouter = GoRouter(
  initialLocation: AppRoutes.home,
  redirect: (context, state) {
    if (FirebaseAuth.instance.currentUser != null) {
      //case user logged in
      return null;
    } else {
      return AppRoutes.auth;
    }
  },
  routes: [
    /// ✅ Standalone screen outside bottom navigation shell
    GoRoute(
      path: AppRoutes.collageCatalogue,
      builder: (context, state) => const CollageCatalogueScreen(),
    ),

    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => AuthenticationScreen(),
    ),

    /// ✅ Standalone screen outside bottom navigation shell
    GoRoute(
      path: AppRoutes.collageCatalogue,
      builder: (context, state) => const CollageCatalogueScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => CustomBottomNavigation(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
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
              builder: (context, state) => const CreateMemesScreen(),
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
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
