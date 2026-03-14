import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_twitter_clone/apis/userApi.dart';

import '../../../model/usermodel.dart';

final exploreControllerProvider =
StateNotifierProvider<ExploreController, bool>((ref) {
  return ExploreController(userAPI: ref.watch(userApiProvider));
});

final searchUserProvider = FutureProvider.family((ref, String name) async {
  if (name.isEmpty) return <UserModel>[];
  final controller = ref.watch(exploreControllerProvider.notifier);
  return controller.searchUser(name);
});

class ExploreController extends StateNotifier<bool> {
  final UserApi _userAPI;
  ExploreController({required UserApi userAPI})
      : _userAPI = userAPI,
        super(false);

  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userAPI.searchUserByName(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
