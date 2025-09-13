
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memit/features/auth/presentation/components/custom_textfield.dart';
import 'package:memit/features/profile/cubit/profile_cubit.dart';
import 'package:memit/features/profile/cubit/profile_state.dart';
import 'package:memit/features/profile/domain/entities/profile_user.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser profileUser;

  const EditProfilePage({super.key, required this.profileUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioController = TextEditingController();


  void onUpdateProfile() { 
    final profileCubit = context.read<ProfileCubit>();
    if (bioController.text.isNotEmpty) {
      profileCubit.updateProfileUser(
        uid: widget.profileUser.uid,
        newBio: bioController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoadedState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is ProfileLoadingState) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          return buildEditPage(context);
        }
      },
    );
  }

  Widget buildEditPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: onUpdateProfile,
            icon: Icon(Icons.check),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Text(
              'Bio',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: CustomTextField(
              controller: bioController,
              hintText: 'Bio',
              obscureText: false,
            ),
          ),
        ],
      ),
    );
  }
}
