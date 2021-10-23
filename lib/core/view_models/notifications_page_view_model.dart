import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/view_models/base_view_model.dart';
import 'package:iposter_chat_demo/core/models/notification.dart' as notif;
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class NotificationsPageViewModel extends BaseViewModel {
  bool inited = false;

  static const int _limit = 20;
  int _currentPage = 0;

  bool _isMoreToLoad = true;
  bool get isMoreToLoad => _isMoreToLoad;

  int _unreadNotificationsCount;
  int get unreadNotificationsCount => _unreadNotificationsCount ?? -1;

  bool isLoading = true;
  String error;
  List<notif.Notification> notifications = [];

  NotificationsPageViewModel(BuildContext context) : super(context: context) {
    _getUnreadNotificationsCount();
  }

  void tabOpened() {
    if (!inited) {
      inited = true;
      _load(_currentPage, append: false);
    }
  }

  Future _getUnreadNotificationsCount() async {
    try {
      _unreadNotificationsCount =
          await iPosterAPI.getUnreadNotificationsCount();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  /// page: 0, 1, 2, 3...
  Future _load(int page,
      {bool showFullScreenProgress = true, bool append = true}) async {
    int calculateOffset(int page) {
      return page * _limit;
    }

    error = null;
    if (showFullScreenProgress) {
      notifyListeners();
      isLoading = true;
    }

    try {
      final result = await iPosterAPI.getNotifications(
        _limit,
        calculateOffset(page),
      );
      _isMoreToLoad = false;
      notifications = append ? notifications + result : result;
    } catch (e) {
      print(e);
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future loadNextPage() {
    return _load((++_currentPage), showFullScreenProgress: false);
  }

  Future onRefresh() async {
    _getUnreadNotificationsCount();
    return _load((_currentPage = 0),
        showFullScreenProgress: false, append: false);
  }

  Future<bool> onNotificationPressed(notif.Notification n) async {
    if (n.isViewed) return true;

    try {
      final isOk = await iPosterAPI.setNotificationViewed(n.id);
      if (isOk) n.setViewed();
      _unreadNotificationsCount--;
      notifyListeners();
      return isOk;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future setAllNotificationsViewed() async {
    try {
      final isOk = await iPosterAPI.setNotificationViewed(null, viewAll: true);
      if (isOk) {
        notifications.forEach((n) => n.setViewed());
        _unreadNotificationsCount = 0;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  void onLinkPressed(notif.Notification n) async {
    onNotificationPressed(n);
    final link = await iPosterAPI.appendToken(n.link);
    if (await urlLauncher.canLaunch(link)) {
      urlLauncher.launch(link, forceSafariVC: n.openInApp);
    }
  }

  void viewAllNotifications() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).view_all_notifications),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).ni),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(S.of(context).tak),
          ),
        ],
      ),
    );
    if (result ?? false) setAllNotificationsViewed();
  }
}
