import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';

String emailValidator(BuildContext context, String email) {
  return EmailValidator.validate(email) ? null : S.of(context).input_email;
}

String passwordValidator(BuildContext context, String password) {
  return password.isNotEmpty ? null : S.of(context).vvedit_parol;
}

String nameValidator(BuildContext context, String name) {
  return name.isNotEmpty ? null : S.of(context).vkazhit_vashe_imya;
}

String phoneValidator(BuildContext context, String phone) {
  if (phone.isEmpty || phone.length == 16) {
    return null;
  } else {
    return S.of(context).input_your_phone;
  }
}
