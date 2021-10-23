import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliverAppBarWithTabs extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final TabBar tabBar;
  final Widget leading;

  @override
  final Size preferredSize;

  SliverAppBarWithTabs({
    @required this.title,
    @required this.tabBar,
    this.leading,
  }) : preferredSize = Size.fromHeight(96);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: Column(
        children: <Widget>[
          CupertinoNavigationBar(
            heroTag: Key(title),
            transitionBetweenRoutes: false,
            middle: Text(title),
            leading: leading,
            border: null,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          Expanded(child: Container()),
          tabBar,
        ],
      ),
    );
  }
}
