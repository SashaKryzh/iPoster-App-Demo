import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';
import 'package:iposter_chat_demo/core/constants/constants.dart';

class AppleSignInButton extends StatelessWidget {
  AppleSignInButton({this.onPressed});

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SocialSignInButton(
      title: 'Apple Sign In',
      onPressed: onPressed,
    );
  }
}

class SocialSignInButton extends StatelessWidget {
  SocialSignInButton({this.title, this.onPressed});

  final Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(kButtonBorderRadius)),
      ),
      padding: EdgeInsets.all(15),
      textColor: Palette.black,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("images/apple_logo.png"), height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Palette.black,
              ),
            ),
          )
        ],
      ),
      onPressed: onPressed,
    );
  }
}
