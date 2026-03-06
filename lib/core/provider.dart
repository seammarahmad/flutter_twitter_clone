import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/config/environment.dart';

final appwriteClientProvider = Provider((ref) {
  Client client = Client();
  return client
      .setEndpoint(Environment.appwritePublicEndpoint)
      .setProject(Environment.appwriteProjectId)
      .setSelfSigned(status: true);
});

final appwriteAccountProvider = Provider((ref) {
  final client=ref.watch(appwriteClientProvider);
  return Account(client);
});

final appWriteDatabaseProvider=Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
});

final appWriteStorageProvider=Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
});