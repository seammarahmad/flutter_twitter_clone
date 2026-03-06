import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/config/environment.dart';
import 'package:flutter_twitter_clone/core/provider.dart';
import 'package:flutter_twitter_clone/model/tweet_model.dart';
import 'package:fpdart/fpdart.dart';


final TweetApiProvider=Provider((ref){
  return Tweetapi(db: ref.watch(appWriteDatabaseProvider));
});


abstract class TweetapiInterface {
  Future<Either<String, Document>> shareTweet(Tweet tweet);
}

class Tweetapi implements TweetapiInterface {
  final Databases _db;

  Tweetapi({required Databases db}) : _db = db;

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
}
