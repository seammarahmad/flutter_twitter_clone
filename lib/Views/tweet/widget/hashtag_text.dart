import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/theme/pallete.dart';

class HashtagText extends StatelessWidget {
  final String text;

  const HashtagText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> hashtags = [];
    List<String> textInSentence = text.split(RegExp(r'\s+'));

    for (String word in textInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(
          TextSpan(
            text: '$word ',
            style: TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (word.startsWith('https://') ||
          word.startsWith('www.') ||
          word.startsWith('http://')) {
        hashtags.add(
          TextSpan(
            text: '$word ',
            style: TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        hashtags.add(
          TextSpan(
            text: '$word ',
            style: TextStyle(fontSize: 18, color: Pallete.whiteColor),
          ),
        );
      }
    }

    return RichText(text: TextSpan(children: hashtags));
  }
}
