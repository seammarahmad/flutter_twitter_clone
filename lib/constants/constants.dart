import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_twitter_clone/Views/Explore/views/explore_view.dart';
import 'package:flutter_twitter_clone/Views/Notifications/views/notification_screen.dart';
import 'package:flutter_twitter_clone/Views/User%20Profile/views/current_user_profile_view.dart';
import 'package:flutter_twitter_clone/Views/tweet/widget/tweet_list.dart';
import '../theme/pallete.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        'assets/svgs/twitter_logo.svg',
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    TweetList(),
    ExploreView(),
    NotificationScreen(),
    CurrentUserProfileView(),
  ];
}
