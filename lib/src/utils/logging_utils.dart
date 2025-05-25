import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

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

  // Configuration flags
  static bool _enableColors = true;
  static bool _enableBold = true;

  // Platform prefix provider function
  static String? Function()? _platformPrefixProvider;

  /// Sets the platform prefix provider function
  /// This should be called by EggyByteCore during initialization
  static void setPlatformPrefixProvider(String? Function()? provider) {
    _platformPrefixProvider = provider;
  }

  /// Configures the formatting options for logging
  ///
  /// [enableColors]: Whether to enable ANSI color codes
  /// [enableBold]: Whether to enable bold text formatting
  static void configureFormatting({
    bool enableColors = true,
    bool enableBold = true,
  }) {
    _enableColors = enableColors;
    _enableBold = enableBold;
  }

  /// Logs a message with a specified log type.
  ///
  /// The log format is: time [log_type] message
  /// - `time`: Displayed in gray.
  /// - `[log_type]`: Type of the log (INFO, WARNING, ERROR, DEBUG).
  /// - `message`: The log content. Important keywords can be emphasized if passed with markdown-like bold.
  ///
  /// For ERROR logs, additional details like stack traces should be handled.
  /// For DEBUG logs, output is only generated when running in debug mode.
  static void log(
    String message, {
    LogType type = LogType.info,
    StackTrace? stackTrace,
  }) {
    // Skip debug logs in non-debug mode
    if (type == LogType.debug && !kDebugMode) {
      return;
    }

    final String currentTime = _timeFormatter.format(DateTime.now());
    String logTypeString = type.toString().split('.').last.toUpperCase();

    String timeString;
    String logColorCode;
    String coloredLogTypeMessage;

    if (_enableColors) {
      timeString = '$_ansiGray$currentTime$_ansiReset';

      switch (type) {
        case LogType.info:
          logColorCode = _ansiBrightGreen;
          break;
        case LogType.warning:
          logColorCode = _ansiBrightYellow;
          break;
        case LogType.error:
          logColorCode = _ansiBrightRed;
          break;
        case LogType.debug:
          logColorCode = _ansiBrightBlue;
          break;
      }

      // Process bolding: reapply logColorCode after each bold reset
      // so that the color of the log type persists for the rest of the message.
      if (_enableBold) {
        message = message.replaceAllMapped(RegExp(r'\*(.*?)\*'), (match) {
          final String? matchedGroup = match.group(1);
          if (matchedGroup != null && matchedGroup.isNotEmpty) {
            // Apply bold, then the content, then reset bold, THEN reapply the log's original color.
            return '$_ansiBold$matchedGroup$_ansiReset$logColorCode';
          }
          return '';
        });
      } else {
        // Remove asterisks without applying bold formatting
        message = message.replaceAll(RegExp(r'\*(.*?)\*'), r'$1');
      }

      // Construct the final colored message.
      coloredLogTypeMessage =
          '$logColorCode[$logTypeString] $message$_ansiReset';
    } else {
      // No colors, plain text format
      timeString = currentTime;

      if (_enableBold) {
        // Keep asterisks for bold indication in plain text
        message = message.replaceAll(RegExp(r'\*(.*?)\*'), r'**$1**');
      } else {
        // Remove asterisks completely
        message = message.replaceAll(RegExp(r'\*(.*?)\*'), r'$1');
      }

      coloredLogTypeMessage = '[$logTypeString] $message';
    }

    // Using print for now. In a Flutter app, this might go to the Flutter console
    // or a more sophisticated logging framework.
    // ignore: avoid_print
    print('$timeString $coloredLogTypeMessage');

    if (type == LogType.error) {
      // Handle error-specific logging, e.g., print stack trace
      if (stackTrace != null) {
        if (_enableColors) {
          // Ensure stack trace is also colored with the error color, and reset afterwards.
          // ignore: avoid_print
          print('$_ansiBrightRed${stackTrace.toString()}$_ansiReset');
        } else {
          // ignore: avoid_print
          print(stackTrace.toString());
        }
      }
      // Potentially log to a remote error tracking service here.
      // As per guidelines: "Error logs (ERROR type) MUST be handled distinctively
      // to be easily identifiable and provide maximum debugging information".
    }
  }

  /// Logs a native platform message with platform prefix
  ///
  /// [message]: The log message
  /// [platformPrefix]: Platform identifier (e.g., "ANDROID NATIVE", "IOS NATIVE")
  ///                   If null, attempts to get platform prefix from EggyByteCore
  /// [type]: The log type (defaults to info)
  static void logNative(
    String message, {
    String? platformPrefix,
    LogType type = LogType.info,
    StackTrace? stackTrace,
  }) {
    String? effectivePlatformPrefix = platformPrefix;

    // If no platform prefix provided, try to get it from the provider
    if (effectivePlatformPrefix == null && _platformPrefixProvider != null) {
      try {
        effectivePlatformPrefix = _platformPrefixProvider!();
      } catch (e) {
        // Fallback to generic NATIVE if provider fails
        effectivePlatformPrefix = 'NATIVE';
      }
    }

    final String prefixedMessage = effectivePlatformPrefix != null
        ? '[$effectivePlatformPrefix] $message'
        : '[NATIVE] $message';

    log(prefixedMessage, type: type, stackTrace: stackTrace);
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

  // Native logging convenience methods

  /// Logs a native info message
  static void nativeInfo(String message, {String? platformPrefix}) {
    logNative(message, platformPrefix: platformPrefix, type: LogType.info);
  }

  /// Logs a native warning message
  static void nativeWarning(String message, {String? platformPrefix}) {
    logNative(message, platformPrefix: platformPrefix, type: LogType.warning);
  }

  /// Logs a native error message
  static void nativeError(String message,
      {String? platformPrefix, StackTrace? stackTrace}) {
    logNative(message,
        platformPrefix: platformPrefix,
        type: LogType.error,
        stackTrace: stackTrace);
  }

  /// Logs a native debug message
  static void nativeDebug(String message, {String? platformPrefix}) {
    logNative(message, platformPrefix: platformPrefix, type: LogType.debug);
  }
}
