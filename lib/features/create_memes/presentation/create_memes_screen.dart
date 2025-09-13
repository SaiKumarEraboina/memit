import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memit/features/auth/domain/entities/app_user.dart';
import 'package:memit/features/auth/presentation/components/custom_textfield.dart';
import 'package:memit/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:memit/features/posts/domain/entities/post.dart';
import 'package:memit/features/posts/presentation/cubit/post_cubit.dart';
import 'package:memit/features/posts/presentation/cubit/post_states.dart';
import 'package:memit/routing/app_routes.dart';
import 'package:path_provider/path_provider.dart';

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
    getCurrentUser();
    super.initState();
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
        SnackBar(content: Text('Both Image and caption are required')),
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
    // postCubit.createPost(newPost);
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
          return Scaffold(body: CircularProgressIndicator());
        }
        return buidUploadPage();
      },
      listener: (context, state) {
        if (state is PostsLoadedState) {
          // Navigator.of(context).pop();
          context.go(AppRoutes.home);

          // Scaffold(
          //   appBar: AppBar(
          //     actions: [
          //       IconButton(
          //         onPressed:
          //             () => Navigator.of(context).push(
          //               MaterialPageRoute(
          //                 builder: (context) {
          //                   return HomePage();
          //                 },
          //               ),
          //             ),
          //         icon: Icon(Icons.abc_outlined),
          //       ),
          //     ],
          //   ),
          // );
        }
      },
    );
  }

  Widget buidUploadPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Meme',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actions: [IconButton(onPressed: uploadPost, icon: Icon(Icons.upload))],
      ),
      body: Column(
        children: [
          if (kIsWeb && webImage != null) Image.memory(webImage!),
          if (!kIsWeb && imagePickedFile != null)
            Image.file(File(imagePickedFile!.path!)),

          MaterialButton(
            color: Colors.blue,
            onPressed: pickImage,
            child: Text('Pick Image'),
          ),

          CustomTextField(
            controller: captionController,
            hintText: 'caption',
            obscureText: false,
          ),
        ],
      ),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: ResponsiveScrollableCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 50),
//             child: Text(
//               'Create Meme',
//               style: TextStyle(color: Theme.of(context).colorScheme.primary),
//             ),
//           ),
//           const SizedBox(height: 16),
//           InkWell(
//             onTap: () => context.push(AppRoutes.collageCatalogue),
//             child: Container(
//               width: double.infinity,
//               height: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(width: 0.5, color: Color(0xffB4B4B4)),
//                 color: const Color(0xFFE8F3FF),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     'assets/icons/add_circle.svg',
//                     width: 40,
//                     height: 40,
//                     colorFilter: const ColorFilter.mode(
//                       Colors.black,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                   const SizedBox(height: 8), // Space between icon and text
//                   const Text('Create your meme'),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 14),
//           Text('Meme Template', style: Theme.of(context).textTheme.titleMedium),
//           const SizedBox(height: 8),
//           TextFormField(
//             decoration: InputDecoration(
//               hintText: 'Search Template',
//               contentPadding: const EdgeInsets.symmetric(
//                 vertical: 0,
//                 horizontal: 20,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30), // <- Rounded corners
//                 borderSide: const BorderSide(
//                   width: 0.5,
//                   color: Color(0xffB4B4B4),
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//                 borderSide: const BorderSide(
//                   width: 0.5,
//                   color: Color(0xffB4B4B4),
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//                 borderSide: const BorderSide(
//                   width: 0.5,
//                   color: Color(0xffB4B4B4),
//                 ),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 14),

//           const SizedBox(height: 24),
//           Text(
//             'Create with Latest Templates',
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           const SizedBox(height: 12),
//           Column(
//             children: [
//               Row(
//                 children: const [
//                   Expanded(
//                     child: Template(
//                       image: 'fire',
//                       templateTitle: 'Trending',
//                       templateDescription: 'Use Trending meme template',
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Template(
//                       image: 'movie',
//                       templateTitle: 'Movie',
//                       templateDescription: 'Meme templates from movies',
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12),
//               Row(
//                 children: const [
//                   Expanded(
//                     child: Template(
//                       image: 'smiley',
//                       templateTitle: 'Funny',
//                       templateDescription: 'Light-hearted and fun memes',
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Template(
//                       image: 'game',
//                       templateTitle: 'Gaming',
//                       templateDescription: 'Gaming-related memes',
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
