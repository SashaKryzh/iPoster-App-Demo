import 'package:intl/intl.dart';
import 'package:iposter_chat_demo/extensions/datetime_apis.dart';

String dateToString(DateTime date) {
  if (date.isToday()) {
    return DateFormat('HH:mm').format(date);
  } else if (date.isThisWeek() || date.isThisYear()) {
    return DateFormat('dd.MM').format(date);
  } else {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}
