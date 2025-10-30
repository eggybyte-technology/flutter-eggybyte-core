import 'package:intl/intl.dart';
import 'package:eggybyte_core/src/utils/logging_utils.dart';

/// A utility class providing comprehensive data formatting functionality.
///
/// This class offers methods to format various data types including time, date, numbers,
/// currency, file sizes, and durations. All formatting methods support both standard
/// and Chinese locale formats for internationalization.
///
/// All methods are static as per the utility class guidelines.
///
/// Features:
/// - Time formatting with custom separators and Chinese style
/// - Date formatting with custom separators and Chinese style
/// - Number formatting with decimal places and Chinese units (万, 亿)
/// - Currency formatting with customizable symbols and locales
/// - File size formatting in human-readable format (B, KB, MB, GB, TB, PB)
/// - Duration formatting with customizable precision
///
/// Example usage:
/// ```dart
/// final now = DateTime.now();
/// final time = FormatUtils.formatTimeChineseSeparated(now); // "14时30分55秒"
/// final date = FormatUtils.formatDateChineseSeparated(now); // "2023年10月27日"
/// final currency = FormatUtils.formatCurrency(1234.56); // "¥1,234.56"
/// final fileSize = FormatUtils.formatFileSize(1048576); // "1.00 MB"
/// ```
class FormatUtils {
  /// Private constructor to prevent instantiation of this utility class.
  /// All methods are static and should be called directly on the class.
  FormatUtils._();

  // ============================================================================
  // Time Formatting Methods
  // ============================================================================

  /// Formats a [DateTime] object into a time string with a custom separator character.
  ///
  /// This method formats the time portion (hours, minutes, seconds) of a DateTime object
  /// using the specified separator character. The hours, minutes, and seconds are always
  /// displayed as two-digit numbers (e.g., "09:05:03").
  ///
  /// Parameters:
  /// - [time]: The DateTime object to format. Only the time portion (hour, minute, second)
  ///   will be used for formatting.
  /// - [separator]: The character to use as separator between hours, minutes, and seconds.
  ///   Defaults to `:` (colon). Common alternatives include `-` (dash) or `/` (slash).
  ///
  /// Returns:
  /// A formatted time string in the format "HH{separator}mm{separator}ss".
  ///
  /// Example:
  /// ```dart
  /// final time1 = DateTime(2023, 10, 27, 14, 30, 55);
  /// FormatUtils.formatTimeSymbolSeparated(time1); // "14:30:55"
  ///
  /// final time2 = DateTime(2023, 10, 27, 9, 5, 3);
  /// FormatUtils.formatTimeSymbolSeparated(time2, separator: '-'); // "09-05-03"
  /// ```
  static String formatTimeSymbolSeparated(
    DateTime time, {
    String separator = ':',
  }) {
    // Create a DateFormat pattern with the custom separator
    // HH = 24-hour format hours (00-23), mm = minutes (00-59), ss = seconds (00-59)
    final formatter = DateFormat('HH${separator}mm${separator}ss');
    final formattedTime = formatter.format(time);
    LoggingUtils.debug(
      'Formatted time with symbol separator: *$formattedTime*',
    );
    return formattedTime;
  }

  /// Formats a [DateTime] object into a Chinese-style time string.
  ///
  /// This method formats the time portion using Chinese characters (时, 分, 秒)
  /// to separate hours, minutes, and seconds. The format is commonly used in
  /// Chinese-language applications.
  ///
  /// Parameters:
  /// - [time]: The DateTime object to format. Only the time portion (hour, minute, second)
  ///   will be used for formatting.
  ///
  /// Returns:
  /// A formatted time string in Chinese style: "HH时mm分ss秒".
  ///
  /// Example:
  /// ```dart
  /// final time = DateTime(2023, 10, 27, 14, 30, 55);
  /// FormatUtils.formatTimeChineseSeparated(time); // "14时30分55秒"
  ///
  /// final earlyMorning = DateTime(2023, 10, 27, 9, 5, 3);
  /// FormatUtils.formatTimeChineseSeparated(earlyMorning); // "09时05分03秒"
  /// ```
  static String formatTimeChineseSeparated(DateTime time) {
    // Extract and pad time components to ensure two-digit format
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');

    // Format with Chinese separators: 时 (hour), 分 (minute), 秒 (second)
    final formattedTime = '$hour时$minute分$second秒';
    LoggingUtils.debug(
      'Formatted time with Chinese separator: *$formattedTime*',
    );
    return formattedTime;
  }

  // --- Date Formatting ---

  /// Formats a [DateTime] object into a date string with a custom separator character.
  ///
  /// This method formats the date portion (year, month, day) of a DateTime object
  /// using the specified separator character. The year is displayed as 4 digits,
  /// and month/day are displayed as 2 digits.
  ///
  /// Parameters:
  /// - [date]: The DateTime object to format. Only the date portion (year, month, day)
  ///   will be used for formatting.
  /// - [separator]: The character to use as separator between year, month, and day.
  ///   Defaults to `-` (dash). Common alternatives include `/` (slash) or `.` (dot).
  ///
  /// Returns:
  /// A formatted date string in the format "yyyy{separator}MM{separator}dd".
  ///
  /// Example:
  /// ```dart
  /// final date1 = DateTime(2023, 10, 27);
  /// FormatUtils.formatDateSymbolSeparated(date1); // "2023-10-27"
  ///
  /// final date2 = DateTime(2023, 10, 27);
  /// FormatUtils.formatDateSymbolSeparated(date2, separator: '/'); // "2023/10/27"
  /// ```
  static String formatDateSymbolSeparated(
    DateTime date, {
    String separator = '-',
  }) {
    // Create a DateFormat pattern with the custom separator
    // yyyy = 4-digit year, MM = 2-digit month (01-12), dd = 2-digit day (01-31)
    final formatter = DateFormat('yyyy${separator}MM${separator}dd');
    final formattedDate = formatter.format(date);
    LoggingUtils.debug(
      'Formatted date with symbol separator: *$formattedDate*',
    );
    return formattedDate;
  }

  /// Formats a [DateTime] object into a Chinese-style date string.
  ///
  /// This method formats the date portion using Chinese characters (年, 月, 日)
  /// to separate year, month, and day. The format is commonly used in
  /// Chinese-language applications.
  ///
  /// Parameters:
  /// - [date]: The DateTime object to format. Only the date portion (year, month, day)
  ///   will be used for formatting.
  ///
  /// Returns:
  /// A formatted date string in Chinese style: "yyyy年MM月dd日".
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2023, 10, 27);
  /// FormatUtils.formatDateChineseSeparated(date); // "2023年10月27日"
  ///
  /// final newYear = DateTime(2024, 1, 1);
  /// FormatUtils.formatDateChineseSeparated(newYear); // "2024年01月01日"
  /// ```
  static String formatDateChineseSeparated(DateTime date) {
    // Extract date components
    final year = date.year.toString();
    // Pad month and day to ensure two-digit format
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    // Format with Chinese separators: 年 (year), 月 (month), 日 (day)
    final formattedDate = '$year年$month月$day日';
    LoggingUtils.debug(
      'Formatted date with Chinese separator: *$formattedDate*',
    );
    return formattedDate;
  }

  // ============================================================================
  // Number Formatting Methods
  // ============================================================================

  /// Formats a number to a specified number of decimal places.
  ///
  /// This method converts a floating-point number to a string representation with
  /// exactly the specified number of decimal places. Numbers are rounded to the
  /// nearest value based on the specified precision.
  ///
  /// Parameters:
  /// - [number]: The number to format. Can be any floating-point value.
  /// - [decimalPlaces]: The number of decimal places to display. Must be non-negative.
  ///   If negative, it will be treated as 0.
  ///
  /// Returns:
  /// A formatted number string with exactly [decimalPlaces] decimal places.
  ///
  /// Example:
  /// ```dart
  /// FormatUtils.formatNumberDecimalPlaces(123.456, 2); // "123.46"
  /// FormatUtils.formatNumberDecimalPlaces(123.456, 0); // "123"
  /// FormatUtils.formatNumberDecimalPlaces(123, 2); // "123.00"
  /// FormatUtils.formatNumberDecimalPlaces(123.456, 5); // "123.45600"
  /// ```
  static String formatNumberDecimalPlaces(double number, int decimalPlaces) {
    // Ensure decimal places is non-negative
    if (decimalPlaces < 0) decimalPlaces = 0;

    // Convert to string with fixed decimal places
    final formattedNumber = number.toStringAsFixed(decimalPlaces);
    LoggingUtils.debug(
      'Formatted number *$number* to *$decimalPlaces* decimal places: *$formattedNumber*',
    );
    return formattedNumber;
  }

  /// Formats a number using Chinese units (万 "ten thousand" and 亿 "hundred million").
  ///
  /// This method formats large numbers using Chinese counting units for better readability.
  /// Numbers are automatically converted to the appropriate unit based on their magnitude:
  /// - Numbers >= 100,000,000 (1亿): Displayed in "亿" (hundred million) units
  /// - Numbers >= 10,000 (1万): Displayed in "万" (ten thousand) units
  /// - Numbers < 10,000: Displayed as-is with decimal places
  ///
  /// Parameters:
  /// - [number]: The number to format. Can be any floating-point value including negatives.
  /// - [decimalPlaces]: The number of decimal places to display after the unit.
  ///   Defaults to 2. Must be non-negative. If negative, treated as 0.
  ///
  /// Returns:
  /// A formatted number string with Chinese units if applicable.
  ///
  /// Example:
  /// ```dart
  /// FormatUtils.formatNumberWithUnits(12345); // "1.23万"
  /// FormatUtils.formatNumberWithUnits(123456789); // "1.23亿"
  /// FormatUtils.formatNumberWithUnits(5000); // "5000.00"
  /// FormatUtils.formatNumberWithUnits(12345, decimalPlaces: 1); // "1.2万"
  /// FormatUtils.formatNumberWithUnits(-12345); // "-1.23万"
  /// ```
  static String formatNumberWithUnits(double number, {int decimalPlaces = 2}) {
    // Ensure decimal places is non-negative
    if (decimalPlaces < 0) decimalPlaces = 0;

    String result;

    // Format based on magnitude using absolute value to handle negative numbers
    if (number.abs() >= 100000000) {
      // Convert to 亿 (hundred million) units: 1亿 = 100,000,000
      final double numInYi = number / 100000000;
      result = '${numInYi.toStringAsFixed(decimalPlaces)}亿';
    } else if (number.abs() >= 10000) {
      // Convert to 万 (ten thousand) units: 1万 = 10,000
      final double numInWan = number / 10000;
      result = '${numInWan.toStringAsFixed(decimalPlaces)}万';
    } else {
      // For numbers less than 10,000, display as-is with decimal places
      result = number.toStringAsFixed(decimalPlaces);
    }

    LoggingUtils.debug('Formatted number *$number* with units: *$result*');
    return result;
  }

  // ============================================================================
  // Currency Formatting Methods
  // ============================================================================

  /// Formats a number as currency with customizable symbol, locale, and decimal precision.
  ///
  /// This method uses the intl package's NumberFormat.currency to format monetary values
  /// according to locale conventions. It automatically handles thousands separators,
  /// decimal separators, and currency symbol placement based on the specified locale.
  ///
  /// Parameters:
  /// - [amount]: The monetary amount to format. Can be any floating-point value.
  /// - [currencySymbol]: The currency symbol to display (e.g., "¥", "$", "€").
  ///   Defaults to "¥" (Chinese Yuan). The symbol placement depends on the locale.
  /// - [locale]: The locale code to use for formatting conventions (e.g., "zh_CN", "en_US").
  ///   Defaults to "zh_CN" (Chinese locale). Locale affects thousands separator, decimal
  ///   separator, and symbol placement.
  /// - [decimalPlaces]: The number of decimal places to display. Defaults to 2.
  ///   Must be non-negative. If negative, treated as 0.
  ///
  /// Returns:
  /// A formatted currency string with symbol, thousands separators, and decimal places.
  ///
  /// Example:
  /// ```dart
  /// FormatUtils.formatCurrency(1234.56); // "¥1,234.56"
  /// FormatUtils.formatCurrency(1234.56, currencySymbol: '\$'); // "\$1,234.56"
  /// FormatUtils.formatCurrency(1234.56, locale: 'en_US'); // "¥1,234.56"
  /// FormatUtils.formatCurrency(1234.5, decimalPlaces: 1); // "¥1,234.5"
  /// ```
  static String formatCurrency(
    double amount, {
    String currencySymbol = '¥',
    String locale = 'zh_CN',
    int decimalPlaces = 2,
  }) {
    // Create a NumberFormat instance configured for currency formatting
    final formatter = NumberFormat.currency(
      symbol: currencySymbol,
      locale: locale,
      decimalDigits: decimalPlaces,
    );
    final formattedCurrency = formatter.format(amount);
    LoggingUtils.debug(
      'Formatted currency *$amount* to *$formattedCurrency*',
    );
    return formattedCurrency;
  }

  // ============================================================================
  // File Size Formatting Methods
  // ============================================================================

  /// Formats a file size in bytes to a human-readable string with appropriate units.
  ///
  /// This method automatically converts bytes to the most appropriate unit (B, KB, MB, GB, TB, PB)
  /// based on the file size magnitude. The conversion uses binary (1024-based) units for
  /// consistency with most operating systems and file systems.
  ///
  /// Unit Conversion:
  /// - 1 KB = 1,024 bytes
  /// - 1 MB = 1,024 KB = 1,048,576 bytes
  /// - 1 GB = 1,024 MB = 1,073,741,824 bytes
  /// - 1 TB = 1,024 GB = 1,099,511,627,776 bytes
  /// - 1 PB = 1,024 TB = 1,125,899,906,842,624 bytes
  ///
  /// Parameters:
  /// - [bytes]: The file size in bytes. Must be non-negative. If negative, returns "0 B".
  /// - [decimalPlaces]: The number of decimal places to display in the formatted string.
  ///   Defaults to 2. Must be non-negative. If negative, treated as 2.
  ///
  /// Returns:
  /// A formatted file size string with unit suffix (e.g., "1.5 KB", "2.3 MB", "1.2 GB").
  ///
  /// Example:
  /// ```dart
  /// FormatUtils.formatFileSize(1024); // "1.00 KB"
  /// FormatUtils.formatFileSize(1048576); // "1.00 MB"
  /// FormatUtils.formatFileSize(1536, decimalPlaces: 1); // "1.5 KB"
  /// FormatUtils.formatFileSize(0); // "0.00 B"
  /// FormatUtils.formatFileSize(1099511627776); // "1.00 TB"
  /// ```
  static String formatFileSize(int bytes, {int decimalPlaces = 2}) {
    // Ensure decimal places is non-negative
    if (decimalPlaces < 0) decimalPlaces = 2;

    // Handle negative bytes gracefully
    if (bytes < 0) {
      LoggingUtils.warning('Negative file size: *$bytes*');
      return '0 B';
    }

    // Define unit names in order from smallest to largest
    const units = <String>['B', 'KB', 'MB', 'GB', 'TB', 'PB'];

    // Start with bytes and iterate through units, dividing by 1024 each time
    int unitIndex = 0;
    double size = bytes.toDouble();

    // Convert to appropriate unit by dividing by 1024 until size is less than 1024
    // or we've reached the largest unit
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    // Format the size with the determined unit
    final formattedSize = size.toStringAsFixed(decimalPlaces);
    final result = '$formattedSize ${units[unitIndex]}';
    LoggingUtils.debug('Formatted file size *$bytes* bytes to *$result*');
    return result;
  }

  // ============================================================================
  // Duration Formatting Methods
  // ============================================================================

  /// Formats a [Duration] object to a human-readable string representation.
  ///
  /// This method converts a Duration to a readable format showing hours, minutes, seconds,
  /// and optionally milliseconds. Only non-zero components are included in the output.
  /// Components are displayed in order from largest to smallest (hours → minutes → seconds → milliseconds).
  ///
  /// Parameters:
  /// - [duration]: The Duration object to format.
  /// - [showSeconds]: Whether to include seconds in the output. Defaults to `true`.
  ///   When `false`, seconds are omitted even if the duration contains seconds.
  /// - [showMilliseconds]: Whether to include milliseconds in the output. Defaults to `false`.
  ///   When `true`, milliseconds are displayed if the duration contains them.
  ///
  /// Returns:
  /// A formatted duration string with unit abbreviations (e.g., "1h 30m 45s", "2h 15m").
  /// If all components are zero, returns "0s" (or "0ms" if showMilliseconds is true).
  ///
  /// Format Examples:
  /// - "1h 30m 45s" - 1 hour, 30 minutes, 45 seconds
  /// - "30m 15s" - 30 minutes, 15 seconds (no hours)
  /// - "1s 234ms" - 1 second, 234 milliseconds (when showMilliseconds is true)
  /// - "45s" - 45 seconds only
  ///
  /// Example:
  /// ```dart
  /// final duration1 = Duration(hours: 1, minutes: 30, seconds: 45);
  /// FormatUtils.formatDuration(duration1); // "1h 30m 45s"
  ///
  /// final duration2 = Duration(minutes: 30, seconds: 15);
  /// FormatUtils.formatDuration(duration2); // "30m 15s"
  ///
  /// final duration3 = Duration(milliseconds: 1234);
  /// FormatUtils.formatDuration(duration3, showMilliseconds: true); // "1s 234ms"
  ///
  /// final duration4 = Duration(hours: 2);
  /// FormatUtils.formatDuration(duration4, showSeconds: false); // "2h"
  /// ```
  static String formatDuration(
    Duration duration, {
    bool showSeconds = true,
    bool showMilliseconds = false,
  }) {
    // Extract duration components
    // Note: These methods return the total units (e.g., inHours returns total hours including fractional)
    final hours = duration.inHours;
    // remainder(60) gets the remaining minutes/seconds after extracting larger units
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final milliseconds = duration.inMilliseconds.remainder(1000);

    // Build list of non-zero components to display
    final parts = <String>[];

    // Add hours if present
    if (hours > 0) {
      parts.add('${hours}h');
    }
    // Add minutes if present
    if (minutes > 0) {
      parts.add('${minutes}m');
    }
    // Add seconds if enabled and present
    if (showSeconds && seconds > 0) {
      parts.add('${seconds}s');
    }
    // Add milliseconds if enabled and present
    if (showMilliseconds && milliseconds > 0) {
      parts.add('${milliseconds}ms');
    }

    // Handle zero duration case
    if (parts.isEmpty) {
      return showMilliseconds ? '0ms' : '0s';
    }

    // Join all parts with spaces
    final result = parts.join(' ');
    LoggingUtils.debug('Formatted duration *$duration* to *$result*');
    return result;
  }
}
