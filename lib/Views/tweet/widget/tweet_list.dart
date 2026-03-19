import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/Views/tweet/controller/tweet_controller.dart';
import 'package:flutter_twitter_clone/Views/tweet/widget/tweet_card.dart';
import 'package:flutter_twitter_clone/core/utils.dart';
import 'package:flutter_twitter_clone/model/tweet_model.dart';

class TweetList extends ConsumerStatefulWidget {
  const TweetList({super.key});

  @override
  ConsumerState<TweetList> createState() => _TweetListState();
}

class _TweetListState extends ConsumerState<TweetList> {
  final ScrollController _scrollController = ScrollController();
  List<Tweet> tweets = [];
  bool isInitialLoading = true;
  bool isFetchingMore = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialTweets();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialTweets() async {
    final fetchedTweets = await ref.read(TweetControllerProvider.notifier).getTweets();
    if (mounted) {
      setState(() {
        tweets = fetchedTweets;
        isInitialLoading = false;
        if (fetchedTweets.length < 25) {
          hasMore = false;
        }
      });
    }
  }

  Future<void> _fetchMoreTweets() async {
    if (isFetchingMore || !hasMore) return;

    setState(() {
      isFetchingMore = true;
    });

    final lastId = tweets.isEmpty ? null : tweets.last.id;
    final fetchedTweets = await ref.read(TweetControllerProvider.notifier).getTweets(lastId: lastId);

    if (mounted) {
      setState(() {
        tweets.addAll(fetchedTweets);
        isFetchingMore = false;
        if (fetchedTweets.length < 25) {
          hasMore = false;
        }
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _fetchMoreTweets();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isInitialLoading) {
      return const Loader();
    }

    return ref.watch(getlatestTweetProvider).when(
          data: (data) {
            if (data.events.any((e) => e.endsWith('.create'))) {
              final newTweet = Tweet.fromMap(data.payload);
              if (!tweets.any((t) => t.id == newTweet.id)) {
                tweets.insert(0, newTweet);
              }
            } else if (data.events.any((e) => e.endsWith('.update'))) {
              final updatedTweet = Tweet.fromMap(data.payload);
              final tweetIndex = tweets.indexWhere((t) => t.id == updatedTweet.id);

              if (tweetIndex != -1) {
                tweets[tweetIndex] = updatedTweet;
              }
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: tweets.length + (isFetchingMore ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index == tweets.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final tweet = tweets[index];
                return TweetCard(tweet: tweet);
              },
            );
          },
          error: (error, stackTrace) => ErrorMessage(error: error.toString()),
          loading: () {
            return ListView.builder(
              controller: _scrollController,
              itemCount: tweets.length,
              itemBuilder: (BuildContext context, int index) {
                final tweet = tweets[index];
                return TweetCard(tweet: tweet);
              },
            );
          },
        );
  }
}
