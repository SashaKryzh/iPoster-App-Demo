import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class CallSMS {
  static Future call(String phone) async {
    final url = 'tel:$phone';

    if (await urlLauncher.canLaunch(url)) {
      urlLauncher.launch(url);
    } else {
      print('Could not call');
    }
  }

  static Future sms(String phone) async {
    final url = 'sms:$phone';

    if (await urlLauncher.canLaunch(url)) {
      urlLauncher.launch(url);
    } else {
      print('Could not open messenger');
    }
  }
}
