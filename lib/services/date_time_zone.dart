import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatToLocal(String utcString) {
    try {
      DateTime utcTime = DateTime.parse(utcString);
      DateTime localTime = utcTime.toLocal();

      return DateFormat('MM-dd-yyyy hh:mm a').format(localTime);
    } catch (e) {
      return utcString; // fallback if parsing fails
    }
  }
}
