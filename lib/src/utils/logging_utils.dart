import 'package:intl/intl.dart';

// ANSI escape codes for colors (won't work in all Dart consoles, e.g. Flutter debug console)
// These are primarily for demonstration if running in a compatible terminal.
// For Flutter UI, dedicated widgets/packages should be used for rich text styling.
const String _ansiReset = '\x1B[0m';
const String _ansiGray = '\x1B[90m';
// Define bright colors for log types - placeholders, actual colors may vary by terminal
const String _ansiBrightRed = '\x1B[91m'; // For ERROR
const String _ansiBrightGreen = '\x1B[92m'; // For INFO
const String _ansiBrightYellow = '\x1B[93m'; // For WARNING
const String _ansiBrightBlue = '\x1B[94m'; // For DEBUG

// For bold text
const String _ansiBold = '\x1B[1m';

/// Enum for different log types.
enum LogType { info, warning, error, debug }

/// A utility class for centralized logging.
/// All methods are static as per the guidelines.
class LoggingUtils {
  // Private constructor to prevent instantiation.
  LoggingUtils._();

  static final DateFormat _timeFormatter = DateFormat('HH:mm:ss.SSS');

  /// Logs a message with a specified log type.
  ///
  /// The log format is: time [log_type] message
  /// - `time`: Displayed in gray.
  /// - `[log_type]`: Type of the log (INFO, WARNING, ERROR, DEBUG).
  /// - `message`: The log content. Important keywords can be emphasized if passed with markdown-like bold.
  ///
  /// For ERROR logs, additional details like stack traces should be handled.
  static void log(
    String message, {
    LogType type = LogType.info,
    StackTrace? stackTrace,
  }) {
    final String currentTime = _timeFormatter.format(DateTime.now());
    String logTypeString = type.toString().split('.').last.toUpperCase();
    String coloredLogTypeMessage;
    String timeString = '$_ansiGray$currentTime$_ansiReset';

    // Basic markdown-like bold processing for *word*
    message = message.replaceAllMapped(RegExp(r'\*(.*?)\*'), (match) {
      if (match.group(1) != null && match.group(1)!.isNotEmpty) {
        return '$_ansiBold${match.group(1)}$_ansiReset';
      }
      return '';
    });

    switch (type) {
      case LogType.info:
        coloredLogTypeMessage =
            '$_ansiBrightGreen[$logTypeString] $message$_ansiReset';
        break;
      case LogType.warning:
        coloredLogTypeMessage =
            '$_ansiBrightYellow[$logTypeString] $message$_ansiReset';
        break;
      case LogType.error:
        coloredLogTypeMessage =
            '$_ansiBrightRed[$logTypeString] $message$_ansiReset';
        break;
      case LogType.debug:
        coloredLogTypeMessage =
            '$_ansiBrightBlue[$logTypeString] $message$_ansiReset';
        break;
    }

    // Using print for now. In a Flutter app, this might go to the Flutter console
    // or a more sophisticated logging framework.
    print('$timeString $coloredLogTypeMessage');

    if (type == LogType.error) {
      // Handle error-specific logging, e.g., print stack trace
      if (stackTrace != null) {
        print('$_ansiBrightRed${stackTrace.toString()}$_ansiReset');
      }
      // Potentially log to a remote error tracking service here.
      // As per guidelines: "Error logs (ERROR type) MUST be handled distinctively
      // to be easily identifiable and provide maximum debugging information".
    }
  }

  // Convenience methods for each log type

  /// Logs an informational message.
  static void info(String message) {
    log(message, type: LogType.info);
  }

  /// Logs a warning message.
  static void warning(String message) {
    log(message, type: LogType.warning);
  }

  /// Logs an error message.
  /// Optionally includes a [stackTrace].
  static void error(String message, {StackTrace? stackTrace}) {
    log(message, type: LogType.error, stackTrace: stackTrace);
  }

  /// Logs a debug message.
  static void debug(String message) {
    log(message, type: LogType.debug);
  }
}
