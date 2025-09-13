import 'package:memit/features/posts/domain/entities/comment.dart';
import 'package:memit/features/posts/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();
  Future<List<Post>> fetchPostsByUser(String userId);
  Future<void> createPost(Post post);
  Future<void> deletePost(String postId);
  Future<void> toggleLikepost(String postId, String userId);
  Future<void> addComment(String postId, Comment comment);
  Future<void> deleteComment(String postId, Comment comment);
}
