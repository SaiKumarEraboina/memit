import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memit/features/posts/domain/entities/comment.dart';
import 'package:memit/features/posts/domain/entities/post.dart';
import 'package:memit/features/posts/domain/repo/post_repo.dart';
import 'package:memit/features/posts/presentation/cubit/post_states.dart';
import 'package:memit/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostStates> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({required this.postRepo, required this.storageRepo})
      : super(PostsInitialState());

  List<Post> postList = [];

  int getUserPostsCount() {
    return postList
        .where((element) =>
            element.userId == FirebaseAuth.instance.currentUser?.uid)
        .toList()
        .length;
  }

  Future<void> createPost(
    Post post, {
    String? mediaPath, // image/video path (mobile)
    Uint8List? mediaBytes, // image/video bytes (web)
    String? mediaType, // "image" or "video"
  }) async {
    String? mediaUrl;
    try {
      if (mediaPath != null) {
        emit(PostsUploadingState());
        mediaUrl = await storageRepo.uploadPostMediaMobile(
          path: mediaPath,
          fileName: post.id,
          mediaType: mediaType ?? "image",
        );
      } else if (mediaBytes != null) {
        emit(PostsUploadingState());
        mediaUrl = await storageRepo.uploadPostMediaWeb(
          fileBytes: mediaBytes,
          fileName: post.id,
          mediaType: mediaType ?? "image",
        );
      }

      // Create new post with mediaUrl
      final newPost = post.copyWith(newImageUrl: mediaUrl);

      await postRepo.createPost(newPost);
      print("Saving post: ${newPost.toJson()}");

      emit(PostUploadSuccessState());
    } catch (e) {
      emit(PostsErrorState(error: e.toString()));
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoadingState());
      final allPosts = await postRepo.fetchAllPosts();
      postList = allPosts;
      emit(PostsLoadedState(posts: allPosts));
    } catch (e) {
      emit(PostsErrorState(error: e.toString()));
    }
  }

  Future<void> deletePost({required String postId}) async {
    try {
      await postRepo.deletePost(postId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsErrorState(error: e.toString()));
    }
  }

  Future<void> togglePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikepost(postId, userId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsErrorState(error: 'Failed to toggle like: $e'));
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsErrorState(error: "Failed to add comment: $e"));
    }
  }

  Future<void> deleteComment(String postId, Comment comment) async {
    try {
      await postRepo.deleteComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsErrorState(error: "Failed to delete comment: $e"));
    }
  }
}
