import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/Views/tweet/view/create_tweet_view.dart';
import 'package:flutter_twitter_clone/theme/app_theme.dart';

import 'Views/HomeScreen/View/home_view.dart';
import 'Views/LoginViews/Views/LoginScreen.dart';
import 'Views/LoginViews/Views/SignupScreen.dart';
import 'Views/LoginViews/controller/auth_controller.dart';
import 'core/utils.dart';


void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Clone',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
        data: (user) => user != null
            ? const HomePage()
            : const LoginScreen(),
        error: (error, stackTrace) =>
            ErrorPage(Error: error.toString()),
        loading: () => const LoadingPage(),
      ),
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        SignupScreen.id: (context) => const SignupScreen(),
        HomePage.id: (context) => const HomePage(),
        CreateTweetView.id: (context) => const CreateTweetView(),
      },
    );
  }
}
