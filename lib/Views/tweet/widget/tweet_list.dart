import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/Views/tweet/controller/tweet_controller.dart';
import 'package:flutter_twitter_clone/Views/tweet/widget/tweet_card.dart';
import 'package:flutter_twitter_clone/core/utils.dart';

import '../../../config/environment.dart';
import '../../../model/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(getTweetsProvider)
        .when(
          data: (tweets) {
            return ref
                .watch(getlatestTweetProvider)
                .when(
                  data: (data) {
                    if (data.events.contains(
                      'databases.*.collections.${Environment.appwriteTweetcollectionId}.documents.*.create',
                    )) {
                      tweets.insert(0, Tweet.fromMap(data.payload));
                    } else if (data.events.contains(
                      'databases.*.collections.${Environment.appwriteTweetcollectionId}.documents.*.update',
                    )) {
                      final startingPoint =
                      data.events[0].lastIndexOf('rows.');
                      final endPoint = data.events[0].lastIndexOf('.update');
                      final tweetId = data.events[0]
                          .substring(startingPoint + 5, endPoint);

                      print('Tweet if is : '+tweetId);

                      var tweet = tweets
                          .where((element) => element.id == tweetId)
                          .first;

                      final tweetIndex = tweets.indexOf(tweet);
                      tweets.removeWhere((element) => element.id == tweetId);

                      tweet = Tweet.fromMap(data.payload);
                      tweets.insert(tweetIndex, tweet);
                    }
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorMessage(error: error.toString()),
                  loading: () {
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                );
          },
          error: (error, stackTrace) => ErrorMessage(error: error.toString()),
          loading: () => Loader(),
        );
  }
}
