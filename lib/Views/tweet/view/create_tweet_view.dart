import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/constants/constants.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/theme/pallete.dart';

class CreateTweetView extends ConsumerStatefulWidget {
  static String id = 'create_tweet_view';

  const CreateTweetView({super.key});

  @override
  ConsumerState<CreateTweetView> createState() => _CreateTweetViewState();
}

class _CreateTweetViewState extends ConsumerState<CreateTweetView> {
  @override
  Widget build(BuildContext context) {
    final currentUser=ref.watch(currentUserdetailsProvider).value;
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.close, color: Pallete.whiteColor),
        ),
        actions: [
          RoundButton(colour: Pallete.blueColor, title: 'Tweet', onPress: () {  }, Size: 50.0,),
        ],

      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(currentUser.profilePic),
                  radius: 30,
                ),

              ],
            )
          ],
        ),
      )),
    );
  }
}
