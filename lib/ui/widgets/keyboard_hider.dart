import 'package:flutter/material.dart';

class KeyboardHider extends StatelessWidget {
  final Widget child;

  KeyboardHider({this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
