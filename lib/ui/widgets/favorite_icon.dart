import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';

/// Will rebuild to previous state if onPressed return false
class FavoriteIcon extends StatefulWidget {
  final Key key;
  final bool isFavorite;
  final Future<bool> Function() onPressed;

  FavoriteIcon({
    this.key,
    @required this.isFavorite,
    @required this.onPressed,
  }) : super(key: key);

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool isFavorite;

  @override
  void initState() {
    isFavorite = widget.isFavorite;
    super.initState();
  }

  void onPressed() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    final response = await widget.onPressed();
    if (response == false) {
      setState(() {
        isFavorite = !isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      color: isFavorite ? Palette.pink : Palette.black,
      onPressed: onPressed,
    );
  }
}

class FavoriteIconStateless extends StatelessWidget {
  final bool isFavorite;
  final Future<bool> Function() onPressed;

  FavoriteIconStateless({
    @required this.isFavorite,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      color: isFavorite ? Palette.pink : Palette.black,
      onPressed: onPressed,
    );
  }
}
