import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/Views/tweet/view/hashtag_view.dart';
import 'package:flutter_twitter_clone/theme/pallete.dart';

class HashtagText extends StatelessWidget {
  final String text;

  const HashtagText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];
    
    // Updated Regex to better catch hashtags and URLs
    final RegExp combinedRegex = RegExp(
      r'((?:https?:\/\/|www\.)[^\s]+)|(#[a-zA-Z0-9_]+)',
      caseSensitive: false,
    );

    int lastMatchEnd = 0;
    
    for (final Match match in combinedRegex.allMatches(text)) {
      // Add preceding normal text
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: const TextStyle(
              fontSize: 18,
              color: Pallete.whiteColor,
            ),
          ),
        );
      }

      final String matchedText = match.group(0)!;
      
      if (matchedText.startsWith('#')) {
        // Hashtag
        spans.add(
          TextSpan(
            text: matchedText,
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(context, HashtagView.route(matchedText));
              },
          ),
        );
      } else {
        // URL
        spans.add(
          TextSpan(
            text: matchedText,
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
            ),
          ),
        );
      }
      
      lastMatchEnd = match.end;
    }

    // Add remaining normal text
    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: const TextStyle(
            fontSize: 18,
            color: Pallete.whiteColor,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(height: 1.3), // Better line height
        children: spans,
      ),
    );
  }
}
