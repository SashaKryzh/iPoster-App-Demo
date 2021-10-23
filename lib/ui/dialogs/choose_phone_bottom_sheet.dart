import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iposter_chat_demo/core/utils/call_sms.dart';
import 'package:string_mask/string_mask.dart';

/// return 'copy' if user copied the phone
Future onChoosePhone(BuildContext context, List<String> phones,
    {bool notify = true}) async {
  if (phones == null) return;
  return await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    )),
    builder: (_) => ChoosePhoneBottomSheet(phones),
  );
}

class ChoosePhoneBottomSheet extends StatelessWidget {
  final List<String> phones;

  final mask = StringMask('0 (00) 000 00 00');

  ChoosePhoneBottomSheet(this.phones);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final delay = Duration(milliseconds: 200);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: phones.map((p) {
          return ListTile(
            leading: Icon(Icons.phone),
            title: Text(mask.apply(p),
                style: theme.textTheme.bodyText2.copyWith(
                  fontSize: 20,
                  color: theme.accentColor,
                )),
            trailing: IconButton(
              icon: Icon(Icons.content_copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: p));
                Future.delayed(delay, () {
                  Navigator.pop(context, 'copy');
                });
              },
            ),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(delay, () {
                CallSMS.call(p);
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
