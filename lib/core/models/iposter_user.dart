import 'package:flutter/foundation.dart';

// ignore: camel_case_types
class iPosterUser {
  final int id;
  final String name;
  String city;
  List<String> phones;

  iPosterUser({@required this.id, @required this.name, this.city, this.phones});

  factory iPosterUser.fromJson(Map<String, dynamic> json) {
    return iPosterUser(
      id: 42,
      name: 'Some name',
      city: 'City',
    );
  }

  factory iPosterUser.fullFromJson(Map<String, dynamic> json) {
    final user = iPosterUser.fromJson(json);
    user.parseFullJson(json);
    return user;
  }

  void parseFullJson(Map<String, dynamic> json) {
    phones = (json['phones'] as List).map((p) => '0' + p.toString()).toList();
  }
}

// ignore: camel_case_types
class iPosterAuthUser {
  int id;
  String name;
  List<String> phones;

  String getPhone(int index) {
    if (index < phones.length) {
      return phones[index];
    } else {
      return '';
    }
  }

  iPosterAuthUser({this.id, this.name, this.phones});

  factory iPosterAuthUser.fromJson() {
    return iPosterAuthUser(
      id: 42,
      name: 'Alexander',
      phones: ['0982016288'],
    );
  }

  Map<String, dynamic> toJson() {
    String phone1;
    String phone2;
    String phone3;

    if (phones.length > 0) {
      phone1 = phones.elementAt(0);
      if (phones.length > 1) {
        phone2 = phones.elementAt(1);
        if (phones.length > 2) {
          phone3 = phones.elementAt(2);
        }
      }
    }

    return {
      'user_name': name,
      'phone_1': phone1 ?? '',
      'phone_2': phone2 ?? '',
      'phone_3': phone3 ?? '',
    };
  }
}
