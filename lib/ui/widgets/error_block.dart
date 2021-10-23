import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/constants.dart';

class ErrorBlock extends StatelessWidget {
  final String text;

  ErrorBlock({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).errorColor,
        borderRadius: BorderRadius.all(Radius.circular(kButtonBorderRadius)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
