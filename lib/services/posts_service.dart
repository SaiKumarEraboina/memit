import 'dart:io';
import 'package:memit/features/create_memes/model/post_model.dart';
import 'package:path/path.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memit/constants/firebase_collections.dart';

class PostsService {
  static Future<String?> uploadFile(File file, {String? customPath}) async {
    try {
      final fileName = basename(file.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueFileName = '${timestamp}_$fileName';

      final storageRef = FirebaseStorage.instance
          .ref()
          .child(customPath?? FirebaseCollections.memes)
          .child(uniqueFileName);

      final taskSnapshot = await storageRef
          .putFile(file)
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Upload timed out');
            },
          );
      print('Uploaded successfully');

      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('File upload error: $e');
      return null;
    }
  }

  static getUniqueId() {
    return FirebaseFirestore.instance.collection('sample').doc().id;
  }

  static Future<void> createPost({required Map<String, dynamic> data}) async {
    String postId = getUniqueId();

    data['postId'] = postId;

    await FirebaseFirestore.instance
        .collection(FirebaseCollections.posts)
        .doc(postId)
        .set(data);
  }

  static Future<void> deletePost(String postId) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.posts)
        .doc(postId)
        .delete();
  }

  static addComment({
    required String postId,
    required Map<String, dynamic> data,
  }) async {
    String commentId = getUniqueId();

    await FirebaseFirestore.instance
        .collection(FirebaseCollections.comments)
        .doc(commentId)
        .set(data);
  }

  static deleteComment({required String commentId}) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.comments)
        .doc(commentId)
        .delete();
  }

  static toggleLike(String postId) {}

  static Future<List<PostModel>> getMyPosts() async {
    return await fetchPostsByUser(FirebaseAuth.instance.currentUser!.uid);
  }

  static Future<List<PostModel>> fetchPostsByUser(String userId) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection(
                FirebaseCollections.posts,
              ) // or use FirebaseCollections.posts if it's defined
              .where('authorId', isEqualTo: userId)
              .orderBy('createdAt', descending: true) // optional sorting
              .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching user posts: $e');
      return [];
    }
  }

  static Future<List<PostModel>> fetchAllPosts() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection(FirebaseCollections.posts)
              .orderBy('createdAt', descending: true)
              .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching all posts: $e');
      return [];
    }
  }
}
