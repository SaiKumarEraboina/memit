import 'package:memit/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<AppUser?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });
  Future<void> logOutUser();
  Future<AppUser?> getCurrentUser();
}
