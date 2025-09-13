import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memit/features/auth/domain/entities/app_user.dart';
import 'package:memit/features/auth/domain/repository/auth_repo.dart';
import 'package:memit/features/auth/presentation/cubit/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo authRepo;
  AppUser? _currentUser;
  AuthCubit({required this.authRepo}) : super(AuthInitialState());

  //check if user is already authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(AuthenticatedState(appUser: user));
    } else {
      emit(UnAuthenticatedState());
    }
  }

  //get current user
  AppUser? get currentUser {
    return _currentUser;
  }

  //login with email and password
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoadingState());
      final user = await authRepo.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user != null) {
        _currentUser = user;
        emit(AuthenticatedState(appUser: user));
      }
    } catch (e) {
      emit(AuthErrorState(error: e.toString()));
      emit(UnAuthenticatedState());
    }
  }

  //register with email and password
  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoadingState());
      final user = await authRepo.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      if (user != null) {
        _currentUser = user;
        emit(AuthenticatedState(appUser: user));
      } else {
        emit(UnAuthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(error: e.toString()));
      emit(UnAuthenticatedState());
    }
  }

  //log out
  Future<void> logout() async {
    await authRepo.logOutUser();
    emit(UnAuthenticatedState());
  }
}
