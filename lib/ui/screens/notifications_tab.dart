import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/constants.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';
import 'package:iposter_chat_demo/core/view_models/notifications_page_view_model.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:iposter_chat_demo/ui/widgets/empty_list_placeholder.dart';
import 'package:iposter_chat_demo/ui/widgets/notification_tile.dart';
import 'package:provider/provider.dart';

class NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget floatingActionButton() {
      return Selector<NotificationsPageViewModel, bool>(
        selector: (context, model) => model.unreadNotificationsCount > 0,
        builder: (context, isNotAllViewed, _) {
          if (isNotAllViewed) {
            return FloatingActionButton(
              child: Icon(Icons.remove_red_eye),
              foregroundColor: Palette.green,
              backgroundColor: Colors.white,
              onPressed: () => Provider.of<NotificationsPageViewModel>(context,
                      listen: false)
                  .viewAllNotifications(),
            );
          } else {
            return Container();
          }
        },
      );
    }

    Widget notificationsList(final model) {
      return RefreshIndicator(
        onRefresh: model.onRefresh,
        child: Scrollbar(
          child: ListView.separated(
            key: PageStorageKey('NotificationsListView'),
            padding: EdgeInsets.only(
              left: kListHorizontalPadding,
              right: kListHorizontalPadding,
              top: kListVerticalPadding,
              bottom: kListBottomPadding,
            ),
            itemCount:
                model.notifications.length + (model.isMoreToLoad ? 1 : 0),
            itemBuilder: (context, index) {
              if (model.isMoreToLoad && model.notifications.length == index) {
                model.loadNextPage();
                return SizedBox(
                  height: 60,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                final n = model.notifications[index];
                return NotificationTile(
                  n,
                  key: ValueKey('${n.id}-${n.isViewed}'),
                  onPressed: model.onNotificationPressed,
                  onLink: model.onLinkPressed,
                );
              }
            },
            separatorBuilder: (context, _) {
              return SizedBox(height: 10);
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: Consumer<NotificationsPageViewModel>(
        builder: (context, model, _) {
          // This post frame callback fixes this exception:
          // setState() or markNeedsBuild() called during build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            model.tabOpened();
          });

          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (model.notifications.isEmpty || model.error != null) {
            return EmptyListPlaceholder(
              text: model.error ?? S.of(context).no_notifications,
              onRefresh: model.onRefresh,
            );
          } else {
            return notificationsList(model);
          }
        },
      ),
      floatingActionButton: floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
