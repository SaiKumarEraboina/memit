import 'dart:typed_data';

abstract class StorageRepo {
  // Profile image upload (still only images)
  Future<String?> uploadProfileImageMobile({
    required String path,
    required String fileName,
  });

  Future<String?> uploadProfileImageWeb({
    required Uint8List fileBytes,
    required String fileName,
  });

  Future<String?> uploadPostMediaMobile({
    required String path,
    required String fileName,
    required String mediaType,
  });

  Future<String?> uploadPostMediaWeb({
    required Uint8List fileBytes,
    required String fileName,
    required String mediaType,
  });
}
