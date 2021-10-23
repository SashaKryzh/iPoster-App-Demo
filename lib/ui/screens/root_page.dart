import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/services/app_notifications.dart';
import 'package:iposter_chat_demo/core/services/auth_service.dart';
import 'package:iposter_chat_demo/globals.dart';
import 'package:iposter_chat_demo/ui/screens/home_page.dart';
import 'package:iposter_chat_demo/ui/screens/not_determined_page.dart';
import 'package:iposter_chat_demo/ui/screens/sign_in_page.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<AppNotifications>(context, listen: false).init(context);
    localeContext = context;

    // Added Scaffold here becase some function can use Scaffold.of(context)...
    return Scaffold(
      body: Selector<AuthService, AuthState>(
        selector: (_, p) => p.authState,
        builder: (context, value, _) {
          switch (value) {
            case AuthState.NOT_DETERMINED:
              return NotDeterminedPage();
            case AuthState.NOT_SIGNED_IN:
              return SignInPage();
            case AuthState.SIGNED_IN:
              return HomePage();
            default:
              // Something is definitly very wrong...
              return Container();
          }
        },
      ),
    );
  }
}
