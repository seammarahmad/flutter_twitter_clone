import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/config/environment.dart';
import 'package:flutter_twitter_clone/core/utils.dart';

import '../../../model/usermodel.dart';
import '../controller/user_profile_controller.dart';
import '../widgets/user_profile.dart';


class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
    builder: (context) => UserProfileView(userModel: userModel),
  );
  final UserModel userModel;
  const UserProfileView({super.key, required this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel currentUser = userModel;

    return Scaffold(
      body: ref.watch(getLatestUserProfileDataProvider).when(
        data: (data) {
          try {
            final events = List<String>.from(data.events as List);
            final isUserUpdate = events.any((e) => e.contains(
                'databases.*.collections.${Environment.appwriteUserCollectionId}.documents.${currentUser.uid}.update'));
            if (isUserUpdate) {
              currentUser = UserModel.fromMap(
                Map<String, dynamic>.from(data.payload as Map),
              );
            }
          } catch (_) {}
          return UserProfile(user: currentUser);
        },
        loading: () => UserProfile(user: currentUser),
        error: (e, _) => ErrorMessage(error: e.toString()),
      ),
    );
  }
}
