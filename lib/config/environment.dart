import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get appwriteProjectId =>
      dotenv.env['APPWRITE_PROJECT_ID']!;

  static String get appwritePublicEndpoint =>
      dotenv.env['APPWRITE_PUBLIC_ENDPOINT']!;

  static String get appwriteDatabaseID =>
      dotenv.env['APPWRITE_DATABASE_ID']!;

  static String get appwriteUserCollectionId =>
      dotenv.env['APPWRITE_USER_COLLECTION_ID']!;

  static String get appwriteTweetcollectionId =>
      dotenv.env['APPWRITE_TWEET_COLLECTION_ID']!;

  static String get appwriteNotificationcollectionId =>
      dotenv.env['APPWRITE_NOTIFICATION_COLLECTION_ID']!;

  static String get appwriteStorageBucketID =>
      dotenv.env['APPWRITE_STORAGE_BUCKET_ID']!;

  static String imageurl(String image) {
    return '$appwritePublicEndpoint/storage/buckets/$appwriteStorageBucketID/files/$image/view?project=$appwriteProjectId&mode=admin';
  }
}