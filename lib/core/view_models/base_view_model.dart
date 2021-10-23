import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/services/auth_service.dart';
import 'package:iposter_chat_demo/core/services/iposter_api/iposter_api.dart';
import 'package:provider/provider.dart';

class BaseViewModel extends ChangeNotifier {
  final BuildContext context;

  AuthService authService;
  iPosterApi iPosterAPI;

  BaseViewModel({@required this.context}) {
    authService = Provider.of<AuthService>(context, listen: false);
    iPosterAPI = Provider.of<iPosterApi>(context, listen: false);
  }
}
