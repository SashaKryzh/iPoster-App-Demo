import 'package:flutter/material.dart';

class EndOfListProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
