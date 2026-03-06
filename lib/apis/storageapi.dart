import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/config/environment.dart';
import 'package:flutter_twitter_clone/core/provider.dart';

final StorageAPIProvider = Provider((ref) {
  return StorageAPI(storage: ref.read(appWriteStorageProvider));
});



class StorageAPI {
  final Storage _storage;

  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImages(List<File> files) async {
    List<String> imageUrls = [];

    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: Environment.appwriteStorageBucketID,
        fileId: ID.unique(),
        file: InputFile(path: file.path),
      );
      imageUrls.add(Environment.imageurl(uploadedImage.$id));
    }
    return imageUrls;
  }
}
