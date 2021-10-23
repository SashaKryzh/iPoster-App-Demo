import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';

class NotifyIcon extends StatefulWidget {
  final Key key;
  final bool isNotify;
  final Future<bool> Function() onPressed;

  NotifyIcon({
    this.key,
    @required this.isNotify,
    @required this.onPressed,
  }) : super(key: key);

  @override
  _NotifyIconState createState() => _NotifyIconState();
}

class _NotifyIconState extends State<NotifyIcon> {
  bool isNotify;

  @override
  void initState() {
    isNotify = widget.isNotify;
    super.initState();
  }

  void onPressed() async {
    setState(() {
      isNotify = !isNotify;
    });

    final response = await widget.onPressed();
    if (response == false) {
      setState(() {
        isNotify = !isNotify;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:
          Icon(isNotify ? Icons.notifications_active : Icons.notifications_off),
      color: isNotify ? Palette.green : Theme.of(context).errorColor,
      onPressed: onPressed,
    );
  }
}
