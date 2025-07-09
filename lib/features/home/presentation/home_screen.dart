import 'package:flutter/material.dart';
import 'package:memit/common_widgets/responsive_center.dart';
import 'package:memit/constants/breakpoints.dart';
import 'package:memit/features/home/presentation/custom_tab_bar.dart';
import 'package:memit/features/home/presentation/home_app_bar.dart';

class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});
  //  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: HomeAppBar(),
      body:  ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        child:CustomTabBar(
        )),
    );
  }
}

