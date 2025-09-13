import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memit/features/auth/domain/entities/app_user.dart';
import 'package:memit/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:memit/features/posts/presentation/components/post_tile.dart';
import 'package:memit/features/posts/presentation/cubit/post_cubit.dart';
import 'package:memit/features/posts/presentation/cubit/post_states.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final postCubit = context.read<PostCubit>();
  late final authCubit = context.read<AuthCubit>();
  late final AppUser? currentUser = authCubit.currentUser;

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId: postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: BlocBuilder<PostCubit, PostStates>(
        builder: (context, state) {
          if (state is PostsUploadingState || state is PostsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostsLoadedState) {
            final allPosts = state.posts;
            if (allPosts.isEmpty) {
              return const Center(child: Text('No posts available'));
            }
            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                final post = allPosts[index];

                final imageUrl = post.imageUrl;
                final postId = post.id;

                if (imageUrl.isNotEmpty) {
                  return PostTile(
                    post: post,
                    onDelete: () => deletePost(postId),
                  );
                } else {
                  return const SizedBox(
                    height: 430,
                    child: Icon(Icons.image_not_supported),
                  );
                }
              },
            );
          } else if (state is PostsErrorState) {
            return Center(child: Text(state.error));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
