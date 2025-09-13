// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:memit/routing/app_routes.dart';
// import 'package:memit/services/profile_service.dart';

// class AuthenticationScreen extends StatefulWidget {
//   const AuthenticationScreen({super.key});

//   @override
//   State<AuthenticationScreen> createState() => _AuthenticationScreenState();
// }

// class _AuthenticationScreenState extends State<AuthenticationScreen> {
//   final _auth = FirebaseAuth.instance;
//   final _formKey = GlobalKey<FormState>();

//   bool isLogin = true;
//   String email = '';
//   String password = '';
//   String error = '';
//   bool isLoading = false;

//   Future<void> _submit() async {
//     setState(() {
//       isLoading = true;
//       error = '';
//     });

//     final isValid = _formKey.currentState?.validate();
//     if (!isValid!) return;

//     _formKey.currentState?.save();

//     try {
//       UserCredential userCredential;

//       if (isLogin) {
//         userCredential = await _auth.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );

//         if (!userCredential.user!.emailVerified) {
//           // await _auth.signOut();
//           setState(() {
//             error = 'Please verify your email before logging in.';
//           });
//         } else {
//           context.go(AppRoutes.home);
//         }
//       } else {
//         userCredential = await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );

//         await ProfileService.createUser(userCredential);

//         await userCredential.user!.sendEmailVerification();

//         setState(() {
//           error = 'Verification email sent. Please check your inbox.';
//           isLogin = true;
//         });
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         error = e.message ?? 'Authentication error';
//       });
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> _resendVerificationEmail() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//         setState(() {
//           error = 'Verification email resent.';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = 'Failed to resend verification email.';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 if (error.isNotEmpty)
//                   Text(
//                     error,
//                     style: const TextStyle(color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                 TextFormField(
//                   key: const ValueKey('email'),
//                   decoration: const InputDecoration(labelText: 'Email'),
//                   keyboardType: TextInputType.emailAddress,
//                   validator:
//                       (value) =>
//                           value != null && value.contains('@')
//                               ? null
//                               : 'Enter valid email',
//                   onSaved: (value) => email = value!.trim(),
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   key: const ValueKey('password'),
//                   decoration: const InputDecoration(labelText: 'Password'),
//                   obscureText: true,
//                   validator:
//                       (value) =>
//                           value != null && value.length >= 6
//                               ? null
//                               : 'Password too short',
//                   onSaved: (value) => password = value!.trim(),
//                 ),
//                 const SizedBox(height: 20),
//                 if (isLoading)
//                   const CircularProgressIndicator()
//                 else
//                   ElevatedButton(
//                     onPressed: _submit,
//                     child: Text(isLogin ? 'Login' : 'Sign Up'),
//                   ),
//                 TextButton(
//                   onPressed: () => setState(() => isLogin = !isLogin),
//                   child: Text(
//                     isLogin ? 'Create an account' : 'I already have an account',
//                   ),
//                 ),
//                 if (isLogin)
//                   TextButton(
//                     onPressed: _resendVerificationEmail,
//                     child: const Text('Resend verification email'),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
