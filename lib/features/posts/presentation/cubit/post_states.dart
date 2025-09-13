import 'package:memit/features/posts/domain/entities/post.dart';

abstract class PostStates {}

class PostsLoadingState extends PostStates {}

class PostsUploadingState extends PostStates {}

class PostsInitialState extends PostStates {}

class PostsLoadedState extends PostStates {
  final List<Post> posts;
  PostsLoadedState({required this.posts});
}

class PostsErrorState extends PostStates {
  final String error;
  PostsErrorState({required this.error});
}
