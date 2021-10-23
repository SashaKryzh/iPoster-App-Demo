import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/ui/screens/chat_page.dart';
import 'package:iposter_chat_demo/ui/screens/gallery_page.dart';
import 'package:iposter_chat_demo/ui/screens/home_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomePage.routeName:
      return MaterialPageRoute(builder: (_) => HomePage());

    case GalleryPage.routeName:
      return MaterialPageRoute(
          builder: (_) => GalleryPage(args: settings.arguments));

    case ChatPage.routeName:
      return MaterialPageRoute(
          builder: (_) => ChatPage(args: settings.arguments));

    default:
      return null;
  }
}
