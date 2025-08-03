import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memit/features/profile/bloc/profile_bloc.dart';
import 'package:memit/features/profile/bloc/profile_event.dart';
import 'package:memit/features/profile/bloc/profile_state.dart';
import 'package:memit/features/profile/models/profile_model.dart';
import 'package:memit/services/posts_service.dart';
import 'package:memit/services/profile_service.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  File? profileImage;
  File? coverImage;

  String? profileImageUrl;
  String? coverImageUrl;

  //TODO: Temp code

  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(bool isProfile) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isProfile) {
          profileImage = File(picked.path);
        } else {
          coverImage = File(picked.path);
        }
      });
    }
  }

  Future<void> saveProfile() async {
    setState(() {
      isLoading = true;
    });

    String? coverImagePath = coverImageUrl;
    if (coverImage != null) {
      String? newUrl = await PostsService.uploadFile(
        coverImage!,
        customPath: 'profile',
      );
      coverImagePath = newUrl;
    }

    String? profileImagePath = profileImageUrl;
    if (profileImage != null) {
      String? newUrl = await PostsService.uploadFile(
        profileImage!,
        customPath: 'profile',
      );
      profileImagePath = newUrl;
    }

    setState(() {
      isLoading = false;
    });

    context.read<ProfileBloc>().add(
      UpdateProfileEvent(
        profile: {
          "name": nameController.text,
          "username": usernameController.text,
          "profileImageUrl": profileImagePath,
          "coverImageUrl": coverImagePath,
          "bio": bioController.text,
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var state = context.read<ProfileBloc>().state;
    if (state is ProfileLoadedState) {
      nameController.text = state.profile.name ?? '';
      usernameController.text = state.profile.username ?? '';
      bioController.text = state.profile.bio ?? '';
      profileImageUrl = state.profile.profileImageUrl;
      coverImageUrl = state.profile.coverImageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) => current is ProfileUpdateSuccessState,
      listener: (context, state) {
        context.read<ProfileBloc>().add(FetchProfileEvent());
        context.pop();
      },
      buildWhen:
          (previous, current) =>
              current is ProfileUpdateInProgressState ||
              current is ProfileLoadedState,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            actions: [
              isLoading || state is ProfileUpdateInProgressState
                  ? CircularProgressIndicator()
                  : IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: saveProfile,
                  ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Cover Photo
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () => pickImage(false),
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child:
                            coverImage != null
                                ? Image.file(coverImage!, fit: BoxFit.cover)
                                : (coverImageUrl != null
                                    ? Image.network(
                                      coverImageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                    : const Center(
                                      child: Text("Tap to add cover photo"),
                                    )),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => pickImage(true),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          // backgroundImage:
                          //     profileImage != null
                          //         ? FileImage(profileImage!)
                          //         : null,
                          // Profile Picture UI
                          child:
                              profileImage != null
                                  ? CircleAvatar(
                                    radius: 40,
                                    backgroundImage: FileImage(profileImage!),
                                  )
                                  : (profileImageUrl != null
                                      ? CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(
                                          profileImageUrl!,
                                        ),
                                      )
                                      : const CircleAvatar(
                                        radius: 40,
                                        child: Icon(Icons.person, size: 40),
                                      )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: bioController,
                        decoration: const InputDecoration(labelText: 'Bio'),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
