// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iposter_chat_demo/core/providers/app_localization_provider.dart';
import 'package:iposter_chat_demo/core/services/app_notifications.dart';
import 'package:iposter_chat_demo/core/services/auth_service.dart';
import 'package:iposter_chat_demo/core/services/iposter_api/iposter_api.dart';
import 'package:iposter_chat_demo/core/utils/on_generate_route.dart';
import 'package:iposter_chat_demo/core/utils/theme.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:iposter_chat_demo/ui/screens/root_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();

  // Always call await init before running the app
  final appLocalizationProvider = AppLocalizationProvider();
  await appLocalizationProvider.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: appLocalizationProvider),
    ],
    builder: (context, _) {
      return App();
    },
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Accessing provider here so the interface will rebuild on notifyListeners
    final localeProvider = Provider.of<AppLocalizationProvider>(context);

    return ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      builder: (context, _) {
        // AppNotifications().init(context);
        final authService = Provider.of<AuthService>(context, listen: false);
        authService.setLocaleProvider = localeProvider;

        return MultiProvider(
          providers: [
            Provider(
              create: (_) => iPosterApi(
                authService: authService,
                localeProvider: localeProvider,
              ),
              lazy: false,
            ),
            Provider(
              create: (_) => AppNotifications(),
              lazy: false,
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              // Adding cupertino because there is a bug with a long press on TextField
              // https://github.com/flutter/flutter/issues/43050
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: localeProvider.getPrefferedLocale(),
            title: 'iPoster.ua (Demo)',
            theme: theme,
            onGenerateRoute: onGenerateRoute,
            home: RootPage(),
          ),
        );
      },
    );
  }
}
