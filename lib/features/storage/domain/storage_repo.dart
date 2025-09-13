import 'dart:typed_data';

abstract class StorageRepo {
  Future<String?> uploadProfileImageMobile({
    required String path,
    required String fileName,
  });
  Future<String?> uploadProfileImageWeb({
    required Uint8List path,
    required String fileName,
  });

  Future<String?> uploadPostImageMobile({
    required String path,
    required String fileName,
  });

  Future<String?> uploadPostImageWeb({
    required Uint8List  fileBytes,
    required String fileName,
  });
  
}
