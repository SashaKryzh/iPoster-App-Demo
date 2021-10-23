import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/constants.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';
import 'package:iposter_chat_demo/core/models/chat.dart';
import 'package:iposter_chat_demo/core/models/message.dart';
import 'package:iposter_chat_demo/core/utils/date_string.dart';
import 'package:iposter_chat_demo/core/view_models/chat_page_view_model.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:iposter_chat_demo/ui/widgets/empty_list_placeholder.dart';
import 'package:iposter_chat_demo/ui/widgets/keyboard_hider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ChatArguments {
  final Chat chat;

  ChatArguments({this.chat});
}

class ChatPage extends StatelessWidget {
  static const routeName = '/chat';

  final ChatArguments args;

  ChatPage({@required this.args});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatPageViewModel(context, chat: args.chat),
      child: Selector<ChatPageViewModel, Chat>(
        selector: (context, model) => model.chat,
        builder: (context, chat, _) {
          final model = Provider.of<ChatPageViewModel>(context, listen: false);

          return Scaffold(
            appBar: AppBar(
              elevation: kAppBarElevation,
              backgroundColor: Theme.of(context).primaryColor,
              title: GestureDetector(
                child: Text(chat.adUserName, style: TextStyle(color: Colors.black)),
                onTap: model.onUserNamePressed,
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: TextButton(
                  child: Text(chat.adTitle),
                  onPressed: model.onAdTitlePressed,
                ),
              ),
            ),
            body: _Body(),
            backgroundColor: Colors.white,
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget buildListView() {
      return Flexible(
        child: Selector<ChatPageViewModel, Tuple3<bool, String, int>>(
          selector: (context, model) => Tuple3<bool, String, int>(
              model.isLoading, model.error, model.messages.length),
          builder: (context, tuple, _) {
            final model =
                Provider.of<ChatPageViewModel>(context, listen: false);

            if (model.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (model.error != null) {
              return EmptyListPlaceholder(
                text: model.error,
                onRefresh: model.refresh,
                reverse: true,
              );
            } else {
              return Scrollbar(
                child: RefreshIndicator(
                  onRefresh: () =>
                      Provider.of<ChatPageViewModel>(context, listen: false)
                          .refresh(),
                  child: KeyboardHider(
                    child: ListView.separated(
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: kListHorizontalPadding,
                        vertical: kListVerticalPadding,
                      ),
                      itemCount: model.messages.length,
                      itemBuilder: (context, index) => _MessageListTile(
                        model.messages[index],
                      ),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          buildListView(),
          _Input(),
        ],
      ),
    );
  }
}

class _Input extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget buildTextField(BuildContext context) {
      return Expanded(
        child: TextField(
          controller: Provider.of<MessageInputViewModel>(context, listen: false)
              .controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            hintText: S.of(context).message,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
        ),
      );
    }

    Widget buildButton(BuildContext context) {
      final model = Provider.of<MessageInputViewModel>(context, listen: false);

      return Selector<MessageInputViewModel, MessageButtonType>(
        selector: (context, model) => model.buttonType,
        builder: (context, type, _) {
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 15),
              child: type == MessageButtonType.attach
                  ? Icon(Icons.attach_file)
                  : RotatedBox(
                      quarterTurns: 3,
                      child: Icon(Icons.send, color: Palette.green),
                    ),
            ),
            onTap: type == MessageButtonType.attach ? model.attach : model.send,
          );
        },
      );
    }

    return ChangeNotifierProvider.value(
      value:
          Provider.of<ChatPageViewModel>(context, listen: false).inputViewModel,
      builder: (context, _) {
        return Column(
          children: [
            Divider(height: 0),
            SizedBox(height: 8),
            Row(
              children: [
                SizedBox(width: kListHorizontalPadding),
                buildTextField(context),
                buildButton(context),
              ],
            ),
            SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

class _MessageListTile extends StatelessWidget {
  final Message message;

  _MessageListTile(this.message);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final borderRadius = 17.0;
    final messageWidth = MediaQuery.of(context).size.width * 0.7;
    const messageInnerPadding = 10.0;
    final imageSize =
        MediaQuery.of(context).size.width * 0.7 - messageInnerPadding * 2;

    Color boxColor;
    Color textColor;

    if (message.incoming) {
      boxColor = Colors.grey[200];
      textColor = Colors.black;
    } else {
      boxColor = Palette.green;
      textColor = Colors.white;
    }

    Widget buildDate() {
      return Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 5,
          right: 5,
        ),
        child: Text(
          dateToString(message.dateTime),
          style: theme.textTheme.caption,
        ),
      );
    }

    Widget buildImage(String image) {
      return GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        onTap: () {
          // Navigator.pushNamed(
          //   context,
          //   GalleryPage.routeName,
          //   arguments: GalleryArguments(
          //     images: message.images,
          //     initialIndex: message.images.indexOf(image),
          //   ),
          // );
        },
      );
    }

    Widget buildImages() {
      return Wrap(
        direction: Axis.vertical,
        spacing: 10,
        children: message.images.map((i) => buildImage(i)).toList(),
      );
    }

    return Column(
      crossAxisAlignment:
          message.incoming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 60,
            maxWidth: messageWidth,
            minHeight: 34,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              color: boxColor,
              child: Padding(
                padding: const EdgeInsets.all(messageInnerPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.message.isNotEmpty)
                      Text(
                        message.message,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 16,
                              color: textColor,
                            ),
                      ),
                    if (message.images.isNotEmpty)
                      Padding(
                        padding: message.message.isNotEmpty
                            ? EdgeInsets.only(top: 8.0)
                            : EdgeInsets.zero,
                        child: buildImages(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        buildDate(),
      ],
    );
  }
}
