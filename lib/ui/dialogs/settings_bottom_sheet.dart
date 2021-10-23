import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';
import 'package:iposter_chat_demo/core/providers/app_localization_provider.dart';
import 'package:iposter_chat_demo/core/services/auth_service.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:iposter_chat_demo/ui/dialogs/custom_modal_bottom_shett.dart';
import 'package:provider/provider.dart';

class SettingsBottomSheet extends StatelessWidget {
  final void Function(String) onLocaleChanged;
  final void Function() onCabinet;
  final void Function() onPrivacyPolicy;
  final void Function() onFeedback;
  final void Function() onExit;

  SettingsBottomSheet({
    this.onLocaleChanged,
    this.onCabinet,
    this.onPrivacyPolicy,
    this.onFeedback,
    this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeProvider = Provider.of<AppLocalizationProvider>(context);

    Widget localeButton(key) {
      return TextButton(
        child: Text(key == AppLocalizationProvider.uaLocale ? 'Мова' : 'Язык'),
        onPressed: localeProvider.currentLocale == key
            ? null
            : () => onLocaleChanged(key),
      );
    }

    return CustomBottomSheet(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            color: Palette.green,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: FutureBuilder(
                      future: Provider.of<AuthService>(context)
                          .currentIPosterUser(),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data?.name ?? '',
                          style: theme.textTheme.headline6.copyWith(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.launch, color: Colors.white),
                ],
              ),
              onTap: onCabinet,
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            localeButton(AppLocalizationProvider.uaLocale),
            SizedBox(
              height: 20,
              child: VerticalDivider(),
            ),
            localeButton(AppLocalizationProvider.ruLocale),
          ],
        ),
        TextButton(
          child: Text(
            S.of(context).pravyla_korystuvannya,
          ),
          onPressed: onPrivacyPolicy,
        ),
        TextButton(
          child: Text(
            S.of(context).zvorotniy_zvyazok,
          ),
          onPressed: onFeedback,
        ),
        TextButton(
          child: Text(
            S.of(context).exit,
            style: TextStyle(color: Palette.red),
          ),
          onPressed: onExit,
        ),
      ],
    );
  }
}
