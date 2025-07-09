enum Category { all, memes, sports, news, entertainment, politics }

class MemeModel {
  final String username;
  final String timeAgo;
  final int views;
  final String profileUrl;
  final String postUrl;
  final String description;
  final List<String> hashtags;
  final Category category;
  final bool isLiked;
  final int likeCount;
  final bool isSaved;

  MemeModel({
    required this.username,
    required this.timeAgo,
    required this.views,
    required this.profileUrl,
    required this.postUrl,
    required this.description,
    required this.hashtags,
    required this.category,
    required this.isLiked,
    required this.isSaved,
    required this.likeCount,
  });

  factory MemeModel.fromMap(Map<String, dynamic> map) {
    return MemeModel(
      username: map['username'] ?? '',
      timeAgo: map['timeAgo'] ?? '',
      views: map['views'] ?? 0,
      profileUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      hashtags: List<String>.from(map['hashtags'] ?? []),
      postUrl: map['postUrl'] ?? '',
      isLiked: map['isLiked'] ?? false,
      isSaved: map['isSavede'] ?? false,
      likeCount: map['likeCount'] ?? 0,
      category: Category.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => Category.memes,
      ),
    );
  }

MemeModel copyWith({
  String? username,
  String? timeAgo,
  int? views,
  String? profileUrl,
  String? postUrl,
  String? description,
  List<String>? hashtags,
  Category? category,
  bool? isLiked,
  int? likeCount,
  bool? isSaved,
}) {
  return MemeModel(
    username: username ?? this.username,
    timeAgo: timeAgo ?? this.timeAgo,
    views: views ?? this.views,
    profileUrl: profileUrl ?? this.profileUrl,
    postUrl: postUrl ?? this.postUrl,
    description: description ?? this.description,
    hashtags: hashtags ?? this.hashtags,
    category: category ?? this.category,
    isLiked: isLiked ?? this.isLiked,
    isSaved: isSaved ?? this.isSaved,
    likeCount: likeCount ?? this.likeCount,
  );
}
}

class CategoryTab {
  final String label;
  final Category? category;

  CategoryTab({required this.label, required this.category});
}