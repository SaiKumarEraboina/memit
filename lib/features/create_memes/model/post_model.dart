class PostModel {
  final String? id;
  final String? description;
  final String? tags;
  final String? authorId;
  final String? authorName;
  final String? postUrl;
  final int? createdAt;
  final int? commentsCounts;
  final int? likesCounts;
  final String? authorProfileImage;

  PostModel({
    required this.id,
    required this.description,
    required this.tags,
    required this.authorId,
    required this.authorName,
    required this.postUrl,
    required this.createdAt,
    required this.commentsCounts,
    required this.likesCounts,
    required this.authorProfileImage,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String?,
      description: json['description'] as String?,
      tags: json['tags'] as String?,
      authorId: json['authorId'] as String?,
      authorName: json['authorName'] as String?,
      postUrl: json['postUrl'] as String?,
      createdAt: json['createdAt'] as int?,
      commentsCounts: json['commentsCounts'] as int?,
      likesCounts: json['likesCounts'] as int?,
      authorProfileImage: json['authorProfileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'tags': tags,
      'authorId': authorId,
      'authorName': authorName,
      'postUrl': postUrl,
      'createdAt': createdAt,
      'commentsCounts': commentsCounts,
      'likesCounts': likesCounts,
      'authorProfileImage': authorProfileImage,
    };
  }
}
