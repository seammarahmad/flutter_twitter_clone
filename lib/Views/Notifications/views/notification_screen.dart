import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/config/environment.dart';

import 'package:flutter_twitter_clone/model/notification_model.dart' as model;

import '../../../core/utils.dart';
import '../controller/notification_controller.dart';
import '../widgets/notification_tiles.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserdetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationsProvider(currentUser.uid)).when(
        data: (notifications) {
          return ref.watch(getLatestNotificationProvider).when(
            data: (data) {
              if (data.events.contains(
                'databases.*.collections.${Environment.appwriteNotificationcollectionId}.documents.*.create',
              )) {
                final latestNotif =
                model.Notification.fromMap(data.payload);
                if (latestNotif.uid == currentUser.uid) {
                  notifications.insert(0, latestNotif);
                }
              }

              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  final notification = notifications[index];
                  return NotificationTile(
                    notification: notification,
                  );
                },
              );
            },
            error: (error, stackTrace) => ErrorMessage(
              error: error.toString(),
            ),
            loading: () {
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  final notification = notifications[index];
                  return NotificationTile(
                    notification: notification,
                  );
                },
              );
            },
          );
        },
        error: (error, stackTrace) => ErrorMessage(
          error: error.toString(),
        ),
        loading: () => const Loader(),
      ),
    );
  }
}