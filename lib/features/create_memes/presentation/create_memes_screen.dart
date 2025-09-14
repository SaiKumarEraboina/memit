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
import 'package:memit/routing/app_routes.dart';

class CreateMemesScreen extends StatefulWidget {
  const CreateMemesScreen({super.key});

  @override
  State<CreateMemesScreen> createState() => _CreateMemesScreenState();
}

class _CreateMemesScreenState extends State<CreateMemesScreen> {
  TextEditingController captionController = TextEditingController();
  PlatformFile? imagePickedFile;
  Uint8List? webImage;
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final collageType =
          GoRouterState.of(context).extra as String? ?? "single";
      if (collageType != "single") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$collageType collage coming soon!')),
        );
        Navigator.of(context).pop();
      }
    });
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  void uploadPost() {
    if (imagePickedFile == null || captionController.text.isEmpty) {
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
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );
    final postCubit = context.read<PostCubit>();
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    } else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
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
        if (state is PostsLoadingState || state is PostsUploadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return buildInstagramStyleUploadPage();
      },
      listener: (context, state) {
        if (state is PostsLoadedState) {
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'New Post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: uploadPost,
            child: const Text(
              'Share',
              style: TextStyle(
                color: Color(0xFF0095F6),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
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
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: imagePickedFile == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo,
                                size: 48, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(
                              'Add Photo',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: kIsWeb && webImage != null
                            ? Image.memory(webImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 320)
                            : Image.file(File(imagePickedFile!.path!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 320),
                      ),
              ),
            ),
            const SizedBox(height: 18),
            // Caption field
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
            Offstage(
              offstage: true,
              child: MaterialButton(
                color: Colors.blue,
                onPressed: pickImage,
                child: const Text('Pick Image'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
