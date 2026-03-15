import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/Views/User%20Profile/controller/user_profile_controller.dart';
import 'package:flutter_twitter_clone/core/utils.dart';

import '../../../model/usermodel.dart';
import '../../../theme/pallete.dart';
import '../../tweet/widget/tweet_card.dart';
import '../views/edit_profile_view.dart';
class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserdetailsProvider).value;
    final isCurrentUser = currentUser?.uid == user.uid;
    final isFollowing =
        currentUser?.following.contains(user.uid) ?? false;

    if (currentUser == null) return const Loader();

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            floating: false,
            backgroundColor: Pallete.backgroundColor,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Banner
                  user.bannerPic.isNotEmpty
                      ? Image.network(
                    user.bannerPic,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Pallete.blueColor.withOpacity(0.3),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Pallete.blueColor.withOpacity(0.6),
                          Pallete.greyColor.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),

                  // Gradient overlay
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0x40000000),
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 30),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar and follow button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Avatar
                      Transform.translate(
                        offset: const Offset(0, -30),
                        child:Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Pallete.backgroundColor,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: user.profilePic.isNotEmpty
                              ? Image.network(
                            user.profilePic,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.person, color: Pallete.greyColor),
                          )
                              : const Icon(Icons.person, color: Pallete.greyColor),
                        ),
                      ),

                      // Follow/Edit button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: isCurrentUser
                            ? OutlinedButton(
                          onPressed: () => Navigator.push(
                            context,
                            EditProfileView.route(),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Pallete.searchBarColor,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            'Edit profile',
                            style: TextStyle(
                              color: Pallete.whiteColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        )
                            : ElevatedButton(
                          onPressed: () {
                            ref
                                .read(userProfileControllerProvider
                                .notifier)
                                .followUser(
                              user: user,
                              context: context,
                              currentUser: currentUser,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFollowing
                                ? Colors.transparent
                                : Pallete.whiteColor,
                            foregroundColor: isFollowing
                                ? Pallete.whiteColor
                                : Pallete.backgroundColor,
                            side: isFollowing
                                ? const BorderSide(
                                color: Pallete.searchBarColor, width: 1.5)
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isFollowing ? 'Following' : 'Follow',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (user.isTwitterBlue)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: SvgPicture.asset(
                                  'assets/svgs/verified.svg',
                                  height: 18,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${user.name}',
                          style: const TextStyle(
                            color: Pallete.greyColor,
                            fontSize: 14,
                          ),
                        ),
                        if (user.bio.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            user.bio,
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),

                        // Stats row
                        Row(
                          children: [
                            _buildStat(user.following.length, 'Following'),
                            const SizedBox(width: 20),
                            _buildStat(user.followers.length, 'Followers'),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(
                          color: Pallete.searchBarColor,
                          height: 0.5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: ref.watch(getUserTweetsProvider(user.uid)).when(
        data: (tweets) {
          if (tweets.isEmpty) {
            return const EmptyStateWidget(
              title: 'No posts yet',
              subtitle: "This user hasn't posted anything yet",
              icon: Icons.article_outlined,
            );
          }
          return ListView.builder(
            itemCount: tweets.length,
            itemBuilder: (context, index) {
              return TweetCard(tweet: tweets[index]);
            },
          );
        },
        loading: () => const Loader(),
        error: (e, _) => ErrorMessage(error: e.toString()),
      ),
    );
  }

  Widget _buildStat(int count, String label) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$count',
            style: const TextStyle(
              color: Pallete.whiteColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: ' $label',
            style: const TextStyle(
              color: Pallete.greyColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
