import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memit/common_widgets/responsive_center.dart';
import 'package:memit/constants/breakpoints.dart';
import 'package:memit/features/home/presentation/custom_tab_bar.dart';
import 'package:memit/features/home/presentation/home_app_bar.dart';
import 'package:memit/features/profile/bloc/profile_bloc.dart';
import 'package:memit/features/profile/bloc/profile_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //  final _scrollController = ScrollController();

  @override
  void initState() {
    context.read<ProfileBloc>().add(FetchProfileEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: HomeAppBar(),
      body: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        child: CustomTabBar(),
      ),
    );
  }
}
