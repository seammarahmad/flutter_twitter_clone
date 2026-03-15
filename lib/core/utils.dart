import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/pallete.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

String getNamefromtheEmail(String email) {
  return email.split('@')[0];
}

Future<List<File>> pickImages() async {
  List<File> images = [];

  final ImagePicker picker = ImagePicker();
  final imagefiles = await picker.pickMultiImage();

  if (imagefiles != null) {
    for (final image in imagefiles) {
      images.add(File(image.path));
    }
  }
  return images;
}


Future<File?> pickImage() async {

  final ImagePicker picker = ImagePicker();
  final imagefiles = await picker.pickImage(source: ImageSource.gallery);

  if (imagefiles != null) {
      return File(imagefiles.path);
  }
  return null;
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Loader());
  }
}

class ErrorMessage extends StatelessWidget {
  final String error;

  const ErrorMessage({super.key, required String this.error});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error));
  }
}

class ErrorPage extends StatelessWidget {
  final String Error;

  const ErrorPage({super.key, required String this.Error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ErrorMessage(error: Error));
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Pallete.whiteColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Pallete.greyColor,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
class Failure {
  final String message;
  final StackTrace stackTrace;
  const Failure(this.message, this.stackTrace);
}
