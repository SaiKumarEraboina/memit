import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
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
  PlatformFile? imagePickedFile;
  Uint8List? pickedWebImage;
  final bioController = TextEditingController();

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          pickedWebImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  void onUpdateProfile() {
    final profileCubit = context.read<ProfileCubit>();
    final String uid = widget.profileUser.uid;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;
    final String? newBio =
        bioController.text.isNotEmpty ? bioController.text : null;

    if (newBio != null || imagePickedFile != null) {
      profileCubit.updateProfileUser(
        uid: uid,
        newBio: newBio,
        imageMobilePath:imageMobilePath,
        imageWebBytes: imageWebBytes,
        // imgProfileMobilePath:imageMobilePath ,
        // imgProfileWebBytes: imageWebBytes
      );
    } else {
      Navigator.of(context).pop();
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
          return buildEditPage();
        }
      },
    );
  }

  Widget buildEditPage() {
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
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.hardEdge,
              child:
                  (!kIsWeb && imagePickedFile != null)
                      ? Image.file(
                        File(imagePickedFile!.path!),
                        fit: BoxFit.cover,
                      )
                      : (kIsWeb && pickedWebImage != null)
                      ? Image.memory(pickedWebImage!)
                      : CachedNetworkImage(
                        imageUrl: widget.profileUser.profileImgUrl,

                        // loading..
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),

                        // error -> failed to load
                        errorWidget:
                            (context, url, error) => Icon(
                              Icons.person,
                              size: 72,
                              color: Theme.of(context).colorScheme.primary,
                            ),

                        // loaded
                        imageBuilder:
                            (context, imageProvider) =>
                                Image(image: imageProvider),
                        //  CircleAvatar(backgroundImage: imageProvider),
                      ),
            ),
          ),
          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: Text('Pick Image'),
            ),
          ),

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
