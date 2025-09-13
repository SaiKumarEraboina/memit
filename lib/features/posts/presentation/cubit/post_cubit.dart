import 'dart:typed_data';
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

  Future<void> createPost(
    Post post, {
    String? imagePath,
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;
    try {
      if (imagePath != null) {
        emit(PostsUploadingState());
        imageUrl = await storageRepo.uploadPostImageMobile(
          path: imagePath,
          fileName: post.id,
        );
      } else if (imageBytes != null) {
        emit(PostsUploadingState());
        imageUrl = await storageRepo.uploadPostImageWeb(
          fileBytes: imageBytes,
          fileName: post.id,
        );
      }
      final newPost = post.copyWith(newImageUrl: imageUrl);

      await postRepo.createPost(newPost);
      print("Saving post: ${newPost.toJson()}");

      await fetchAllPosts();
    } catch (e) {
      emit(PostsErrorState(error: e.toString()));
    }
  }

  Future<void> fetchAllPosts() async {
    List<Post> allPosts;
    try {
      emit(PostsLoadingState());
      allPosts = await postRepo.fetchAllPosts();
      emit(PostsLoadedState(posts: allPosts));
    } catch (e) {
      emit(PostsErrorState(error: e.toString()));
    }
  }

  Future<void> deletePost({required String postId}) async {
    try {
      postRepo.deletePost(postId);
    } catch (e) {
      emit(PostsErrorState(error: e.toString()));
    }
  }

  Future<void> togglePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikepost(postId, userId);

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

Future<void>  deleteComment(String postId, Comment comment) async {
  try {
    await postRepo.deleteComment(postId, comment);

    await fetchAllPosts();
  } catch (e) {
    emit(PostsErrorState(error: "Failed to Delete comment: $e"));
  }
}

  
}
