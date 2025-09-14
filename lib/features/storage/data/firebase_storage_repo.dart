import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:memit/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final firebaseStorageRepo = FirebaseStorage.instance;

  // ------------------ PROFILE UPLOAD ------------------
  @override
  Future<String?> uploadProfileImageMobile({
    required String path,
    required String fileName,
  }) {
    return _uploadFile(path, fileName, 'profile_images');
  }

  @override
  Future<String?> uploadProfileImageWeb({
    required Uint8List fileBytes,
    required String fileName,
  }) {
    return _uploadFileBytes(fileBytes, fileName, 'profile_images');
  }

  // ------------------ POST MEDIA UPLOAD ------------------
  @override
  Future<String?> uploadPostMediaMobile({
    required String path,
    required String fileName,
    required String mediaType, // "image" or "video"
  }) {
    final folder =
        mediaType == "video" ? "post_videos" : "post_images"; // choose folder
    return _uploadFile(path, fileName, folder);
  }

  @override
  Future<String?> uploadPostMediaWeb({
    required Uint8List fileBytes,
    required String fileName,
    required String mediaType, // "image" or "video"
  }) {
    final folder =
        mediaType == "video" ? "post_videos" : "post_images"; // choose folder
    return _uploadFileBytes(fileBytes, fileName, folder);
  }

  // ------------------ HELPERS ------------------
  Future<String?> _uploadFile(
    String path,
    String fileName,
    String folder,
  ) async {
    try {
      final file = File(path);
      final storageRef = firebaseStorageRepo
          .ref()
          .child('$folder/$fileName/${file.path.split('/').last}');
      final uploadTask = await storageRef.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<String?> _uploadFileBytes(
    Uint8List fileBytes,
    String fileName,
    String folder,
  ) async {
    try {
      final storageRef = firebaseStorageRepo.ref().child('$folder/$fileName');
      final uploadTask = await storageRef.putData(fileBytes);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}
