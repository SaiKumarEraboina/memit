import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:memit/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final firebaseStorageRepo = FirebaseStorage.instance;
  @override
  Future<String?> uploadProfileImageMobile({
    required String path,
    required String fileName,
  }) {
    return _uploadFile(path, fileName, 'profile_images');
  }

  @override
  Future<String?> uploadProfileImageWeb({
    required Uint8List path,
    required String fileName,
  }) {
    return _uploadFileBytes(path, fileName, 'profile_images');
  }

  Future<String?> _uploadFile(
    String path,
    String fileName,
    String folder,
  ) async {
    try {
      //get file
      final file = File(path);
      //find storage to uplad file
      final storageRef = firebaseStorageRepo.ref().child('$folder/$fileName');
      //upload file
      final uploadTask = await storageRef.putFile(file);
      //download it
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
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
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> uploadPostImageMobile({
    required String path,
    required String fileName,
  }) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb({
    required Uint8List fileBytes,
    required String fileName,
  }) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }
}
