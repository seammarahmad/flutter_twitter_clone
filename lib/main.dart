import 'package:flutter/material.dart';

import 'Views/LoginViews/Views/LoginScreen.dart';
import 'Views/LoginViews/Views/SignupScreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter Clone Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,

      initialRoute: LoginScreen.id,

      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        SignupScreen.id: (context) => const SignupScreen(),

      },
    );
  }
}
