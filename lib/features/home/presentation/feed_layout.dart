// import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:memit/common_widgets/responsive_center.dart';
import 'package:memit/constants/app_sizes.dart';
import 'package:memit/features/home/data/dummy_data.dart';
import 'package:memit/features/home/domain/meme_model.dart';
import 'package:memit/features/home/presentation/meme_body.dart';
import 'package:memit/features/home/presentation/meme_caption_section.dart';
import 'package:memit/features/home/presentation/meme_header.dart';
import 'package:memit/features/home/presentation/meme_reactions.dart';
import 'package:shimmer/shimmer.dart';

class FeedLayout extends StatefulWidget {
  final Category category;

  const FeedLayout({super.key, this.category = Category.all});
  @override
  State<FeedLayout> createState() => _FeedLayoutState();
}

class _FeedLayoutState extends State<FeedLayout> {
  bool isLoading = true;
  late List<MemeModel> filteredMemes;

    void toggleLike(int index) {
    setState(() {
      final meme = filteredMemes[index];
      filteredMemes[index] = meme.copyWith(
        isLiked: !meme.isLiked,
        likeCount: meme.isLiked ? meme.likeCount - 1 : meme.likeCount + 1,
      );
    });
  }

  void toggleSave(int index) {
    setState(() {
      final meme = filteredMemes[index];
      filteredMemes[index] = meme.copyWith(isSaved: !meme.isSaved);
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        filteredMemes = widget.category == Category.all
            ? memeList
            : memeList.where((meme) => meme.category == widget.category).toList();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => const MemeShimmer(),
      );
    } else if (filteredMemes.isEmpty) {
      content = Center(
        child: Text(
          'Uh oh... nothing here!',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: filteredMemes.length,
        itemBuilder: (context, index) {
          final meme = filteredMemes[index];
          return Card(
            elevation: 5,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MemeHeader(imageUrl: meme.postUrl, username: meme.username),
                  gapH12,
                  MemeBody(postUrl: meme.postUrl),
                  ReactionBar(
                    isLiked: meme.isLiked,
                    likeCount: meme.likeCount,
                    toggleLike: () => toggleLike(index),
                    toggleSave: () => toggleSave(index),
                    isSaved: meme.isSaved,
                  ),
                  MemeCaptionSection(
                    views: meme.views,
                    timeAgo: 20,
                    hashtags: meme.hashtags,
                    description: meme.description,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return ResponsiveCenter(child: content);
  }
}



class MemeShimmer extends StatelessWidget {
  const MemeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        margin: const EdgeInsets.all(14.0),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min ,

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 20, width: 150, color: Colors.white),
              const SizedBox(height: 12),
              Container(height: 200, width: double.infinity, color: Colors.white),
              const SizedBox(height: 12),
              Container(height: 20, width: 100, color: Colors.white),
              const SizedBox(height: 12),
              Container(height: 14, width: double.infinity, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
} 