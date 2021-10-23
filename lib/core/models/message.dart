import 'package:intl/intl.dart';
import 'package:iposter_chat_demo/core/models/images.dart';

class Message {
  int dialogId;
  int adsId;
  String message;
  int userIdFrom;
  int userIdTo;
  List<String> images;
  bool incoming;
  DateTime dateTime;

  Message({
    this.dialogId,
    this.adsId,
    this.message = '',
    this.userIdFrom,
    this.userIdTo,
    this.images,
    this.incoming,
    this.dateTime,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Message(
      dialogId: json['id'],
      adsId: json['ads_id'],
      message: json['message'].toString(),
      userIdFrom: json['from'],
      userIdTo: json['to'],
      images: (json['images'] as List)
              ?.map((i) => iPosterImage(
                    name: (i as Map<String, dynamic>)['name'],
                    from: ImageFrom.message,
                  ))
              ?.toList() ??
          [],
      incoming: json['incoming'] == 1,
      dateTime: format.parse(json['date_add']),
    );
  }

  factory Message.toSend(int dialogId, int adsId,
      {String message, iPosterImage image}) {
    return Message(
      dialogId: dialogId,
      adsId: adsId,
      message: message ?? '',
      images: image != null ? [] : [],
      incoming: false,
      dateTime: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': dialogId,
      'ads_id': adsId,
      'message': message,
      'images': [],
    };
  }

  static List<Message> getMessages() {
    return [
      Message(
        dialogId: 42,
        adsId: 42,
        message: 'Я передумал покупать, лучше подожду iPhone 15.',
        images: [],
        incoming: false,
        dateTime: DateTime.now(),
      ),
      Message(
        dialogId: 42,
        adsId: 42,
        message: 'Ты тут?',
        images: [],
        incoming: true,
        dateTime: DateTime.now(),
      ),
      Message(
        dialogId: 42,
        adsId: 42,
        message: 'Так что? Согласен?',
        images: [],
        incoming: true,
        dateTime: DateTime.now(),
      ),
      Message(
        dialogId: 42,
        adsId: 42,
        message: 'Ок. Я подумаю...',
        images: [],
        incoming: false,
        dateTime: DateTime.now(),
      ),
      Message(
        dialogId: 42,
        adsId: 42,
        message: 'Совсем немного поцарапанный',
        images: [],
        incoming: true,
        dateTime: DateTime.now(),
      ),
      Message(
        dialogId: 42,
        adsId: 42,
        message: '',
        images: ['assets/iphone_12_2.jpg'],
        incoming: true,
        dateTime: DateTime.now(),
      ),
    ];
  }
}
