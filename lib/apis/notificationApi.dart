import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/config/environment.dart';
import 'package:fpdart/fpdart.dart';

import '../core/provider.dart';
import '../core/utils.dart';
import '../model/notification_model.dart';

final notificationAPIProvider = Provider((ref) {
  return NotificationAPI(
    db: ref.watch(appWriteDatabaseProvider),
    realtime: ref.watch(appWriteRealTimeProvider),
  );
});

class NotificationAPI {
  final Databases _db;
  final Realtime _realtime;

  NotificationAPI({required Databases db, required Realtime realtime})
    : _db = db,
      _realtime = realtime;

  Future<Either<Failure, void>> createNotification(
    Notification notification,
  ) async {
    try {
      await _db.createDocument(
        databaseId: Environment.appwriteDatabaseID,
        collectionId: Environment.appwriteNotificationcollectionId,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Unexpected error occurred', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  Future<List<Document>> getNotifications(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: Environment.appwriteDatabaseID,
      collectionId: Environment.appwriteNotificationcollectionId,
      queries: [
        Query.equal('uid', uid),
        Query.orderDesc('createdAt'),
        Query.limit(50),
      ],
    );
    return documents.documents;
  }

  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      'databases.${Environment.appwriteDatabaseID}.collections.${Environment.appwriteNotificationcollectionId}.documents',
    ]).stream;
  }
}
