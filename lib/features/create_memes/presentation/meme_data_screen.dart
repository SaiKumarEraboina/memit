import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memit/routing/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:memit/services/posts_service.dart';

class MemeDataScreen extends StatefulWidget {
  /// Path to the generated collage image file
  final String collagePath;

  const MemeDataScreen({
    super.key,
    required this.collagePath,
  });

  @override
  State<MemeDataScreen> createState() => _MemeDataScreenState();
}

class _MemeDataScreenState extends State<MemeDataScreen> {
  final TextEditingController description = TextEditingController();
  final TextEditingController tags = TextEditingController();
  bool isPosting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meme Preview"),
        // actions: [
        //   isPosting
        //       ? const Padding(
        //           padding: EdgeInsets.all(12.0),
        //           child: CircularProgressIndicator(color: Colors.white),
        //         )
        //       : TextButton(
        //           onPressed: () {
        //             if (widget.collagePath.isNotEmpty) {
        //               postMeme();
        //             }
        //           },
        //           child: const Row(
        //             spacing: 8,
        //             children: [
        //               Text(
        //                 'Post',
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               Icon(Icons.send, color: Colors.white),
        //             ],
        //           ),
        //         ),
        // ],

),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 20,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Image.file(File(widget.collagePath)),
            ),
            TextFormField(
              controller: description,
              decoration: const InputDecoration(
                hintText: 'Add your description here...',
              ),
            ),
            TextFormField(
              controller: tags,
              decoration: const InputDecoration(
                hintText: 'tags',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> postMeme() async {
  //   setState(() {
  //     isPosting = true;
  //   });

  //   try {
  //     // Upload the generated collage
  //     String? postUrl = await PostsService.uploadFile(File(widget.collagePath));

  //     String caption = description.text;
  //     String tagsList = tags.text;
  //     String authorId = FirebaseAuth.instance.currentUser!.uid;
  //     String authorName = context.read<ProfileBloc>().profile?.name ?? "";

  //     var data = {
  //       'description': caption,
  //       'tags': tagsList,
  //       'commentsCount': 0,
  //       'likesCounts': 0,
  //       'authorId': authorId,
  //       'authorName': authorName,
  //       'postUrl': postUrl,
  //       'authorProfileImage':
  //           context.read<ProfileBloc>().profile?.profileImageUrl,
  //       'createdAt': DateTime.now().millisecondsSinceEpoch,
  //     };

  //     await PostsService.createPost(data: data);

  //     context.go(AppRoutes.home);
  //   } finally {
  //     setState(() {
  //       isPosting = false;
  //     });
  //   }
  // }


}
