import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/Views/HomeScreen/View/home_view.dart';
import 'package:flutter_twitter_clone/apis/authapi.dart';
import 'package:flutter_twitter_clone/apis/userApi.dart';
import 'package:flutter_twitter_clone/core/utils.dart';
import 'package:flutter_twitter_clone/model/usermodel.dart';

/// Provides the current Appwrite account
final currentUserAccountProvider = FutureProvider<User?>((ref) async {
  final authApi = ref.watch(authApiProvider);
  return await authApi.currentUserAccount();
});

/// Provides the current User details from the database
final currentUserdetailsProvider = FutureProvider<UserModel?>((ref) async {
  final userAccount = await ref.watch(currentUserAccountProvider.future);

  if (userAccount == null) return null;

  final userApi = ref.watch(userApiProvider);

  try {
    final document = await userApi.getUserData(userAccount.$id);
    return UserModel.fromMap(document.data);
  } on AppwriteException catch (e) {
    // Only attempt to create a document if it's explicitly NOT FOUND (404)
    if (e.code == 404) {
      debugPrint('User document not found (404), creating default for ${userAccount.$id}');
      
      UserModel userModel = UserModel(
        email: userAccount.email,
        name: userAccount.name.isNotEmpty ? userAccount.name : getNamefromtheEmail(userAccount.email),
        followers: [],
        following: [],
        profilePic: '',
        bannerPic: '',
        uid: userAccount.$id,
        bio: '',
        isTwitterBlue: false,
      );

      final res = await userApi.saveUserData(userModel: userModel);
      return res.fold(
        (l) {
          // If creation fails with 409, it means it was created by another process or exists
          if (l.contains('409')) {
             return userModel;
          }
          throw l;
        },
        (r) => userModel,
      );
    }
    
    // If it's a permission error (403/401), rethrow so the UI can show a proper error
    debugPrint('Appwrite Error (${e.code}): ${e.message}');
    rethrow;
  } catch (e) {
    rethrow;
  }
});

final userDetailsProvider = FutureProvider.family((ref, String uid) async {
  final userApi = ref.watch(userApiProvider);
  final document = await userApi.getUserData(uid);
  return UserModel.fromMap(document.data);
});

final authControllerprovider = NotifierProvider<AuthController, bool>(() {
  return AuthController();
});

class AuthController extends Notifier<bool> {
  late Auth _authapi;
  late UserApi _userApi;

  @override
  bool build() {
    _authapi = ref.watch(authApiProvider);
    _userApi = ref.watch(userApiProvider);
    return false;
  }

  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      state = true;
      final res = await _authapi.signup(email: email, password: password);
      res.fold((l) => showSnackBar(context, l), (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: getNamefromtheEmail(email),
          followers: [],
          following: [],
          profilePic: '',
          bannerPic: '',
          uid: r.$id,
          bio: '',
          isTwitterBlue: false,
        );
        final res2 = await _userApi.saveUserData(userModel: userModel);

        res2.fold((l) => showSnackBar(context, l), (r) {
          showSnackBar(context, 'Account created successfully');
          ref.invalidate(currentUserAccountProvider);
          Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
        });
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      state = false;
    }
  }

  Future<void> Login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      state = true;
      final res = await _authapi.login(email: email, password: password);
      res.fold(
        (l) => showSnackBar(context, l),
        (r) {
          ref.invalidate(currentUserAccountProvider);
          Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
        }
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      state = false;
    }
  }

  Future<void> logout(BuildContext context) async {
    final res = await _authapi.logout();
    
    ref.invalidate(currentUserAccountProvider);
    ref.invalidate(currentUserdetailsProvider);
    
    res.fold(
      (l) {
        if (l.contains('unauthorized_scope')) {
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        } else {
          showSnackBar(context, l);
        }
      },
      (r) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      },
    );
  }
}
