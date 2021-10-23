import 'package:flutter/foundation.dart';
import 'package:iposter_chat_demo/core/services/iposter_api/iposter_api.dart';

enum ImageFrom { ad, message }

class ImageUploadType {
  static const messageType = 2;
}

// ignore: camel_case_types
class iPosterImage {
  String name;
  ImageFrom from;

  String getUrl({bool full}) {
    if (from == ImageFrom.ad) {
      return iPosterApi.adImageUrl(name, full: full);
    } else {
      return iPosterApi.chatImageURL(name);
    }
  }

  iPosterImage({@required this.name, @required this.from});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
