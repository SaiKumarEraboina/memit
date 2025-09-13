import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memit/features/auth/domain/entities/app_user.dart';
import 'package:memit/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:memit/features/profile/componnents/bio_box.dart';
import 'package:memit/features/profile/componnents/edit_proofile_page.dart';
import 'package:memit/features/profile/cubit/profile_cubit.dart';
import 'package:memit/features/profile/cubit/profile_state.dart';
import 'package:cached_network_image/cached_network_image.dart' as cached;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// class _ProfilePageState extends State<ProfilePage> {
//   late final profileCubit = context.read<ProfileCubit>();
//   late final authCubit = context.read<AuthCubit>();
//   late AppUser? currentUser = authCubit.currentUser;

//   @override
// void initState() {
//   super.initState();

//   final currentUser = authCubit.currentUser;
//   if (currentUser != null) {

//     profileCubit.fetchUserProfile(uid: currentUser.uid);
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProfileCubit, ProfileState>(
//       builder: (context, state) {
//         if (state is ProfileLoadingState) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         } else

// // In _ProfilePageState's BlocBuilder
// if (state is ProfileLoadedState) {
//   final user = state.profileUser;
//   cached.CachedNetworkImageProvider(user.profileImgUrl).evict(); // Clear cache
//   return Scaffold(
//     appBar: AppBar(
//       actions: [
//         IconButton(
//           onPressed: () => Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => EditProfilePage(profileUser: user),
//             ),
//           ),
//           icon: Icon(
//             Icons.settings,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//       ],
//       title: Text(
//         user.name,
//         style: TextStyle(color: Theme.of(context).colorScheme.primary),
//       ),
//     ),
//     body: Padding(
//       padding: const EdgeInsets.all(25.0),
//       child: Column(
//         children: [
//           Center(
//             child: Text(
//               " ${user.email}",
//               style: TextStyle(color: Theme.of(context).colorScheme.primary),
//             ),
//           ),
//           CachedNetworkImage(
//             imageUrl: user.profileImgUrl,
//             placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
//             errorWidget: (context, url, error) => Icon(
//               Icons.person,
//               size: 72,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             imageBuilder: (context, imageProvider) => Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                   image: imageProvider,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 25),
//           BioBox(newBio: user.bio),
//         ],
//       ),
//     ),
//   );
// }

//          else if (state is ProfileErrorState) {
//           return Scaffold(body: Center(child: Text("Error: ${state.error}")));
//         } else {
//           return const Scaffold(
//             body: Center(child: Text("This user does not exist")),
//           );
//         }
//       },
//     );
//   }
// }

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  late AppUser? currentUser = authCubit.currentUser;

  @override
  void initState() {
    super.initState();
    final currentUser = authCubit.currentUser;
    if (currentUser != null) {
      profileCubit.fetchUserProfile(uid: currentUser.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        print('BlocBuilder state: ${state.runtimeType}'); // Debug
        if (state is ProfileLoadingState) {
          print('Showing loading indicator'); // Debug
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else
        // In _ProfilePageState's BlocBuilder
        if (state is ProfileLoadedState) {
          final user = state.profileUser;
          print(
            'ProfileSuccessState: ${user.name}, ${user.email}, ${user.profileImgUrl}, ${user.bio}',
          ); // Debug
          cached.CachedNetworkImageProvider(
            user.profileImgUrl,
          ).evict(); // Clear cache
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    print(
                      'Navigating to EditProfilePage for user: ${user.name}',
                    ); // Debug
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => EditProfilePage(profileUser: user),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    authCubit.logout();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
              title: Text(
                user.name,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      " ${user.email}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle, // Circular container
                    ),
                    height: 120,
                    width: 120,
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      imageUrl: user.profileImgUrl,
                      placeholder:
                          (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                      errorWidget:
                          (context, url, error) => Icon(
                            Icons.person,
                            size: 72,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      imageBuilder:
                          (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    ),
                  ),
                  SizedBox(height: 25),
                  BioBox(newBio: user.bio),
                ],
              ),
            ),
          );
        } else if (state is ProfileErrorState) {
          print('ProfileErrorState: ${state.error}'); // Debug
          return Scaffold(body: Center(child: Text('Error: ${state.error}')));
        } else {
          print('Default state: This user does not exist'); // Debug
          return Scaffold(
            body: Center(child: Text('This user does not exist')),
          );
        }
      },
    );
  }
}
