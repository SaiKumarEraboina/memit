import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memit/features/profile/bloc/profile_event.dart';
import 'package:memit/features/profile/bloc/profile_state.dart';
import 'package:memit/features/profile/models/profile_model.dart';
import 'package:memit/services/profile_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitialState()) {
    on<FetchProfileEvent>(fetchProfileHandler);
    on<UpdateProfileEvent>(updateProfileHandler);
  }

  ProfileModel? profile;

  Future<void> fetchProfileHandler(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());

    ProfileModel? profile = await ProfileService.getProfile();

    if (profile == null) {
      emit(ProfileErrorState());
    } else {
      this.profile = profile;
      emit(ProfileLoadedState(profile: profile));
    }
  }

  Future<void> updateProfileHandler(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdateInProgressState());

    await ProfileService.updateProfile(event.profile);

    emit(ProfileUpdateSuccessState());

    emit(ProfileLoadedState(profile: event.profile));
  }
}
