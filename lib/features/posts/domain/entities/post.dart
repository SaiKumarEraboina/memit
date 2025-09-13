import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memit/features/posts/domain/entities/comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes;
  final List<Comment> comments;
  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments
  });
  Post copyWith({String? newImageUrl, String? newUserName}) {
    return Post(
      id: id,
      userId: userId,
      userName: newUserName ?? userName,
      text: text,
      imageUrl: newImageUrl ?? imageUrl,
      timestamp: timestamp,
      likes: likes,
      comments: comments
    );
  }

  // from Map to object
  factory Post.fromJson(Map<String, dynamic> postMap) {
    final List<Comment> comments = (postMap['comments'] as
     List<dynamic>?)?.map((commentJson)=>Comment.fromJson(commentJson)).toList()??[];

    return Post(
      id: postMap['id'],
      userId: postMap['userId'],
      userName: postMap['userName'],
      text: postMap['text'],
      imageUrl: postMap['imageUrl'],
      timestamp: (postMap['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(postMap['likes'] ?? []),
      comments: comments
    );
  }
  //from Object to map

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'comments': comments.map((comment)=>comment.toJson()).toList()
    };
  }
}
