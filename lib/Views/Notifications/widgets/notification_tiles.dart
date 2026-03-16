import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/enum/notification_enum.dart';
import '../../../theme/pallete.dart';
import 'package:flutter_twitter_clone/model/notification_model.dart' as model;



class NotificationTile extends StatelessWidget {
  final model.Notification notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
        Icons.person,
        color: Pallete.blueColor,
      )
          : notification.notificationType == NotificationType.like
          ? SvgPicture.asset(
        'assets/svgs/like_filled.svg',
        color: Pallete.redColor,
        height: 20,
      )
          : notification.notificationType == NotificationType.retweet
          ? SvgPicture.asset(
      'assets/svgs/retweet.svg',
        color: Pallete.whiteColor,
        height: 20,
      )
          : null,
      title: Text(notification.text),
    );
  }
}