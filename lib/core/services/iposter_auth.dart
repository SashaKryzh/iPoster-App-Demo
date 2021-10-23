import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:iposter_chat_demo/core/models/iposter_user.dart';
import 'package:iposter_chat_demo/core/providers/app_localization_provider.dart';
import 'package:iposter_chat_demo/core/utils/handle_dio_error.dart';

// ignore: camel_case_types
class iPosterAuthResponse {
  bool success;
  String message;
  String token;
  iPosterAuthUser user;

  iPosterAuthResponse({this.success, this.message, this.token, this.user});

  factory iPosterAuthResponse.fromJson() {
    return iPosterAuthResponse(
      success: true,
      message: null,
      token: 'token',
      user: iPosterAuthUser.fromJson(),
    );
  }

  factory iPosterAuthResponse.error(String error) {
    return iPosterAuthResponse(
      success: false,
      message: error,
    );
  }
}

class _UserInfo {
  String token;
  int id;

  _UserInfo({this.token, this.id});

  factory _UserInfo.fromJson(Map<String, dynamic> json) {
    return _UserInfo(token: json['token'], id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'id': id};
  }
}

// ignore: camel_case_types
class iPosterAuth {
  static const _rootUrl = 'https://iposter.ua';
  static const _userInfoKey = 'iPosterUserInfoKey';

  AppLocalizationProvider localeProvider;

  final _secureStorage = storage.FlutterSecureStorage();
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://iposter.ua',
      responseType: ResponseType.json,
    ),
  );

  iPosterAuthUser _currentUser;
  _UserInfo _info;

  String get token => _info?.token;
  int get userId => _info?.id;

  iPosterAuth();

  set setLocaleProvider(AppLocalizationProvider provider) {
    localeProvider = provider;
    localeProvider.addListener(updateLocaleUrl);
    updateLocaleUrl();
  }

  void updateDioHeaders() {
    _dio.options.headers = {
      HttpHeaders.authorizationHeader: _info?.token,
    };
  }

  void updateLocaleUrl() {
    _dio.options.baseUrl = _rootUrl +
        (localeProvider.currentLocale == AppLocalizationProvider.uaLocale
            ? ''
            : '/ru');
  }

  Future<_UserInfo> _loadUserInfo() async {
    final data = await _secureStorage.read(key: _userInfoKey);
    if (data != null) {
      _updateUserInfo(_UserInfo.fromJson(jsonDecode(data)));
      return _info;
    } else {
      return null;
    }
  }

  void _updateUserInfo(_UserInfo info) {
    _info = info;
    updateDioHeaders();
    if (_info != null) {
      _secureStorage.write(key: _userInfoKey, value: jsonEncode(_info));
    } else {
      _secureStorage.delete(key: _userInfoKey);
    }
  }

  Future<bool> isSignedIn() async {
    final isSignedIn = await _loadUserInfo() != null;
    if (isSignedIn) currentUser();
    return isSignedIn;
  }

  Future<iPosterAuthUser> currentUser({bool update = false}) async {
    if (update == false && _currentUser != null) {
      return _currentUser;
    } else {
      try {
        _currentUser =
            iPosterAuthResponse.fromJson().user;
        return _currentUser;
      } catch (error) {
        print(error);
        throw handleDioError(error);
      }
    }
  }

  Future<iPosterAuthResponse> editUser(iPosterAuthUser newUser) async {
    try {
      return iPosterAuthResponse.fromJson();
    } catch (e) {
      print(e);
      throw handleDioError(e);
    }
  }

  Future<iPosterAuthResponse> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = iPosterAuthResponse.fromJson();
      _currentUser = result.user;
      _updateUserInfo(_UserInfo(token: result.token, id: _currentUser.id));
      return result;
    } on DioError catch (error) {
      print(error);
      throw handleDioError(error);
    }
  }

  Future<iPosterAuthResponse> signInWithFirebaseToken(String token) async {
    try {
      final result = iPosterAuthResponse.fromJson();
      _currentUser = result.user;
      _updateUserInfo(_UserInfo(token: result.token, id: _currentUser.id));
      return result;
    } on DioError catch (error) {
      print(error);
      throw handleDioError(error);
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    _updateUserInfo(null);
  }
}
