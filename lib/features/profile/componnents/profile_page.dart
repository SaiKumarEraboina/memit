import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memit/features/auth/domain/entities/app_user.dart';
import 'package:memit/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:memit/features/posts/domain/entities/post.dart';
import 'package:memit/features/posts/presentation/cubit/post_cubit.dart';
import 'package:memit/features/posts/presentation/cubit/post_states.dart';
import 'package:memit/features/profile/componnents/edit_proofile_page.dart';
import 'package:memit/features/profile/cubit/profile_cubit.dart';
import 'package:memit/features/profile/cubit/profile_state.dart';
import 'package:cached_network_image/cached_network_image.dart' as cached;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  late AppUser? currentUser = authCubit.currentUser;

  @override
  void initState() {
    super.initState();
    final currentUser = authCubit.currentUser;
    if (currentUser != null) {
      profileCubit.fetchUserProfile(uid: currentUser.uid);
    }
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int postCount = context.read<PostCubit>().getUserPostsCount();

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        print('BlocBuilder state: ${state.runtimeType}'); // Debug
        if (state is ProfileLoadingState) {
          print('Showing loading indicator'); // Debug
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else
        // In _ProfilePageState's BlocBuilder
        if (state is ProfileLoadedState) {
          final user = state.profileUser;
          print(
            'ProfileSuccessState: ${user.name}, ${user.email}, ${user.profileImgUrl}, ${user.bio}',
          ); // Debug
          cached.CachedNetworkImageProvider(
            user.profileImgUrl,
          ).evict(); // Clear cache
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    authCubit.logout();
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
              centerTitle: false,
              title: Text(
                user.name,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Profile Picture
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade200,
                          child: CachedNetworkImage(
                            imageUrl: user.profileImgUrl,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 38,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(strokeWidth: 2),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      // Stats
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn(postCount.toString(), "Posts"),
                            _buildStatColumn("0", "Followers"),
                            _buildStatColumn("0", "Following"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Name and Bio
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      if (user.bio.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          user.bio,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Edit Profile Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfilePage(profileUser: user),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Divider
                Divider(height: 1, color: Colors.grey.shade300),
                // Posts Grid Placeholder

                BlocBuilder<PostCubit, PostStates>(
                    builder: (BuildContext context, PostStates state) {
                  if (state is PostsLoadedState) {
                    final List<Post> posts = state.posts
                        .where((element) =>
                            element.userId ==
                            FirebaseAuth.instance.currentUser?.uid)
                        .toList();
                    if (posts.isNotEmpty) {
                      return Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            if (posts[index].imageUrl.isEmpty &&
                                posts[index].mediaType == 'image') {
                              return Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: Icon(Icons.image_not_supported),
                                ),
                              );
                            }
                            final post = posts[index];
                            if (post.mediaType == 'image') {
                              return CachedNetworkImage(
                                imageUrl: post.imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: Icon(Icons.videocam),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No Posts Yet",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }

                  return SizedBox.shrink();
                }),
              ],
            ),
          );
        } else if (state is ProfileErrorState) {
          print('ProfileErrorState: ${state.error}'); // Debug
          return Scaffold(body: Center(child: Text('Error: ${state.error}')));
        } else {
          print('Default state: This user does not exist'); // Debug
          return Scaffold(
            body: Center(child: Text('This user does not exist')),
          );
        }
      },
    );
  }
}
