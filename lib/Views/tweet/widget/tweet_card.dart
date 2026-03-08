import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/Views/tweet/widget/carousal_image.dart';
import 'package:flutter_twitter_clone/Views/tweet/widget/hashtag_text.dart';
import 'package:flutter_twitter_clone/Views/tweet/widget/tweet_iconbutton.dart';
import 'package:flutter_twitter_clone/core/enum/tweet_enum.dart';
import 'package:flutter_twitter_clone/core/utils.dart';
import 'package:flutter_twitter_clone/theme/pallete.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../model/tweet_model.dart';
import '../controller/tweet_controller.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;

  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserdetailsProvider).value;
    return currentUser == null
        ? Loader()
        : ref
              .watch(userDetailsProvider(tweet.uid))
              .when(
                data: (user) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(20.0),
                            child: CircleAvatar(
                              radius: 30,

                              backgroundColor: Pallete.blueColor,
                              backgroundImage: user.profilePic.isNotEmpty
                                  ? NetworkImage(user.profilePic)
                                  : null,
                              child: user.profilePic.isEmpty
                                  ? Icon(Icons.person)
                                  : null,
                            ),
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///TODO Retweeted
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 05),
                                      child: Text(
                                        user.name,
                                        style: TextStyle(
                                          color: Pallete.whiteColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    Text(
                                      "@${user.name} . ${timeago.format(tweet.tweetedAt, locale: 'en_short')}",
                                      style: TextStyle(
                                        color: Pallete.greyColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                //TODO Replied to
                                HashtagText(text: tweet.text),
                                if (tweet.tweetType == TweetType.image)
                                  CarousalImage(imageslinks: tweet.imageLinks),

                                if (tweet.link.isNotEmpty) ...[
                                  const SizedBox(height: 05),
                                  AnyLinkPreview(link: 'http://${tweet.link}'),
                                ],

                                const SizedBox(height: 05),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TweetIconbutton(
                                      imgaddress: 'assets/svgs/views.svg',
                                      text:
                                          (tweet.commentIds.length +
                                                  tweet.likes.length +
                                                  tweet.reshareCount)
                                              .toString(),
                                      onTap: () {},
                                    ),
                                    TweetIconbutton(
                                      imgaddress: 'assets/svgs/comment.svg',
                                      text: tweet.commentIds.length.toString(),
                                      onTap: () {},
                                    ),

                                    TweetIconbutton(
                                      imgaddress: 'assets/svgs/retweet.svg',
                                      text: tweet.reshareCount.toString(),
                                      onTap: () {},
                                    ),
                                    LikeButton(
                                      onTap: (isliked) async {
                                        ref
                                            .read(
                                              TweetControllerProvider.notifier,
                                            )
                                            .likeTweet(tweet, currentUser);
                                        return !isliked;
                                      },
                                      isLiked: tweet.likes.contains(
                                        currentUser.uid,
                                      ),
                                      likeCount: tweet.likes.length,
                                      countBuilder: (likeCount, isLiked, text) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            left: 2.0,
                                          ),
                                          child: Text(
                                            text,
                                            style: TextStyle(
                                              color: isLiked
                                                  ? Pallete.redColor
                                                  : Pallete.whiteColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        );
                                      },
                                      size: 25,
                                      likeBuilder: (isLiked) {
                                        return isLiked
                                            ? SvgPicture.asset(
                                                'assets/svgs/like_filled.svg',
                                                color: Colors.red,
                                              )
                                            : SvgPicture.asset(
                                                'assets/svgs/like_outlined.svg',
                                                color: Pallete.greyColor,
                                              );
                                      },
                                    ),

                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.share_outlined,
                                        size: 25,
                                        color: Pallete.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 01),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Pallete.greyColor, thickness: 0.5),
                    ],
                  );
                },
                error: (error, stackTrace) =>
                    ErrorMessage(error: error.toString()),
                loading: () => Loader(),
              );
  }
}
