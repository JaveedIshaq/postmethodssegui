import 'package:easy_localization/easy_localization.dart';
import 'package:mobile/core/extensions/log_extension.dart';

String formatDate(DateTime dateTime) {
  try {
    // Define the desired date format
    final dateFormat = DateFormat('MM/dd HH:mm');

    // Format the DateTime object using the defined format
    return dateFormat.format(dateTime);
  } catch (e) {
    "$e".log();

    "error formatting passed date: $dateTime".log();
    return '';
  }
}

String getCreatedAt(String dateString) {
  try {
    // Parse the input date string to a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object to the desired format
    String formattedDate = DateFormat('yyyy/MM/dd').format(dateTime);

    return formattedDate;
  } catch (e) {
    "$e".log();

    "error formatting passed date: $dateString".log();
    return '';
  }
}

String formatDateGetMonthYear(String dateTimeString) {
  try {
    // Parse the string into a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Define the desired date format
    final dateFormat = DateFormat('MM/yy');

    // Format the DateTime object using the defined format
    return dateFormat.format(dateTime);
  } catch (e) {
    "$e".log();
    "error formatting passed date: $dateTimeString".log();
    return '';
  }
}

String formatNumberWithCommas(String numberString) {
  try {
    final number = int.tryParse(numberString) ?? 0;
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  } catch (e) {
    "$e".log();
    "error formatting passed Number String: $numberString".log();
    return '';
  }
}
