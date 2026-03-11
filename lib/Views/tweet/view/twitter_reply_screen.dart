import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/config/environment.dart';
import 'package:flutter_twitter_clone/core/utils.dart';
import '../../../model/tweet_model.dart';
import '../../../theme/pallete.dart';
import '../controller/tweet_controller.dart';
import '../widget/tweet_card.dart';

class TwitterReplyScreen extends ConsumerStatefulWidget {
  static route(Tweet tweet) =>
      MaterialPageRoute(builder: (context) => TwitterReplyScreen(tweet: tweet));
  final Tweet tweet;

  const TwitterReplyScreen({super.key, required this.tweet});

  @override
  ConsumerState<TwitterReplyScreen> createState() => _TwitterReplyScreenState();
}

class _TwitterReplyScreenState extends ConsumerState<TwitterReplyScreen> {
  final _replyController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _replyController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitReply() {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;
    ref
        .read(TweetControllerProvider.notifier)
        .shareTweet(
          images: [],
          text: text,
          context: context,
          repliedTo: widget.tweet.id,
          repliedToUserId: widget.tweet.uid,
        );
    _replyController.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserdetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Post'),
      ),
      body: Column(
        children: [
          // Original tweet
          TweetCard(tweet: widget.tweet),

          // Replies divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Replies',
                  style: TextStyle(
                    color: Pallete.greyColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(height: 0.5, color: Pallete.blueColor),
                ),
              ],
            ),
          ),

          // Replies list
          Expanded(
            child: ref
                .watch(getRepliesToTweetsProvider(widget.tweet))
                .when(
                  data: (replies) {
                    if (replies.isEmpty) {
                      return const EmptyStateWidget(
                        title: 'No replies yet',
                        subtitle: 'Be the first to reply!',
                        icon: Icons.chat_bubble_outline_rounded,
                      );
                    }

                    // Apply realtime updates safely
                    return ref
                        .watch(getlatestTweetProvider)
                        .when(
                          data: (data) {
                            final allReplies = List<Tweet>.from(replies);
                            _applyRealtimeUpdate(data, allReplies);
                            return _buildRepliesList(allReplies);
                          },
                          loading: () => _buildRepliesList(replies),
                          error: (_, __) => _buildRepliesList(replies),
                        );
                  },
                  loading: () => const Loader(),
                  error: (e, _) => ErrorMessage(error: e.toString()),
                ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Pallete.blueColor, width: 0.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              if (currentUser != null) _buildMiniAvatar(currentUser.profilePic),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _replyController,
                  focusNode: _focusNode,
                  style: const TextStyle(
                    color: Pallete.whiteColor,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Post your reply',
                    hintStyle: const TextStyle(
                      color: Pallete.greyColor,
                      fontSize: 15,
                    ),
                    filled: true,
                    fillColor: Pallete.searchBarColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _submitReply(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _submitReply,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Pallete.blueColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applyRealtimeUpdate(dynamic data, List<Tweet> replies) {
    try {
      final events = List<String>.from(data.events as List);
      final isCreate = events.any(
        (e) => e.contains(
          'databases.*.collections.${Environment.appwriteTweetcollectionId}.documents.*.create',
        ),
      );
      final isUpdate = events.any(
        (e) => e.contains(
          'databases.*.collections.${Environment.appwriteTweetcollectionId}.documents.*.update',
        ),
      );

      final payload = Map<String, dynamic>.from(data.payload as Map);
      final incoming = Tweet.fromMap(payload);

      if (incoming.repliedTo != widget.tweet.id) return;

      if (isCreate) {
        if (!replies.any((t) => t.id == incoming.id)) {
          replies.add(incoming);
        }
      } else if (isUpdate) {
        final idx = replies.indexWhere((t) => t.id == incoming.id);
        if (idx != -1) replies[idx] = incoming;
      }
    } catch (_) {}
  }

  Widget _buildRepliesList(List<Tweet> replies) {
    return ListView.builder(
      itemCount: replies.length,
      itemBuilder: (context, index) {
        return TweetCard(tweet: replies[index]);
      },
    );
  }

  Widget _buildMiniAvatar(String profilePic) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Pallete.searchBarColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: profilePic.isNotEmpty
          ? Image.network(profilePic, fit: BoxFit.cover)
          : const Icon(Icons.person, color: Pallete.greyColor, size: 20),
    );
  }
}
