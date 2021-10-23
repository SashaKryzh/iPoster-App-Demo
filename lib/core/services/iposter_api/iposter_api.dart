import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/models/chat.dart';
import 'package:iposter_chat_demo/core/models/iposter_user.dart';
import 'package:iposter_chat_demo/core/models/message.dart';
import 'package:iposter_chat_demo/core/models/notification.dart' as notif;
import 'package:iposter_chat_demo/core/providers/app_localization_provider.dart';
import 'package:iposter_chat_demo/core/services/auth_service.dart';
import 'package:iposter_chat_demo/core/services/iposter_api/iposter_api_responses.dart';
import 'package:iposter_chat_demo/core/utils/handle_dio_error.dart';

// ignore: camel_case_types
class iPosterApi {
  static const rootUrl = 'https://iposter.ua';

  final _dio = Dio(
    BaseOptions(
      baseUrl: rootUrl,
      responseType: ResponseType.json,
    ),
  );

  String get baseUrl => _dio.options.baseUrl;

  final AuthService authService;
  final AppLocalizationProvider localeProvider;

  iPosterApi({@required this.authService, @required this.localeProvider}) {
    authService.addListener(updateAuthToken);
    updateAuthToken();
    localeProvider.addListener(updateLocaleUrl);
    updateLocaleUrl();
  }

  static String smallImageURL(String imageName) {
    return rootUrl + '/a/$imageName';
  }

  static String fullImageURL(String imageName) {
    return rootUrl + '/a/$imageName';
  }

  static String adImageUrl(String imageName, {bool full}) {
    return full ? fullImageURL(imageName) : smallImageURL(imageName);
  }

  static String chatImageURL(String imageName) {
    return rootUrl + '/a/$imageName';
  }

  void updateAuthToken() async {
    final token =
        authService.authState == AuthState.SIGNED_IN ? authService.token : null;
    _dio.options.headers = {
      HttpHeaders.authorizationHeader: token,
    };
  }

  void updateLocaleUrl() {
    _dio.options.baseUrl = rootUrl +
        (localeProvider.currentLocale == AppLocalizationProvider.uaLocale
            ? ''
            : '/ru');
  }

  Future<String> appendToken(String url) async {
    return url;
    // final response = await _dio.get('/token');
    // final json = jsonDecode(response.data);
    // if (json['success']) {
    //   final oneTimeToken = json['token'];
    //   return url + '?t=$oneTimeToken';
    // } else {
    //   throw 'Failed to get one time token';
    // }
  }

  Future<String> userUrl(int id) async {
    return await appendToken(rootUrl + '/user-$id');
  }

  Future<String> adUrl(String adUrl) async {
    return await appendToken(rootUrl + '/$adUrl');
  }

  Future<String> settingsUrl() async {
    return await appendToken(rootUrl + '/settings');
  }

  Future<String> feedbackUrl({int adId}) async {
    return await appendToken(
      _dio.options.baseUrl + '/feedback' + (adId != null ? '-$adId' : ''),
    );
  }

  static iPosterResponse parseiPosterResponse(String responseBody) {
    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    return iPosterResponse.fromJson(json);
  }

  Future<iPosterUser> getUser(int userId) async {
    try {
      final response = await _dio.post(
        '/users',
        data: {'user_id': userId},
      );
      return compute(parseUser, response.data.toString());
    } catch (error) {
      throw handleDioError(error);
    }
  }

  static iPosterUser parseUser(String responseBody) {
    return iPosterUser.fullFromJson(jsonDecode(responseBody));
  }

  Future<int> getUnreadMessagesCount() async {
    try {
      return int.parse((await _dio.get('/unread')).data);
    } catch (error) {
      throw handleDioError(error);
    }
  }

  Future<List<Chat>> getChats() async {
    try {
      return compute(parseChats, '');
    } catch (error) {
      throw handleDioError(error);
    }
  }

  static List<Chat> parseChats(String responseBody) {
    return Chat.getChats();
  }

  Future<List<Message>> getMessages(int adsId, int userId) async {
    try {
      // final response = await _dio.post('3424', data: {
      //   'ads_id': adsId,
      //   'user_id': userId,
      // });
      return compute(parseMessages, 'response.data.toString()');
    } catch (error) {
      throw handleDioError(error);
    }
  }

  static List<Message> parseMessages(String responseBody) {
    // final json = jsonDecode(responseBody) as List;
    return Message.getMessages();
  }

  Future<iPosterResponse> sendMessage(Message message) async {
    try {
      final response = await _dio.post(
        '/message',
        data: jsonEncode(message),
      );
      return parseiPosterResponse(response.data.toString());
    } catch (error) {
      print(error);
      throw handleDioError(error);
    }
  }

  Future<String> uploadImage(File image, int imageUploadType) async {
    try {
      final response = await _dio.post(
        '/upload',
        data: FormData.fromMap({
          'image': await MultipartFile.fromFile(image.path, filename: 'img'),
          'type': imageUploadType,
        }),
      );
      final list = response.data['link'] as List;
      final map = list.first as Map<String, dynamic>;
      return map['image_name'];
    } catch (error) {
      print(error);
      throw handleDioError(error);
    }
  }

  Future<int> getUnreadNotificationsCount() async {
    return 0;
    // try {
    //   final response = await _dio.post('/notice', data: {'count': 1});
    //   return jsonDecode(response.data)['unread'];
    // } catch (e) {
    //   print(e);
    //   throw handleDioError(e);
    // }
  }

  Future<List<notif.Notification>> getNotifications(
      int limit, int offset) async {
    try {
      return await compute(parseNotifications, '');
    } catch (error) {
      print(error);
      throw handleDioError(error);
    }
  }

  static List<notif.Notification> parseNotifications(String responseBody) {
    return notif.Notification.getNotifications();
  }

  Future<bool> setNotificationViewed(int id, {bool viewAll = false}) async {
    if (id == null && viewAll == false) throw 'Error';
    try {
      final response = await _dio.post(
        '/notice-viewed',
        data: {'id': id},
      );
      return response.statusCode == HttpStatus.ok;
    } catch (error) {
      print(error);
      throw handleDioError(error);
    }
  }

  Future<bool> saveFCMToken(String token, bool isSignedIn) async {
    try {
      final response = await _dio.post('token-status', data: {
        'token': token,
        'signed_in': isSignedIn ? 1 : 0,
      });
      return response.statusCode == HttpStatus.ok;
    } catch (error) {
      print(error);
      throw handleDioError(error);
    }
  }
}
