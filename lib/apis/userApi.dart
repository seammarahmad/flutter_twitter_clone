import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/config/environment.dart';
import 'package:fpdart/fpdart.dart';

import '../core/provider.dart';
import '../core/utils.dart';
import '../model/usermodel.dart';

final userApiProvider = Provider((ref) {
  final db = ref.watch(appWriteDatabaseProvider);
  return UserApi(db: db, realtime: ref.watch(appWriteRealTimeProvider));
});

abstract class AUserApi {
  Future<Either<String, void>> saveUserData({required UserModel userModel});

  Future<Document> getUserData(String uid);

  Future<List<Document>> searchUserByName(String name);
}

class UserApi extends AUserApi {
  final Databases _db;
  final Realtime _realtime;

  UserApi({required Databases db, required Realtime realtime})
    : _realtime = realtime,
      _db = db;

  @override
  Future<Either<String, void>> saveUserData({
    required UserModel userModel,
  }) async {
    try {
      await _db.createDocument(
        databaseId: Environment.appwriteDatabaseID,
        collectionId: Environment.appwriteUserCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );

      return right(null);
    } catch (e) {
      print('error in user api' + e.toString());
      return left(e.toString());
    }
  }

  @override
  Future<Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: Environment.appwriteDatabaseID,
      collectionId: Environment.appwriteUserCollectionId,
      documentId: uid,
    );
  }

  @override
  Future<List<Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
      databaseId: Environment.appwriteDatabaseID,
      collectionId: Environment.appwriteUserCollectionId,
      queries: [Query.search('name', name)],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      'databases.${Environment.appwriteDatabaseID}.collections.${Environment.appwriteUserCollectionId}.documents',
    ]).stream;
  }

  @override
  Future<Either<Failure, void>> followUser(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: Environment.appwriteDatabaseID,
        collectionId: Environment.appwriteUserCollectionId,
        documentId: user.uid,
        data: {'followers': user.followers},
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Unexpected error occurred', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<Either<Failure, void>> addToFollowing(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: Environment.appwriteDatabaseID,
        collectionId: Environment.appwriteUserCollectionId,
        documentId: user.uid,
        data: {'following': user.following},
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Unexpected error occurred', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: Environment.appwriteDatabaseID,
        collectionId: Environment.appwriteUserCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Unexpected error occurred', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
