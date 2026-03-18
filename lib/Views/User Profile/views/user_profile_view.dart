import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/core/utils.dart';

import '../../../model/usermodel.dart';
import '../widgets/user_profile.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
    builder: (context) => UserProfileView(userModel: userModel),
  );
  final UserModel userModel;
  const UserProfileView({super.key, required this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(userDetailsProvider(userModel.uid)).when(
        data: (user) {
          return UserProfile(user: user, isFromBottomNav: false);
        },
        loading: () => UserProfile(user: userModel, isFromBottomNav: false),
        error: (e, st) => ErrorMessage(error: e.toString()),
      ),
    );
  }
}
