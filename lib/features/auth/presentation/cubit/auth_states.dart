import 'package:memit/features/auth/domain/entities/app_user.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthenticatedState extends AuthStates {
  final AppUser? appUser;

  AuthenticatedState ({required this.appUser});
}

class UnAuthenticatedState extends AuthStates{}

class AuthErrorState extends AuthStates {
  final String error;

  AuthErrorState({required this.error});
}
