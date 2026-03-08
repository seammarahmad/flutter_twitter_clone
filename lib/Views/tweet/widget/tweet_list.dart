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
                  loading: (){
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
