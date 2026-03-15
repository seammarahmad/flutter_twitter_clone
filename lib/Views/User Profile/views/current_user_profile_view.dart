import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/Views/User%20Profile/widgets/user_profile.dart';
import 'package:flutter_twitter_clone/core/utils.dart';

class CurrentUserProfileView extends ConsumerWidget {
  const CurrentUserProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserdetailsProvider).value;

    return Scaffold(
      body: currentUser == null
          ? const Loader()
          : UserProfile(
              user: currentUser,
              isFromBottomNav: true,
            ),
    );
  }
}
