// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:memit/constants/firebase_collections.dart';

// class ProfileService {
//   static Future<ProfileModel?> getProfile() async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId == null) return null;

//       final doc =
//           await FirebaseFirestore.instance
//               .collection(FirebaseCollections.users)
//               .doc(userId)
//               .get();

//       if (doc.exists) {
//         return ProfileModel.fromJson(doc.data()!);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print("Error fetching profile: $e");
//       return null;
//     }
//   }

//   static Future<bool> updateProfile(dynamic profile) async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId == null) return false;

//       await FirebaseFirestore.instance
//           .collection(FirebaseCollections.users)
//           .doc(userId)
//           .update(profile);

//       return true;
//     } catch (e) {
//       print("Error updating profile: $e");
//       return false;
//     }
//   }

//   static Future<void> createUser(UserCredential userCredential) async {
//     await FirebaseFirestore.instance
//         .collection(FirebaseCollections.users)
//         .doc(userCredential.user!.uid)
//         .set({
//           'id': userCredential.user!.uid,
//           'email': userCredential.user!.email,
//         });
//   }
// }
