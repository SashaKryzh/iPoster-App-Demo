
import 'package:flutter/material.dart';
import "package:iposter_chat_demo/core/constants/iposter_consts.dart";
import 'package:iposter_chat_demo/core/providers/app_localization_provider.dart';
import 'package:iposter_chat_demo/core/services/iposter_api/iposter_api.dart';
import 'package:iposter_chat_demo/core/view_models/base_view_model.dart';
import 'package:iposter_chat_demo/ui/dialogs/custom_modal_bottom_shett.dart';
import 'package:iposter_chat_demo/ui/dialogs/settings_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class HomePageViewModel extends BaseViewModel {
  HomePageViewModel(BuildContext context) : super(context: context);

  void onTitlePressed() async {
    urlLauncher.launch(
      await iPosterAPI.appendToken(iPosterApi.rootUrl),
      forceSafariVC: false,
    );
  }

  void onAccountPressed() {
    showCustomModalBottomSheet(
      context,
      SettingsBottomSheet(
        onLocaleChanged: onLocaleChanged,
        onCabinet: onCabinetPressed,
        onPrivacyPolicy: onPrivacyPolicyPressed,
        onFeedback: onFeedbackPressed,
        onExit: onExitPressed,
      ),
    );
  }

  void onLocaleChanged(String localeKey) {
    Provider.of<AppLocalizationProvider>(context, listen: false)
        .setLocale(localeKey);
  }

  void onCabinetPressed() async {
    Navigator.pop(context);
    urlLauncher.launch(
      'https://github.com/SashaKryzh',
      forceSafariVC: false,
    );
  }

  void onExitPressed() {
    Navigator.pop(context);
    authService.signOut();
  }

  void onPrivacyPolicyPressed() {
    urlLauncher.launch(iPoster.privacyPolicyLink);
  }

  void onFeedbackPressed() async {
    urlLauncher.launch('https://github.com/SashaKryzh');
  }
}
