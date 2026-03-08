import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/config/environment.dart';
import 'package:flutter_twitter_clone/core/provider.dart';
import 'package:flutter_twitter_clone/model/tweet_model.dart';
import 'package:fpdart/fpdart.dart';

final TweetApiProvider = Provider((ref) {
  return Tweetapi(
    db: ref.watch(appWriteDatabaseProvider),
    realtime: ref.watch(appWriteRealTimeProvider),
  );
});

abstract class TweetapiInterface {
  Future<Either<String, Document>> shareTweet(Tweet tweet);

  Future<List<Document>> getTweets();

  Stream<RealtimeMessage> getLatestTweet();

  Future<Either<String, Document>> likeTweet(Tweet tweet);
}

class Tweetapi implements TweetapiInterface {
  final Databases _db;
  final Realtime _realtime;

  Tweetapi({required Databases db, required Realtime realtime})
    : _realtime = realtime,
      _db = db;

  @override
  Future<Either<String, Document>> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: Environment.appwriteDatabaseID,
        collectionId: Environment.appwriteTweetcollectionId,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );

      return right(document);
    } catch (e) {
      print('error in Tweet api : ' + e.toString());
      return left(e.toString());
    }
  }

  @override
  Future<List<Document>> getTweets() async {
    final abc = await _db.listDocuments(
      databaseId: Environment.appwriteDatabaseID,
      collectionId: Environment.appwriteTweetcollectionId,
      queries: [Query.orderDesc('tweetedAt')],
    );
    return abc.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${Environment.appwriteDatabaseID}.collections.${Environment.appwriteTweetcollectionId}.documents',
    ]).stream;
  }

  @override
  Future<Either<String, Document>> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: Environment.appwriteDatabaseID,
        collectionId: Environment.appwriteTweetcollectionId,
        documentId: tweet.id,
        data: {'likes': tweet.likes},
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(e.message ?? 'Some unexpected error occured');
    } catch (e, st) {
      print('error in Tweet api : ' + e.toString());
      return left('Some unexpected error occured in the likes tweet api');
    }
  }
}
