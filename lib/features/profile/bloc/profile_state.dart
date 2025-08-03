import 'package:memit/features/profile/models/profile_model.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileErrorState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final ProfileModel profile;

  ProfileLoadedState({required this.profile});
}

class ProfileUpdateInProgressState extends ProfileState {}

class ProfileUpdateSuccessState extends ProfileState {}

class ProfileUpdateErrorState extends ProfileState {}
