import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          shell,
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    border: Border.all(color:const Color(0x42676666).withValues(alpha: 0.5),width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    currentIndex: shell.currentIndex,
                    onTap: shell.goBranch,
                    selectedItemColor: Colors.black,
                    unselectedItemColor: Colors.black87,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        activeIcon: Icon(Icons.home),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.explore_outlined),
                        activeIcon: Icon(Icons.explore),
                        label: "Explore",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_box_outlined),
                        activeIcon: Icon(Icons.add_box),
                        label: "Create Memes",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.notifications_none),
                        activeIcon: Icon(Icons.notifications),
                        label: "Notifications",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline),
                        activeIcon: Icon(Icons.person),
                        label: "Profile",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
