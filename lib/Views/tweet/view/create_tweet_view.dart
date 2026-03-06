import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/constants/constants.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/theme/pallete.dart';

import '../../../core/utils.dart';

class CreateTweetView extends ConsumerStatefulWidget {
  static String id = 'create_tweet_view';

  const CreateTweetView({super.key});

  @override
  ConsumerState<CreateTweetView> createState() => _CreateTweetViewState();
}

class _CreateTweetViewState extends ConsumerState<CreateTweetView> {
  final tweettextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    tweettextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserdetailsProvider);

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, color: Pallete.whiteColor),
        ),
        actions: [
          RoundButton(
            colour: Pallete.blueColor,
            title: 'Tweet',
            onPress: () {},
            Size: 80.0,
          ),
        ],
      ),
      body: currentUser.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "User profile data not found in database. Please try logging out and signing up again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Pallete.blueColor,
                          backgroundImage: user.profilePic.isNotEmpty
                              ? NetworkImage(user.profilePic)
                              : null,
                          radius: 30,
                          child: user.profilePic.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 30.0,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),

                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: tweettextController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          decoration: const InputDecoration(
                            hintText: "What's happening?",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 10),
              Text(
                "Error: $error",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              TextButton(
                onPressed: () => ref.refresh(currentUserdetailsProvider),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 15.0),

        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Pallete.greyColor, width: 2.0)),
        ),

        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(
                8.0,
              ).copyWith(left: 15.0, right: 15.0),

              child: GestureDetector(
                onTap: () {
                  pickImages();
                },
                child: SvgPicture.asset('assets/svgs/gallery.svg'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(
                8.0,
              ).copyWith(left: 15.0, right: 15.0),

              child: SvgPicture.asset('assets/svgs/gif.svg'),
            ),

            Padding(
              padding: const EdgeInsets.all(
                8.0,
              ).copyWith(left: 15.0, right: 15.0),

              child: SvgPicture.asset('assets/svgs/emoji.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
