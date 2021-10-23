import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/models/chat.dart';
import 'package:iposter_chat_demo/core/view_models/base_view_model.dart';
import 'package:iposter_chat_demo/ui/screens/chat_page.dart';

class MessagesPageViewModel extends BaseViewModel {
  bool inited = false;

  int newMessagesCount = 0;

  bool isLoading = true;
  String error;

  List<Chat> _chats = [];

  List<Chat> get chats => List.unmodifiable(_chats);

  MessagesPageViewModel(BuildContext context) : super(context: context) {
    // checkNewMessages();
  }

  // will this return the number of new messages or the number of chats with new messages??
  // Unused anymore
  // Future checkNewMessages() async {
  //   try {
  //     newMessagesCount = await iPosterAPI.getUnreadMessagesCount();
  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  void tabOpened() {
    if (!inited) {
      load();
      inited = true;
    }
  }

  Future load({showLoading = true}) async {
    error = null;
    isLoading = true;
    if (showLoading) notifyListeners();

    try {
      _chats = await iPosterAPI.getChats();

      newMessagesCount = 0;
      _chats.forEach((chat) {
        if (chat.isNewMessages(authService.userId)) newMessagesCount++;
      });
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future onRefresh() {
    _chats.clear();
    return load(showLoading: false);
  }

  void onChatPressed(int chatIndex) {
    final chat = _chats[chatIndex];
    Navigator.pushNamed(
      context,
      ChatPage.routeName,
      arguments: ChatArguments(chat: chat),
    );

    if (chat.isNewMessages(authService.userId)) {
      chat.setViewed();
      newMessagesCount--;
    }

    notifyListeners();
  }
}
