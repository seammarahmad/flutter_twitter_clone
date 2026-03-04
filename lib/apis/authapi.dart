import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../core/provider.dart';

final authApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return Auth(account: account);
});

abstract class Authapi {
  Future<Either<String, User>> signup({
    required String email,
    required String password,
  });
  Future<Either<String, Session>> login({
    required String email,
    required String password,
  });

  Future<User?> currentUserAccount();
  Future<Either<String, void>> logout();
}

class Auth extends Authapi {
  final Account _account;

  Auth({required Account account}) : _account = account;

  @override
  Future<Either<String, User>> signup({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
          userId: ID.unique(), email: email, password: password);
      return right(account);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Session>> login(
      {required String email, required String password}) async {
    try {
      final session = await _account.createEmailPasswordSession(
          email: email, password: password);
      return right(session);
    } catch (e) {
      return left("Error in Login: " + e.toString());
    }
  }

  @override
  Future<User?> currentUserAccount() async {
    try {
      return await _account.get();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }
}
