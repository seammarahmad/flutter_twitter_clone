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

///Auth Provider
final currentUserdetailsProvider =
FutureProvider<UserModel?>((ref) async {

  final controller =
  ref.read(authControllerprovider.notifier);

  final account = await controller.currentUserAccount();

  if (account == null) {
    print("No logged in user");
    return null;
  }

  print("Fetching Data for the user + ${account.$id}");

  final user = await controller.getUserData(account.$id);

  return user;
});

final currentUserAccountProvider = FutureProvider<User?>((ref) async {
  final account = ref.watch(authControllerprovider.notifier);
  return account.currentUserAccount();
});

final userDetailsProvider = FutureProvider.family((ref, String uid) async {
  final account = ref.watch(authControllerprovider.notifier);
  return account.getUserData(uid);
});

///Auth Controller Start From Here
final authControllerprovider = StateNotifierProvider<AuthController, bool>((
  ref,
) {
  return AuthController(
    authapi: ref.watch(authApiProvider),
    userApi: ref.watch(userApiProvider),
  );
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
          uid: r.$id,
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
    final user =_authapi.currentUserAccount();
    print("Current User : $user");
    return user;
  }

  Future<UserModel> getUserData(String uid) async {
    print('Fetching Data for the user + $uid');
    final document = await _userApi.getUserData(uid);
    return UserModel.fromMap(document.data);
  }
}
