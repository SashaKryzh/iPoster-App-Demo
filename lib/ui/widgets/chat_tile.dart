import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/constants.dart';
import 'package:iposter_chat_demo/core/constants/icons.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';
import 'package:iposter_chat_demo/core/models/chat.dart';
import 'package:iposter_chat_demo/core/services/auth_service.dart';
import 'package:iposter_chat_demo/core/utils/date_string.dart';
import 'package:provider/provider.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;
  final void Function() onPressed;
  final EdgeInsets margin;

  ChatTile({
    @required this.chat,
    this.onPressed,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final theme = Theme.of(context);

    final height = 100.0;
    final iconHeight = 14.0;

    return Padding(
      padding: margin,
      child: GestureDetector(
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              SizedBox(
                width: height - 10,
                height: height,
                child: chat.imageURL != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(chat.imageURL, fit: BoxFit.cover),
                      )
                    : Center(child: Icon(noImageIcon)),
              ),
              SizedBox(width: kCardInnerPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            chat.adUserName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                theme.textTheme.caption.copyWith(fontSize: 14),
                          ),
                        ),
                        if (chat.isNewMessages(auth.userId))
                          Icon(
                            Icons.circle,
                            color: Palette.notificationRed,
                            size: iconHeight,
                          )
                        else if (chat.isFromMe(auth.userId))
                          Icon(
                            chat.isUserViewedMyMessage(auth.userId)
                                ? Icons.done_all
                                : Icons.done,
                            color: Palette.green,
                            size: iconHeight,
                          ),
                        SizedBox(width: 5),
                        Text(
                          dateToString(chat.lastMessageTime),
                          style: theme.textTheme.caption.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Expanded(
                      flex: 0,
                      child: Text(
                        chat.adTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: theme.textTheme.bodyText2.copyWith(
                          color: Palette.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    Expanded(
                      child: Text(
                        chat.lastMessage,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.caption.copyWith(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        behavior: HitTestBehavior.translucent,
        onTap: onPressed,
      ),
    );
  }
}
