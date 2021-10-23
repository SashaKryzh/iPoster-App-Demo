import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;

  CustomCard({@required this.child, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kCardBorderRadius),
      child: Card(
        color: color,
        elevation: 0.1,
        margin: EdgeInsets.all(0),
        child: child,
      ),
    );
  }
}
