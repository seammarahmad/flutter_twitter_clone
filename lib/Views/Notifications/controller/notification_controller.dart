import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../apis/notificationApi.dart';
import '../../../core/enum/notification_enum.dart';
import '../../../model/notification_model.dart';

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
      return NotificationController(
        notificationAPI: ref.watch(notificationAPIProvider),
      );
    });

final getLatestNotificationProvider = StreamProvider((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  return notificationAPI.getLatestNotification();
});

final getNotificationsProvider = FutureProvider.family((ref, String uid) async {
  final controller = ref.watch(notificationControllerProvider.notifier);
  return controller.getNotifications(uid);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;

  NotificationController({required NotificationAPI notificationAPI})
    : _notificationAPI = notificationAPI,
      super(false);

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
    required String fromUserId,
  }) async {
    if (uid == fromUserId) return;
    final notification = Notification(
      text: text,
      postId: postId,
      id: '',
      uid: uid,
      notificationType: notificationType,
    );
    await _notificationAPI.createNotification(notification);
  }

  Future<List<Notification>> getNotifications(String uid) async {
    final notifications = await _notificationAPI.getNotifications(uid);
    return notifications.map((e) => Notification.fromMap(e.data)).toList();
  }
}
