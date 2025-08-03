class ProfileModel {
  final String? username;
  final String? name;
  final String? bio;
  final String? profileImageUrl;
  final int? followers;
  final int? following;
  final int? posts;
  final bool? isVerified;
  final String? coverImageUrl;
  final String? id;

  ProfileModel({
    this.username,
    this.name,
    this.bio,
    this.profileImageUrl,
    this.followers,
    this.following,
    this.posts,
    this.isVerified,
    this.coverImageUrl,
    this.id,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      username: json['username'],
      name: json['name'],
      bio: json['bio'] ,
      profileImageUrl: json['profileImageUrl'],
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      posts: json['posts'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      coverImageUrl: json['coverImageUrl'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
      'posts': posts,
      'isVerified': isVerified,
      'coverImageUrl': coverImageUrl,
      'id': id,
    };
  }

  ProfileModel copyWith({
    String? username,
    String? name,
    String? bio,
    String? profileImageUrl,
    int? followers,
    int? following,
    int? posts,
    bool? isVerified,
    String? coverImageUrl,
  }) {
    return ProfileModel(
      username: username ?? this.username,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
      isVerified: isVerified ?? this.isVerified,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
    );
  }
}
