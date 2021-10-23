import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';
import 'package:iposter_chat_demo/core/models/notification.dart' as notif;
import 'package:iposter_chat_demo/core/utils/date_string.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:iposter_chat_demo/ui/widgets/custom_card.dart';

class NotificationTile extends StatefulWidget {
  final notif.Notification n;
  final Future<bool> Function(notif.Notification) onPressed;
  final void Function(notif.Notification) onLink;

  NotificationTile(this.n, {Key key, this.onPressed, this.onLink})
      : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool isViewed;

  @override
  void initState() {
    isViewed = widget.n.isViewed;
    super.initState();
  }

  void onPressed() {
    setState(() {
      isViewed = true;
    });
    widget.onPressed(widget.n).then((isOk) {
      if (!isOk) {
        setState(() {
          isViewed = widget.n.isViewed;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
            bottom: 3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.n.title.isNotEmpty ? widget.n.title : '',
                    style: theme.textTheme.bodyText1.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  if (!isViewed)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.circle,
                        color: Palette.notificationRed,
                        size: 14,
                      ),
                    ),
                  Text(
                    dateToString(widget.n.dateAdd),
                    style: theme.textTheme.caption.copyWith(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                widget.n.text ?? '',
                style: theme.textTheme.bodyText2.copyWith(fontSize: 16),
              ),
              if (widget.n.link.isNotEmpty)
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => widget.onLink(widget.n),
                        child: Text(S.of(context).open_on_website),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(height: 9)
            ],
          ),
        ),
      ),
      onTap: onPressed,
    );
  }
}
