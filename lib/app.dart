import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memit/features/auth/data/firebase_auth_repo.dart';
import 'package:memit/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:memit/features/auth/presentation/cubit/auth_states.dart';
import 'package:memit/features/auth/presentation/pages/auth_page.dart';
import 'package:memit/features/posts/data/firebase_post_repo.dart';
import 'package:memit/features/posts/presentation/cubit/post_cubit.dart';
import 'package:memit/features/profile/cubit/profile_cubit.dart';
import 'package:memit/features/profile/data/firebase_profile_repo.dart';
import 'package:memit/features/storage/data/firebase_storage_repo.dart';
import 'package:memit/routing/router.dart';
import 'package:memit/themes/lignt_mode.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _firebaseAuthRepo = FirebaseAuthRepo();
  static final _firebaseProfileRepo = FirebaseProfileRepo();
  static final _firebaseStorageRepo = FirebaseStorageRepo();
  static final _firebasePostRepo = FirebasePostRepo();
  static final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: _firebaseAuthRepo)..checkAuth(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: _firebaseProfileRepo,
            storageRepo: _firebaseStorageRepo,
          ),
        ),
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: _firebasePostRepo,
            storageRepo: _firebaseStorageRepo,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthStates>(
          builder: (context, state) {
            if (state is AuthenticatedState) {
              return _appRouter;
            }
            if (state is UnAuthenticatedState) {
              return const AuthPage();
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
          listener: (context, state) {
            if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
        ),
      ),
    );
  }
}
