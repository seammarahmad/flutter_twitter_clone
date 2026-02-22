import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

String getNamefromtheEmail(String email) {
 return email.split('@')[0];
}


class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}


class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Loader(),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final String error;
  const ErrorMessage({super.key,required String this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}

class ErrorPage extends StatelessWidget {

  final String Error;

  const ErrorPage({super.key,required String this.Error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorMessage(error: Error),
    );
  }
}


