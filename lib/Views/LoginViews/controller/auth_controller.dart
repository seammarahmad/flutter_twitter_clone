import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_twitter_clone/Views/HomeScreen/View/home_view.dart';
import 'package:flutter_twitter_clone/apis/authapi.dart';
import 'package:flutter_twitter_clone/apis/userApi.dart';
import 'package:flutter_twitter_clone/core/utils.dart';
import 'package:flutter_twitter_clone/model/usermodel.dart';
import 'package:riverpod/src/framework.dart';

final authControllerprovider = StateNotifierProvider<AuthController, bool>((
  ref,
) {
  return AuthController(
    authapi: ref.watch(authApiProvider),
    userApi: ref.watch(userApiProvider),
  );
});

final currentUserAccountProvider = FutureProvider((ref) {
  final account = ref.watch(authControllerprovider.notifier);
  return account.currentUserAccount();
});

class AuthController extends StateNotifier<bool> {
  final Auth _authapi;
  final UserApi _userApi;

  AuthController({required Auth authapi, required UserApi userApi})
    : _authapi = authapi,
      _userApi = userApi,
      super(false);

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
          uid: '',
          bio: '',
          isTwitterBlue: false,
        );
        final res2 = await _userApi.saveUserData(userModel: userModel);

        res2.fold((l) => showSnackBar(context, l), (r) {
          showSnackBar(context, 'Login Successfully');
          Navigator.pushNamed(context, HomePage.id);
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
        (r) => Navigator.pushNamed(context, HomePage.id),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      state = false;
    }
  }

  Future<User?> currentUserAccount() async {
    return _authapi.currentUserAccount();
  }
}
