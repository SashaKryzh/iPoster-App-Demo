import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/services/auth_service.dart';
// import 'package:iposter_chat_demo/core/services/iposter_api/iposter_api.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class AppNotifications {
  // final _firebaseMessaging = FirebaseMessaging.instance;
  // final _firestore = FirebaseFirestore.instance;

  bool _inited = false;

  BuildContext _context;

  AuthService _authService;
  // iPosterApi _iPosterAPI;

  // int _userId;

  /// Context should be under MaterialApp widget
  void init(BuildContext context) {
    if (_inited) return;
    _inited = true;

    _context = context;
    _authService = Provider.of<AuthService>(context, listen: false);
    // _iPosterAPI = Provider.of<iPosterApi>(context, listen: false);

    // We only need to update token on Refersh if user is signed in
    // _firebaseMessaging.onTokenRefresh.listen((token) {
    //   if (_authService.authState == AuthState.SIGNED_IN)
    //     _updateTokenInfo(_authService.userId, token, true);
    // });

    // Update token info when authStated changed
    _authService.addListener(_authStateChanged);

    requestPermissions();
    configure();
    // To be sure that we updated token info
    _authStateChanged();
  }

  // Я так понял, что это штуку никак не затестить.
  // Но если мы не открываем страницу при уведомлении про новое сообщение,
  // то там это и не нужно.
  Future checkInitialMessage() async {
    // RemoteMessage msg = await FirebaseMessaging.instance.getInitialMessage();
    // if (msg != null) {
    //   print('onInitialMessage');
    // }
  }

  void configure() {
    // Foreground
    // FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
    //   print('onMessage');
    //   showNotification(msg);
    // });

    // // Opened from background
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
    //   print('onMessageOpenedApp');
    // });
  }

  void requestPermissions() async {
    // final permissions = await _firebaseMessaging.requestPermission();
    // print("Notifications: ${permissions.authorizationStatus}");
  }

  // Updates token's info on Firebase (signed_in / signed_out)
  void _authStateChanged() async {
    // final token = await FirebaseMessaging.instance.getToken();

    // switch (_authService.authState) {
    //   case AuthState.SIGNED_IN:
    //     _userId = _authService.userId;
    //     _updateTokenInfo(_userId, token, true);
    //     break;

    //   case AuthState.NOT_SIGNED_IN:
    //     if (_userId != null) _updateTokenInfo(_userId, token, false);
    //     _userId = null;
    //     break;

    //   default:
    //     break;
    // }
  }

  // void _updateTokenInfo(int userId, String token, bool isSignedIn) async {
  //   print('Token $token (signed in: $isSignedIn)');

  //   try {
  //     final response = await _iPosterAPI.saveFCMToken(token, isSignedIn);
  //     print('Save token to database: success: $response');

      // Commented because we dont use firebase anymore
      // if (token != null) {
      //   var tokenRef = _firestore
      //       .collection('users')
      //       .doc('$userId')
      //       .collection('fcm_tokens')
      //       .doc(token);

      //   tokenRef.set({
      //     'signed_in': isSignedIn,
      //     'update_time': FieldValue.serverTimestamp(),
      //   });
      // }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Пока нигде не используем
  void _processMessage(void msg) {
    if ("msg.data['chat_id']".isEmpty ?? false) {
      print("msg.data['chat_id']");
    } else {
      print('Nothing to do with notification');
    }
  }

  void showNotification(void msg) {
    showDialog(
      context: _context,
      builder: (context) => AlertDialog(
        title: Text("msg.notification.title"),
        contentPadding: EdgeInsets.only(
          top: 15,
          right: 25,
          bottom: 5,
          left: 25,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("msg.notification.body"),
            SizedBox(
              child: TextButton(
                child: Text(S.of(context).ok),
                onPressed: () {
                  Navigator.of(context).pop();
                  _processMessage(msg);
                },
              ),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
