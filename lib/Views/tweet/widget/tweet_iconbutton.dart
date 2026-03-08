import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_twitter_clone/theme/pallete.dart';

class TweetIconbutton extends StatelessWidget {
  final String imgaddress;
  final String text;
  final VoidCallback onTap;

  const TweetIconbutton({
    super.key,
    required this.imgaddress,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(imgaddress, color: Pallete.greyColor),
          Container(
            margin: EdgeInsets.only(top: 5, left: 3),
            child: Text(text, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
