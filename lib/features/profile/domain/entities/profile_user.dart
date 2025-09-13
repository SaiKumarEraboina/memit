import 'package:memit/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String profileImgUrl;
  final String bio;
  // late final  authCubit = context.read<Auth Cubit>();
  ProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.profileImgUrl,
  });

  // method to update  user
  ProfileUser copyWith({ String? newBio, String? newProfileImgUrl}) {
    return ProfileUser(
      uid: uid,
      email: email,
      name: name,
      bio: newBio?? bio,
      profileImgUrl: newProfileImgUrl ??profileImgUrl,
    );
  }

  // from json
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      bio: json['bio']??'',
      profileImgUrl: json['profileImgUrl']??'',
    );
  }
  // toJson
  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImgUrl': profileImgUrl,
    };
  }
}
