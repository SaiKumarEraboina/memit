import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memit/routing/app_routes.dart';
import 'package:memit/services/posts_service.dart';

class MemeDataScreen extends StatefulWidget {
  final String? imagePath;
  const MemeDataScreen({super.key, this.imagePath});

  @override
  State<MemeDataScreen> createState() => _MemeDataScreenState();
}

class _MemeDataScreenState extends State<MemeDataScreen> {
  TextEditingController description = TextEditingController();

  TextEditingController tags = TextEditingController();

  bool isPosting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          isPosting
              ? CircularProgressIndicator(color: Colors.white)
              : TextButton(
                onPressed: () {
                  if (widget.imagePath != null) {
                    postMeme();
                  }
                },
                child: Row(
                  spacing: 8,
                  children: [
                    Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.send, color: Colors.white),
                  ],
                ),
              ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 20,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Image.file(File(widget.imagePath!)),
            ),

            TextFormField(
              controller: description,
              decoration: InputDecoration(
                hintText: 'Add your description here...',
              ),
            ),

            TextFormField(
              controller: tags,
              decoration: InputDecoration(hintText: 'tags'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> postMeme() async {
    setState(() {
      isPosting = true;
    });

    String? postUrl = await PostsService.uploadFile(File(widget.imagePath!));

    String caption = description.text;
    String tagsList = tags.text;
    String authorId = FirebaseAuth.instance.currentUser!.uid;
    String authorName = FirebaseAuth.instance.currentUser!.displayName ?? '';

    var data = {
      'description': caption,
      'tags': tagsList,
      'commentsCount': 0,
      'likesCounts': 0,
      'authorId': authorId,
      'authorName': authorName,
      'postUrl': postUrl,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };

    await PostsService.createPost(data: data);

    setState(() {
      isPosting = false;
    });

    context.go(AppRoutes.home);
  }
}
