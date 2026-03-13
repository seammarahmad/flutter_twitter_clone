import 'package:flutter/material.dart';

import '../../../theme/pallete.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kTextStyle = TextStyle(
    color: Pallete.whiteColor,
    fontFamily: 'Poppins',
    fontSize: 15.0
);

InputDecoration kTextFieldDesign({required Color borderColor, required String hintTexts}) {
  return InputDecoration(
    hintText: hintTexts,
    hintStyle: const TextStyle(
        color: Pallete.greyColor,
        fontFamily: 'Poppins',
        fontSize: 10.0
    ),
    contentPadding:
    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: borderColor, width: 1.0),
      borderRadius: const BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: borderColor, width: 2.0),
      borderRadius: const BorderRadius.all(Radius.circular(32.0)),
    ),
  );
}

class RoundButton extends StatelessWidget {

  const RoundButton({super.key, required this.colour, required this.title, required this.onPress,required this.Size});

  final double Size;
  final Color colour;
  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),

      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),

        child: MaterialButton(
          onPressed:onPress,
          minWidth: this.Size,
          height: 42.0,
          child: Text(title, style: kTextStyle.copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}