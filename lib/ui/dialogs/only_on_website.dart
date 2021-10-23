import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/constants.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';

Future showOnlyOnWebsiteDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => OnlyOnWebsiteDialog(),
  );
}

class OnlyOnWebsiteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.sentiment_satisfied,
            size: 40,
            color: Theme.of(context).accentColor,
          ),
          SizedBox(height: 20),
          Text(
            'This is function is availible only on website',
            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 18),
          ),
          SizedBox(height: kListSpaceBig),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text(S.of(context).ok),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
