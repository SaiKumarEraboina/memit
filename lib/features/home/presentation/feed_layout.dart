// import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:memit/common_widgets/responsive_center.dart';
import 'package:memit/constants/app_sizes.dart';
import 'package:memit/features/create_memes/model/post_model.dart';
import 'package:memit/features/home/data/dummy_data.dart';
import 'package:memit/features/home/domain/meme_model.dart';
import 'package:memit/features/home/presentation/meme_body.dart';
import 'package:memit/features/home/presentation/meme_caption_section.dart';
import 'package:memit/features/home/presentation/meme_header.dart';
import 'package:memit/features/home/presentation/meme_reactions.dart';
import 'package:memit/services/posts_service.dart';
import 'package:shimmer/shimmer.dart';

class FeedLayout extends StatefulWidget {
  final Category category;

  const FeedLayout({super.key, this.category = Category.all});
  @override
  State<FeedLayout> createState() => _FeedLayoutState();
}

class _FeedLayoutState extends State<FeedLayout> {
  bool isLoading = false;
  late List<MemeModel> filteredMemes;

  List<PostModel> posts = [];

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (posts.isEmpty) {
      return Center(child: Text('No Posts'));
    }

    return ListView.builder(
      itemCount: posts.length,

      itemBuilder: (context, index) {
        PostModel meme = posts[index];

        return Card(
          elevation: 5,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MemeHeader(
                  imageUrl: meme.authorProfileImage ?? '',
                  username:
                      (meme.authorName == null || meme.authorName!.isEmpty)
                          ? "Memit User"
                          : meme.authorName!,
                ),
                gapH12,
                MemeBody(postUrl: meme.postUrl ?? ''),
                ReactionBar(
                  isLiked: false,
                  likeCount: meme.likesCounts ?? 0,
                  toggleLike: () => toggleLike(index),
                  toggleSave: () => toggleSave(index),
                  isSaved: false,
                ),
                MemeCaptionSection(
                  views: 110,
                  timeAgo: getCreatedTime(meme.createdAt),
                  hashtags: [meme.tags ?? ""],
                  description: meme.description ?? "",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getPosts() async {
    setState(() {
      isLoading = true;
    });

    List<PostModel> allPosts = await PostsService.fetchAllPosts();

    setState(() {
      isLoading = false;
      posts = allPosts;
    });
  }

  String getCreatedTime(int? createdAt) {
    if (createdAt == null) return '';

    final createdDate = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    final now = DateTime.now();
    final diff = now.difference(createdDate);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} ${diff.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
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
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 20, width: 150, color: Colors.white),
              const SizedBox(height: 12),
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Container(height: 20, width: 100, color: Colors.white),
              const SizedBox(height: 12),
              Container(
                height: 14,
                width: double.infinity,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
