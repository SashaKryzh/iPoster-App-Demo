import 'package:flutter/foundation.dart';

class Chat {
  int dialogId;
  int adsId;
  int userId;
  String adTitle;
  String adUserName;
  String lastMessage;
  DateTime lastMessageTime;
  int userIdFrom;
  int userIdTo;
  bool viewed;
  String adsURL;
  String _imageURL;

  String get imageURL => _imageURL != '' ? _imageURL : null;

  Chat({
    @required this.dialogId,
    @required this.adsId,
    @required this.userId,
    @required this.adTitle,
    @required this.adUserName,
    this.lastMessage,
    this.lastMessageTime,
    this.userIdFrom,
    this.userIdTo,
    this.viewed,
    this.adsURL,
    imageURL,
  }) : _imageURL = imageURL;

  void setViewed() {
    viewed = true;
  }

  bool isFromMe(int myId) {
    return myId == userIdFrom;
  }

  bool isUserViewedMyMessage(int myId) {
    return isFromMe(myId) && viewed;
  }

  /// Is new messages for me
  bool isNewMessages(int myId) {
    return myId == userIdTo && viewed == false;
  }

  factory Chat.fromJson() {
    return Chat(
      dialogId: 42,
        adsId: 42,
        userId: 42,
        adTitle: 'iPhone 12 Pro Max 256GB Pacific Blue БУ',
        adUserName: 'Ivan Ivanov',
    );
  }

  static List<Chat> getChats() {
    return [
      Chat(
        dialogId: 42,
        adsId: 42,
        userId: 42,
        adTitle: 'iPhone 12 Pro Max 256GB Pacific Blue',
        adUserName: 'Иван Иванов',
        lastMessage: 'Я передумал покупать, лучше подожду iPhone 15.',
        lastMessageTime: DateTime(2021, 10, 10),
        userIdFrom: 42,
        userIdTo: 69,
        viewed: false,
        adsURL: 'https://github.com/SashaKryzh',
        imageURL: 'assets/iphone_12.jpg',
      ),
      Chat(
        dialogId: 42,
        adsId: 42,
        userId: 42,
        adTitle: 'iPad Pro (2021) 12.9" 512GB Space Gray Wi-Fi',
        adUserName: 'Иван Иванов',
        lastMessage: 'Летом очень жарко, нужно подождать осени...',
        lastMessageTime: DateTime(2021, 06, 01),
        userIdFrom: 69,
        userIdTo: 42,
        viewed: true,
        adsURL: 'https://github.com/SashaKryzh',
        imageURL: 'assets/ipad.jpg',
      ),
      Chat(
        dialogId: 42,
        adsId: 42,
        userId: 42,
        adTitle: 'iPhone 8 Plus 64GB Space Gray БУ',
        adUserName: 'Иван Иванов',
        lastMessage: 'Добрый день! А можно у Вас спросить?',
        lastMessageTime: DateTime(2021, 03, 29),
        userIdFrom: 42,
        userIdTo: 42,
        viewed: true,
        adsURL: 'https://github.com/SashaKryzh',
        imageURL: 'assets/iphone_8.jpg',
      ),
      Chat(
        dialogId: 42,
        adsId: 42,
        userId: 42,
        adTitle: 'MacBook Pro 13" 2019 БУ',
        adUserName: 'Иван Иванов',
        lastMessage: 'С Днем рожденья, SashaKryzh!!!',
        lastMessageTime: DateTime(2021, 03, 28),
        userIdFrom: 42,
        userIdTo: 42,
        viewed: true,
        adsURL: 'https://github.com/SashaKryzh',
        imageURL: 'assets/macbook_pro.jpg',
      ),
      Chat(
        dialogId: 42,
        adsId: 42,
        userId: 42,
        adTitle: 'Наушники AirPods Pro. Почти новые!',
        adUserName: 'Иван Иванов',
        lastMessage: 'Ну шо? Опять сидишь один?',
        lastMessageTime: DateTime(2021, 2, 14),
        userIdFrom: 42,
        userIdTo: 42,
        viewed: true,
        adsURL: 'https://github.com/SashaKryzh',
        imageURL: 'assets/airpods.jpg',
      ),
      Chat(
        dialogId: 42,
        adsId: 42,
        userId: 42,
        adTitle: 'Mac 27" 5k 2015',
        adUserName: 'Иван Иванов',
        lastMessage: 'С Новым годом!',
        lastMessageTime: DateTime(2020, 12, 12),
        userIdFrom: 69,
        userIdTo: 42,
        viewed: true,
        adsURL: 'https://github.com/SashaKryzh',
        imageURL: 'assets/imac.jpg',
      ),
    ];
  }
}
