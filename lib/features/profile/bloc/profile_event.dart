import 'package:memit/features/profile/models/profile_model.dart';

abstract class ProfileEvent {}

class FetchProfileEvent extends ProfileEvent {}

class CreateProfileEvent extends ProfileEvent {
  late final ProfileModel profile;
}

class UpdateProfileEvent extends ProfileEvent {
  final dynamic profile;

  UpdateProfileEvent({required this.profile});
}
