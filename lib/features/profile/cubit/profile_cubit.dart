import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memit/features/profile/cubit/profile_state.dart';
import 'package:memit/features/profile/domain/entities/profile_user.dart';
import 'package:memit/features/profile/domain/profile_repo/profile_repo.dart';
import 'package:memit/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.profileRepo, required this.storageRepo})
    : super(ProfileInitialState());
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  Future<void> fetchUserProfile({required String uid}) async {
    try {
      emit(ProfileLoadingState());
      final user = await profileRepo.fetchUserProfile(uid: uid);
      if (user != null) {
        emit(ProfileLoadedState(profileUser: user));
      } else {
        emit(ProfileErrorState(error: 'User not fount'));
      }
    } catch (e) {
      emit(ProfileErrorState(error: e.toString()));
    }
  }

  Future<void> updateProfileUser({
    required String uid,
    String? newBio,
    String? imageMobilePath,
    Uint8List? imageWebBytes,
  }) async {
    emit(ProfileLoadingState());
    print(
      'Starting updateProfileUser for UID: $uid, newBio: $newBio, imageMobilePath: $imageMobilePath, imageWebBytes: ${imageWebBytes != null}',
    ); // Debug
    try {
      final currentUser = await profileRepo.fetchUserProfile(uid: uid);
      if (currentUser == null) {
        print('Failed to fetch user for UID: $uid'); // Debug
        emit(
          ProfileErrorState(error: 'Failed to fetch user for profile update'),
        );
        return;
      }
      print(
        'Current user fetched: ${currentUser.name}, ${currentUser.profileImgUrl}, ${currentUser.bio}',
      ); // Debug

      String? imageDownloadUrl = currentUser.profileImgUrl;
      if (imageMobilePath != null || imageWebBytes != null) {
        if (imageMobilePath != null) {
          print('Uploading mobile image: $imageMobilePath'); // Debug
          imageDownloadUrl = await storageRepo.uploadProfileImageMobile(
            path: imageMobilePath,
            fileName: uid,
          );
        } else if (imageWebBytes != null) {
          print('Uploading web image for UID: $uid'); // Debug
          imageDownloadUrl = await storageRepo.uploadProfileImageWeb(
            path: imageWebBytes,
            fileName: uid,
          );
        }
        print('Image uploaded, download URL: $imageDownloadUrl'); // Debug
      }

      final updatedUser = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImgUrl: imageDownloadUrl ?? currentUser.profileImgUrl,
      );
      print(
        'Updating user profile: ${updatedUser.name}, ${updatedUser.bio}, ${updatedUser.profileImgUrl}',
      ); // Debug
      await profileRepo.updateUserProfile(updatedUser);

      print('Fetching updated user for UID: $uid'); // Debug
      final refreshedUser = await profileRepo.fetchUserProfile(uid: uid);
      if (refreshedUser != null) {
        print(
          'Updated user fetched: ${refreshedUser.name}, ${refreshedUser.bio}, ${refreshedUser.profileImgUrl}',
        ); // Debug
        emit(
          ProfileLoadedState(profileUser: refreshedUser),
        ); // Use ProfileSuccessState
      } else {
        print('Failed to fetch updated user for UID: $uid'); // Debug
        emit(ProfileErrorState(error: 'Failed to fetch updated user profile'));
      }
    } catch (e) {
      print('Error in updateProfileUser: $e'); // Debug
      emit(ProfileErrorState(error: e.toString()));
    }
  }

  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid: uid);
    return user;
  }
}

//   Future<void> updateProfileUser({
//     required String uid,
//     String? newBio,
//     String? imgProfileMobilePath,
//     Uint8List? imgProfileWebBytes, String? imageMobilePath, Uint8List? imageWebBytes,
//   }) async {
//     emit(ProfileLoadingState());
//     try {
//       final currentUser = await profileRepo.fetchUserProfile(uid: uid);
//       String? profileImageUrl;
//       if (currentUser == null) {
//         emit(
//           ProfileErrorState(error: 'Failed to fetch user for profile update'),
//         );
//         return;
//       }
//       if (imgProfileMobilePath != null || imgProfileWebBytes != null) {
//         if (imgProfileMobilePath != null) {
//           profileImageUrl = await storageRepo.uploadProfileImageMobile(
//             path: imgProfileMobilePath,
//             fileName: uid,
//           );
//         } else if (imgProfileWebBytes != null) {
//           profileImageUrl = await storageRepo.uploadProfileImageWeb(
//             path: imgProfileWebBytes,
//             fileName: uid,
//           );
//         }
//       } else {
//         emit(ProfileErrorState(error: 'Failed to upload image'));
//         return;
//       }
//       final updatedUser = currentUser.copyWith(
//         newBio: newBio ?? currentUser.bio,
//         newProfileImgUrl: profileImageUrl ?? currentUser.profileImgUrl,
//       );
//       await profileRepo.updateUserProfile(updatedUser);

//       await fetchUserProfile(uid: uid);
//     } catch (e) {
//       emit(ProfileErrorState(error: e.toString()));
//     }
//   }
// }
