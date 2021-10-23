import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';

class WithHighlight extends StatelessWidget {
  final child;

  WithHighlight({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Palette.flutter_highlight_color,
      ),
      child: child,
    );
  }
}
