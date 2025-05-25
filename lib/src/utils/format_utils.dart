import 'package:intl/intl.dart';
import './logging_utils.dart';

/// A utility class for formatting data like time, date, and numbers.
/// All methods are static as per the guidelines.
class FormatUtils {
  // Private constructor to prevent instantiation.
  FormatUtils._();

  // --- Time Formatting ---

  /// Formats a DateTime object into a time string with a custom separator.
  /// e.g., "14:30:55" using the default separator ':'.
  static String formatTimeSymbolSeparated(
    DateTime time, {
    String separator = ':',
  }) {
    // Using DateFormat for robust time formatting.
    final formatter = DateFormat('HH${separator}mm${separator}ss');
    final formattedTime = formatter.format(time);
    LoggingUtils.debug(
      'Formatted time with symbol separator: *$formattedTime*',
    );
    return formattedTime;
  }

  /// Formats a DateTime object into a Chinese time string.
  /// e.g., "14时30分55秒".
  static String formatTimeChineseSeparated(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');
    final formattedTime = '$hour时$minute分$second秒';
    LoggingUtils.debug(
      'Formatted time with Chinese separator: *$formattedTime*',
    );
    return formattedTime;
  }

  // --- Date Formatting ---

  /// Formats a DateTime object into a date string with a custom separator.
  /// e.g., "2023-10-27" using the default separator '-'.
  static String formatDateSymbolSeparated(
    DateTime date, {
    String separator = '-',
  }) {
    final formatter = DateFormat('yyyy${separator}MM${separator}dd');
    final formattedDate = formatter.format(date);
    LoggingUtils.debug(
      'Formatted date with symbol separator: *$formattedDate*',
    );
    return formattedDate;
  }

  /// Formats a DateTime object into a Chinese date string.
  /// e.g., "2023年10月27日".
  static String formatDateChineseSeparated(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final formattedDate = '$year年$month月$day日';
    LoggingUtils.debug(
      'Formatted date with Chinese separator: *$formattedDate*',
    );
    return formattedDate;
  }

  // --- Number Formatting ---

  /// Formats a number to a specified number of decimal places.
  static String formatNumberDecimalPlaces(double number, int decimalPlaces) {
    if (decimalPlaces < 0) decimalPlaces = 0;
    final formattedNumber = number.toStringAsFixed(decimalPlaces);
    LoggingUtils.debug(
      'Formatted number *$number* to *$decimalPlaces* decimal places: *$formattedNumber*',
    );
    return formattedNumber;
  }

  /// Formats a number using Chinese units like "万" (ten thousand) or "亿" (hundred million).
  /// e.g., 12000 -> "1.2万", 120000000 -> "1.2亿".
  static String formatNumberWithUnits(double number, {int decimalPlaces = 2}) {
    if (decimalPlaces < 0) decimalPlaces = 0;
    String result;

    if (number.abs() >= 100000000) {
      double numInYi = number / 100000000;
      result = '${numInYi.toStringAsFixed(decimalPlaces)}亿';
    } else if (number.abs() >= 10000) {
      double numInWan = number / 10000;
      result = '${numInWan.toStringAsFixed(decimalPlaces)}万';
    } else {
      result = number.toStringAsFixed(decimalPlaces);
    }
    LoggingUtils.debug('Formatted number *$number* with units: *$result*');
    return result;
  }
}
