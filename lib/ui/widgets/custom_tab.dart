import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';

class CustomTab extends StatelessWidget {
  final String text;
  final bool badge;

  CustomTab({this.text, this.badge});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          if (badge)
            Row(
              children: [
                SizedBox(width: 3),
                Container(
                  decoration: BoxDecoration(
                    color: Palette.notificationRed,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  height: 12,
                  width: 12,
                  // child: Center(
                  //   child: Text(
                  //     '!',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 8,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
