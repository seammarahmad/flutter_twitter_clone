import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

    Text('Home Page'),
    Text('Search Page'),
    Text('Notification Page'),

    // TweetList(),
    // ExploreView(),
    // NotificationView(),
  ];
}