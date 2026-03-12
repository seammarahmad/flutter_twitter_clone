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

  Future<Either<String, Document>> updateresharecountTweet(Tweet tweet);

  Future<List<Document>> getRepliesToTweets(Tweet tweet);

  Future<List<Document>> getTweetsByHashtag(String hashtag);
  Future<List<Document>> searchTweets(String query);
  Future<Document> getTweetById(String id);
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

  @override
  Future<Either<String, Document>> updateresharecountTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: Environment.appwriteDatabaseID,
        collectionId: Environment.appwriteTweetcollectionId,
        documentId: tweet.id,
        data: {'reshareCount': tweet.reshareCount},
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(e.message ?? 'Some unexpected error occured');
    } catch (e, st) {
      print('error in Tweet api : ' + e.toString());
      return left('Some unexpected error occured in the likes tweet api');
    }
  }


  @override
  Future<Document> getTweetById(String id) async {
    return _db.getDocument(
      databaseId: Environment.appwriteDatabaseID,
      collectionId: Environment.appwriteTweetcollectionId,
      documentId: id,
    );
  }

  @override
  Future<List<Document>> getUserTweets(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: Environment.appwriteDatabaseID,
      collectionId: Environment.appwriteTweetcollectionId,
      queries: [
        Query.equal('uid', uid),
        Query.orderDesc('tweetedAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getTweetsByHashtag(String hashtag) async {
    final documents = await _db.listDocuments(
      databaseId: Environment.appwriteDatabaseID,
      collectionId: Environment.appwriteTweetcollectionId,
      queries: [Query.search('hashtags', hashtag)],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> searchTweets(String query) async {
    final documents = await _db.listDocuments(
      databaseId: Environment.appwriteDatabaseID,
      collectionId: Environment.appwriteTweetcollectionId,
      queries: [
        Query.search('text', query),
        Query.orderDesc('tweetedAt'),
        Query.limit(30),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getRepliesToTweets(Tweet tweet) async {
    final document = await _db.listDocuments(
      databaseId: Environment.appwriteDatabaseID,
      collectionId: Environment.appwriteTweetcollectionId,
      queries: [
        Query.equal('repliedTo', tweet.id),
        Query.orderAsc('tweetedAt'),
      ],
    );
    return document.documents;
  }
}
