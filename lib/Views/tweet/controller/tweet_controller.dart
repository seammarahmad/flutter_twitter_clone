import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/apis/tweetApi.dart';
import 'package:flutter_twitter_clone/core/enum/tweet_enum.dart';
import 'package:flutter_twitter_clone/core/utils.dart';
import 'package:flutter_twitter_clone/model/tweet_model.dart';

final TweetControllerProvider=StateNotifierProvider<TweetController,bool>((ref) {
  final tweetAPI = ref.watch(TweetApiProvider);
  return TweetController(tweetAPI: tweetAPI, ref: ref);
});

class TweetController extends StateNotifier<bool> {
  final Tweetapi _tweetAPI;

  final Ref _ref;

  TweetController({required Ref ref, required Tweetapi tweetAPI})
    : _tweetAPI = tweetAPI,
      _ref = ref,
      super(false);

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please Enter Some Text');
      return;
    }
    if (images.isNotEmpty) {
      _shareImageTweet(images: images, text: text, context: context);
    } else {
      _shareTextTweet(text: text, context: context);
    }
  }

  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {}

  Future<void> _shareTextTweet({
    required String text,
    required BuildContext context,
  }) async {
    try {
      state = true;
      final link = _getLinkFromText(text);
      final hashtags = _getHashtagFromText(text);
      final user = _ref.read(currentUserdetailsProvider).value!;

      Tweet tweet = Tweet(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: [],
        uid: user.uid,
        tweetType: TweetType.text,
        tweetedAt: DateTime.now(),
        likes: [],
        commentIds: [],
        id: '',
        reshareCount: 0,
        retweetedBy: '',
        repliedTo: '',
      );

      final res = await _tweetAPI.shareTweet(tweet);

      state = false;
      res.fold((l) => showSnackBar(context, l.toString()), (r) => null);
    } on Exception catch (e) {
      print(e.toString());
      state = false;
    }
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> textInSentence = text.split(' ');

    for (String word in textInSentence) {
      if (word.startsWith('https://') ||
          word.startsWith('www.') ||
          word.startsWith('http://')) {
        link = word;
      }
    }

    return link;
  }

  List<String> _getHashtagFromText(String text) {
    List<String> hashtags = [];
    List<String> textInSentence = text.split(' ');

    for (String word in textInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }

    return hashtags;
  }
}
