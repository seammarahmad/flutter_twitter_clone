import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/config/environment.dart';
import 'package:fpdart/fpdart.dart';

import '../core/provider.dart';
import '../model/usermodel.dart';

final userApiProvider = Provider((ref) {
  final db = ref.watch(appWriteDatabaseProvider);
  return UserApi(db: db);
});

abstract class AUserApi {
  Future<Either<String, void>> saveUserData({required UserModel userModel});
}

class UserApi extends AUserApi {
  final Databases _db;

  UserApi({required Databases db}) : _db = db;

  @override
  Future<Either<String, void>> saveUserData({
    required UserModel userModel,
  }) async {
    try {
      await _db.createDocument(
        databaseId: Environment.appwriteDatabaseID,
        collectionId: Environment.collectionId,
        documentId: ID.unique(),
        data: userModel.toMap(),
      );

      return right(null);
    } catch (e) {
      print('error in user api' + e.toString());
      return left(e.toString());
    }
  }
}
