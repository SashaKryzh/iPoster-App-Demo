import 'package:intl/intl.dart';

class Notification {
  final int id;
  final String title;
  final String text;
  final DateTime dateAdd;
  final String link;
  final bool openInApp;

  bool _viewed;

  bool get isViewed => _viewed;

  void setViewed() => _viewed = true;

  Notification({
    this.id,
    this.title,
    this.text,
    this.dateAdd,
    this.link,
    this.openInApp,
    viewed,
  }) : _viewed = viewed;

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      title: json['title'],
      text: json['text'],
      dateAdd: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json['date_add']),
      link: json['link'].toString(),
      openInApp: json['open_app'] == 1,
      viewed: json['viewed'] == 1,
    );
  }

  static List<Notification> getNotifications() {
    return [
      Notification(
        id: 42,
        title: 'Ответ на все',
        text: '42',
        dateAdd: DateTime(2021, 09, 28),
        link: 'https://github.com/SashaKryzh',
        openInApp: true,
        viewed: false,
      ),
       Notification(
        id: 42,
        title: 'Бонусы',
        text: 'Поздравляем! Вы выиграли 69 бонусов!',
        dateAdd: DateTime(2021, 09, 28),
        link: 'https://github.com/SashaKryzh',
        openInApp: true,
        viewed: true,
      ),
      Notification(
        id: 42,
        title: 'Объявления',
        text: 'Закончилось время показа. Пожалуйста, обновите Ваше объявление',
        dateAdd: DateTime(2021, 09, 28),
        link: 'https://github.com/SashaKryzh',
        openInApp: true,
        viewed: true,
      ),
      Notification(
        id: 42,
        title: 'Лимит',
        text: 'Вы достигли лимита объявлений.',
        dateAdd: DateTime(2021, 09, 28),
        link: 'https://github.com/SashaKryzh',
        openInApp: true,
        viewed: true,
      ),
      Notification(
        id: 42,
        title: 'Счет',
        text: 'Пополнение счета прошло успешно. Ваш текущий баланс - 1111 грн',
        dateAdd: DateTime(2021, 09, 28),
        link: 'https://github.com/SashaKryzh',
        openInApp: true,
        viewed: true,
      ),
    ];
  }
}
