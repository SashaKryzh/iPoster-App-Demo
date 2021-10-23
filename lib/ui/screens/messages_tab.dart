import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/constants.dart';
import 'package:iposter_chat_demo/core/view_models/messages_page_view_model.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:iposter_chat_demo/ui/widgets/chat_tile.dart';
import 'package:iposter_chat_demo/ui/widgets/empty_list_placeholder.dart';
import 'package:provider/provider.dart';

class MessagesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Consumer<MessagesPageViewModel>(
        builder: (context, model, _) {
          // This post frame callback fixes this exception:
          // setState() or markNeedsBuild() called during build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            model.tabOpened();
          });

          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (model.chats.isEmpty || model.error != null) {
            return EmptyListPlaceholder(
              text: model.error ?? S.of(context).no_messages,
              onRefresh: model.onRefresh,
            );
          } else {
            return RefreshIndicator(
              onRefresh: model.onRefresh,
              child: Scrollbar(
                child: ListView.separated(
                  key: PageStorageKey('ChatsListView'),
                  padding: EdgeInsets.only(
                    left: kListHorizontalPadding,
                    right: kListHorizontalPadding,
                    top: kListVerticalPadding,
                    bottom: kListBottomPadding,
                  ),
                  itemCount: model.chats.length,
                  itemBuilder: (context, index) {
                    return ChatTile(
                      chat: model.chats[index],
                      onPressed: () => model.onChatPressed(index),
                      margin:
                          EdgeInsets.symmetric(vertical: kBetweenAdsPadding),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
