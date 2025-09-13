import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memit/features/profile/domain/entities/profile_user.dart';
import 'package:memit/features/profile/domain/profile_repo/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<ProfileUser?> fetchUserProfile({required String uid}) async {
    try {
      final userDoc = await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImgUrl: userData['profileImgUrl'].toString(),
          );
        }
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }

  @override
  Future<void> updateUserProfile(ProfileUser updatedUser) async {
    try {
      await firebaseFirestore.collection('users').doc(updatedUser.uid).update({
        'bio': updatedUser.bio,
        'profileImgUrl': updatedUser.profileImgUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
