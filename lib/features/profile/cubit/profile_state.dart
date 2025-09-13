import 'package:memit/features/profile/domain/entities/profile_user.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final ProfileUser profileUser;
  ProfileLoadedState({required this.profileUser});
}

class ProfileErrorState extends ProfileState {
  final String? error;
  ProfileErrorState({required this.error});
}
