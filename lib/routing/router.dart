import 'package:go_router/go_router.dart';
import 'package:memit/common_widgets/custom_bottom_navigation.dart';
import 'package:memit/features/create_memes/presentation/create_memes_screen.dart';
import 'package:memit/features/explore/explore_screen.dart';
import 'package:memit/features/home/presentation/home_screen.dart';
import 'package:memit/features/notifications/presentation/notifications_screen.dart';
import 'package:memit/features/profile/profile_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => CustomBottomNavigation(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: "/", builder: (context, state) => HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/explore",
              builder: (context, state) => ExploreScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/create-memes",
              builder: (context, state) => CreateMemesScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/notifications",
              builder: (context, state) => NotificationScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/profile",
              builder: (context, state) => ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
