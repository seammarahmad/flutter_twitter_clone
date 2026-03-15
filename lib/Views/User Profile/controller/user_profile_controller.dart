import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_twitter_clone/apis/storageapi.dart';
import 'package:flutter_twitter_clone/apis/tweetApi.dart';
import 'package:flutter_twitter_clone/apis/userApi.dart';

import '../../../core/enum/notification_enum.dart';
import '../../../core/utils.dart';
import '../../../model/tweet_model.dart';
import '../../../model/usermodel.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
      return UserProfileController(
        tweetAPI: ref.watch(TweetApiProvider),
        storageAPI: ref.watch(StorageAPIProvider),
        userAPI: ref.watch(userApiProvider),
        // notificationController:
        // ref.watch(notificationControllerProvider.notifier),
      );
    });

final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  final controller = ref.watch(userProfileControllerProvider.notifier);
  return controller.getUserTweets(uid);
});

final getLatestUserProfileDataProvider = StreamProvider((ref) {
  return ref.watch(userApiProvider).getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final Tweetapi _tweetAPI;
  final StorageAPI _storageAPI;
  final UserApi _userAPI;

  // final NotificationController _notificationController;

  UserProfileController({
    required Tweetapi tweetAPI,
    required StorageAPI storageAPI,
    required UserApi userAPI,
    // required NotificationController notificationController,
  }) : _tweetAPI = tweetAPI,
       _storageAPI = storageAPI,
       _userAPI = userAPI,
       // _notificationController = notificationController,
       super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    UserModel updated = userModel;

    if (bannerFile != null) {
      final bannerUrl = await _storageAPI.uploadImages([bannerFile]);
      updated = updated.copyWith(bannerPic: bannerUrl[0]);
    }

    if (profileFile != null) {
      final profileUrl = await _storageAPI.uploadImages([profileFile]);
      updated = updated.copyWith(profilePic: profileUrl[0]);
    }

    final res = await _userAPI.updateUserData(updated);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Profile updated!');
      Navigator.pop(context);
    });
  }

  void followUser({
    required UserModel user,
    required BuildContext context,
    required UserModel currentUser,
  }) async {
    final isFollowing = currentUser.following.contains(user.uid);

    if (isFollowing) {
      user.followers.remove(currentUser.uid);
      currentUser.following.remove(user.uid);
    } else {
      user.followers.add(currentUser.uid);
      currentUser.following.add(user.uid);
    }

    user = user.copyWith(followers: user.followers);
    currentUser = currentUser.copyWith(following: currentUser.following);
    final res = await _userAPI.followUser(user);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      final res2 = await _userAPI.addToFollowing(currentUser);
      res2.fold((l) => showSnackBar(context, l.message), (onRight) => null);
    });

    //   final res = await _userAPI.followUser(updatedUser);
    //   res.fold((l) => showSnackBar(context, l.message), (r) async {
    //     final res2 = await _userAPI.addToFollowing(updatedCurrent);
    //     res2.fold((l) => showSnackBar(context, l.message), (r) {
    //       if (!isFollowing) {
    //         _notificationController.createNotification(
    //           text: '${currentUser.name} started following you',
    //           postId: '',
    //           notificationType: NotificationType.follow,
    //           uid: user.uid,
    //           fromUserId: currentUser.uid,
    //         );
    //       }
    //     });
    //   });
  }
}
