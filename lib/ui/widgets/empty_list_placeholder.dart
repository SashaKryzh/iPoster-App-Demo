import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';

class EmptyListPlaceholder extends StatefulWidget {
  final String text;
  final Future Function() onRefresh;
  final bool reverse;

  EmptyListPlaceholder({this.text, this.onRefresh, this.reverse = false});

  @override
  _EmptyListPlaceholderState createState() => _EmptyListPlaceholderState();
}

class _EmptyListPlaceholderState extends State<EmptyListPlaceholder> {
  bool isRefreshing = false;
  Future future;

  Future onRefresh() {
    setState(() {
      isRefreshing = true;
    });
    if (future == null) {
      future = widget.onRefresh()
        ..then((_) {
          setState(() {
            isRefreshing = false;
          });
          future = null;
        });
    }
    return future;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget refreshIndicator() {
      return Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        ),
      );
    }

    Widget refreshButton() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(100),
        ),
        child: IconButton(
          icon: Icon(
            Icons.refresh_outlined,
            color: Palette.green,
          ),
          onPressed: onRefresh,
        ),
      );
    }

    Widget centerElement() {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.text ?? S.of(context).empty,
            style: theme.textTheme.bodyText2.copyWith(fontSize: 16),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 60,
            width: 60,
            child: isRefreshing ? refreshIndicator() : refreshButton(),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              reverse: widget.reverse,
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  child: centerElement(),
                  height: constraints.maxHeight,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
