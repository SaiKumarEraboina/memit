import 'package:flutter/material.dart';
import 'package:memit/routing/router.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {  
  
    return MaterialApp.router(
       debugShowCheckedModeBanner: false, 
       routerConfig: goRouter,
         theme: ThemeData(
        // * Use this to toggle Material 3 (defaults to true since Flutter 3.16)
        useMaterial3: true,
        primarySwatch: Colors.grey, 
        primaryColor: const Color(0xFFF0F0F0),

        appBarTheme: const AppBarTheme( 
          
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // background (button) color
            foregroundColor: Colors.white, // foreground (text) color
          ),
        ),
      ),
    );
  }
}


