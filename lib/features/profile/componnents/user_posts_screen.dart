import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memit/features/posts/domain/entities/post.dart';
import 'package:memit/features/posts/presentation/components/post_tile.dart';
import 'package:memit/features/posts/presentation/cubit/post_cubit.dart';
import 'package:memit/features/posts/presentation/cubit/post_states.dart';

class UserPostsScreen extends StatelessWidget {
  final String userId;
  final String userName;
  final int initialIndex;

  const UserPostsScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        centerTitle: false,
      ),
      body: BlocBuilder<PostCubit, PostStates>(
        builder: (context, state) {
          if (state is PostsLoadedState) {
            final userPosts =
                state.posts.where((post) => post.userId == userId).toList();

            if (userPosts.isEmpty) {
              return Center(
                child: Text(
                  'No posts yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                return PostTile(
                  post: userPosts[index],
                  onDelete: () {},
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
