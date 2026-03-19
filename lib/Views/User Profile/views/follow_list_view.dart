import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/Views/Explore/widgets/search_tile.dart';
import 'package:flutter_twitter_clone/Views/User%20Profile/controller/user_profile_controller.dart';
import 'package:flutter_twitter_clone/core/utils.dart';
import 'package:flutter_twitter_clone/theme/pallete.dart';

class FollowListView extends ConsumerWidget {
  static route(String title, List<String> userIds) => MaterialPageRoute(
        builder: (context) => FollowListView(
          title: title,
          userIds: userIds,
        ),
      );

  final String title;
  final List<String> userIds;
  const FollowListView({
    super.key,
    required this.title,
    required this.userIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
      ),
      body: userIds.isEmpty
          ? Center(
              child: Text(
                'No users found',
                style: TextStyle(color: Pallete.greyColor, fontSize: 16),
              ),
            )
          : ref.watch(getUsersListProvider(userIds)).when(
                data: (users) {
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return SearchTile(userModel: user);
                    },
                  );
                },
                error: (error, stackTrace) =>
                    ErrorMessage(error: error.toString()),
                loading: () => const Loader(),
              ),
    );
  }
}
