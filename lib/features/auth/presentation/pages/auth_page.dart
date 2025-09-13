import 'package:flutter/material.dart';
import 'package:memit/features/auth/presentation/pages/login_page.dart' show LoginPage;
import 'package:memit/features/auth/presentation/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggleAuth() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(toggleAuth:toggleAuth,);
    }
    return RegisterPage(toggleAuth: toggleAuth,);
  }
}
