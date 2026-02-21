import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_twitter_clone/Views/HomeScreen/View/home_view.dart';
import 'package:flutter_twitter_clone/apis/authapi.dart';
import 'package:flutter_twitter_clone/core/utils.dart';
import 'package:riverpod/src/framework.dart';

final authControllerprovider = StateNotifierProvider<AuthController, bool>((
  ref,
) {
  return AuthController(authapi: ref.watch(authApiProvider));
});

class AuthController extends StateNotifier<bool> {
  final Auth _authapi;

  AuthController({required Auth authapi}) : _authapi = authapi, super(false);

  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      state = true;
      final res = await _authapi.signup(email: email, password: password);
      res.fold((l) => showSnackBar(context, l), (r) => Navigator.pushNamed(context, HomePage.id));
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
      res.fold((l) => showSnackBar(context, l), (r) => Navigator.pushNamed(context, HomePage.id));
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      state = false;
    }
  }
}
