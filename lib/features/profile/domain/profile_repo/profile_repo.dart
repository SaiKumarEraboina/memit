import 'package:memit/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile({required String uid});
  Future<void> updateUserProfile(ProfileUser updatedProfile);
}
