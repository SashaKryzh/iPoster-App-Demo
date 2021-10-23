import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iposter_chat_demo/core/view_models/home_page_view_model.dart';
import 'package:iposter_chat_demo/core/view_models/messages_page_view_model.dart';
import 'package:iposter_chat_demo/core/view_models/notifications_page_view_model.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:iposter_chat_demo/ui/screens/messages_tab.dart';
import 'package:iposter_chat_demo/ui/screens/notifications_tab.dart';
import 'package:iposter_chat_demo/ui/widgets/custom_tab.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomePageViewModel(context)),
        ChangeNotifierProvider(
            create: (context) => MessagesPageViewModel(context)),
        ChangeNotifierProvider(
            create: (context) => NotificationsPageViewModel(context)),
      ],
      child: Consumer<HomePageViewModel>(
        builder: (context, model, _) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: GestureDetector(
                  child: Text('iPoster.ua (Demo)', style: TextStyle(color: Colors.black)),
                  onTap: model.onTitlePressed,
                ),
                centerTitle: false,
                actions: [
                  IconButton(
                    color: Colors.blue,
                    icon: SvgPicture.asset(
                      'assets/profile_icon.svg',
                      height: 22,
                    ),
                    onPressed: model.onAccountPressed,
                  )
                ],
                bottom: TabBar(
                  tabs: [
                    Selector<MessagesPageViewModel, bool>(
                      selector: (_, model) => model.newMessagesCount > 0,
                      builder: (context, isNew, _) {
                        return CustomTab(
                          text: S.of(context).povidomlennya,
                          badge: isNew,
                        );
                      },
                    ),
                    Selector<NotificationsPageViewModel, bool>(
                      selector: (_, model) =>
                          model.unreadNotificationsCount > 0,
                      builder: (context, isUnread, _) {
                        return CustomTab(
                          text: S.of(context).notifications,
                          badge: isUnread,
                        );
                      },
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  MessagesTab(),
                  NotificationsTab(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
