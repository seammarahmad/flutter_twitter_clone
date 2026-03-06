class Environment {
  static const String appwriteProjectId = '6988c91d0038984a63a1';
  static const String appwritePublicEndpoint =
      'https://fra.cloud.appwrite.io/v1';
  static const String appwriteDatabaseID = '69983e44002753c747e1';
  static const String collectionId = 'user';

  static const String appwriteTweetcollectionId = 'tweets';

  static const String appwriteStorageBucketID = '69ab3ce10039132e52d1';

  static String imageurl(String image) {
    return '$appwritePublicEndpoint/storage/buckets/$appwriteStorageBucketID/files/$image/view?project=$appwriteProjectId&mode=admin';
  }
}
