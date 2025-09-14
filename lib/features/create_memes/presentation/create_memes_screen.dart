import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memit/features/auth/domain/entities/app_user.dart';
import 'package:memit/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:memit/features/posts/domain/entities/post.dart';
import 'package:memit/features/posts/presentation/cubit/post_cubit.dart';
import 'package:memit/features/posts/presentation/cubit/post_states.dart';
import 'package:memit/features/profile/cubit/profile_cubit.dart';
import 'package:memit/features/profile/cubit/profile_state.dart';
import 'package:memit/global/helpers.dart';
import 'package:memit/routing/app_routes.dart';
import 'package:video_player/video_player.dart';

class CreateMemesScreen extends StatefulWidget {
  final File file;
  const CreateMemesScreen({super.key, required this.file});

  @override
  State<CreateMemesScreen> createState() => _CreateMemesScreenState();
}

class _CreateMemesScreenState extends State<CreateMemesScreen> {
  TextEditingController captionController = TextEditingController();
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  Future<void> uploadPost() async {
    if (captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both Image and caption are required')),
      );
      return;
    }
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: captionController.text,
      imageUrl: '',
      mediaType: isVideoFile(widget.file) ? 'video' : 'image',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );
    final postCubit = context.read<PostCubit>();

    await postCubit.createPost(newPost,
        mediaPath: widget.file.path,
        mediaType: isVideoFile(widget.file) ? "video" : "image");

    context.pop();
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      builder: (context, state) {
        return buildInstagramStyleUploadPage();
      },
      listener: (context, state) {
        if (state is PostUploadSuccessState) {
          context.go(AppRoutes.home);
        }
      },
    );
  }

  Widget buildInstagramStyleUploadPage() {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: context.pop),
          title: const Text(
            'New Post',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            BlocBuilder<PostCubit, PostStates>(
              builder: (context, state) {
                if (state is PostsUploadingState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  );
                }
                return TextButton(
                  onPressed: uploadPost,
                  child: const Text(
                    'Share',
                    style: TextStyle(
                      color: Color(0xFF0095F6),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            children: [
              // User avatar and name
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: currentUser?.name != null
                        ? NetworkImage(currentUser!.name)
                        : null,
                    child: currentUser?.name == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    currentUser?.name ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Image preview with overlay

              buildMediaPreview(),
              const SizedBox(height: 18),
              // Caption field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextField(
                  controller: captionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write a caption...',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Pick image button (hidden, but keep for accessibility)
            ],
          ),
        ));
  }

  Widget buildMediaPreview() {
    bool isVideo = isVideoFile(widget.file);
    if (isVideo) {
      return _VideoPreviewWidget(file: widget.file);
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          widget.file,
          fit: BoxFit.contain,
          width: double.infinity,
          height: 320,
        ),
      );
    }
  }
}

// Helper widget for video preview
class _VideoPreviewWidget extends StatefulWidget {
  final File file;
  const _VideoPreviewWidget({required this.file});

  @override
  State<_VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<_VideoPreviewWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const SizedBox(
        height: 320,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
          child: Icon(
            _controller.value.isPlaying
                ? Icons.pause_circle_filled
                : Icons.play_circle_filled,
            color: Colors.white.withOpacity(0.7),
            size: 64,
          ),
        ),
      ],
    );
  }
}
