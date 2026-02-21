import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Views/HomeScreen/View/home_view.dart';
import 'Views/LoginViews/Views/LoginScreen.dart';
import 'Views/LoginViews/Views/SignupScreen.dart';


void main() {
  runApp(ProviderScope(child: const MyApp()));
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
        HomePage.id: (context) => const HomePage(),

      },
    );
  }
}
