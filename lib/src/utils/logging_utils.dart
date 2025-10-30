import 'package:flutter/foundation.dart' show kDebugMode;

/// ANSI escape code to reset all formatting (colors, bold, etc.) to default terminal appearance.
/// Used to clear any applied styling after colored text output.
const String _ansiReset = '\x1B[0m';

/// ANSI escape code for bright red color, used for ERROR level log messages.
/// Provides visual distinction for error-level logging to improve readability.
const String _ansiBrightRed = '\x1B[91m';

/// ANSI escape code for bright green color, used for INFO level log messages.
/// Provides visual distinction for informational logging to improve readability.
const String _ansiBrightGreen = '\x1B[92m';

/// ANSI escape code for bright yellow color, used for WARNING level log messages.
/// Provides visual distinction for warning-level logging to improve readability.
const String _ansiBrightYellow = '\x1B[93m';

/// ANSI escape code for bright blue color, used for DEBUG level log messages.
/// Provides visual distinction for debug-level logging to improve readability.
const String _ansiBrightBlue = '\x1B[94m';

/// ANSI escape code to apply bold text formatting.
/// Used to emphasize important keywords within log messages using markdown-like syntax (*text*).
const String _ansiBold = '\x1B[1m';

/// Enumeration defining the available log severity levels.
///
/// Each log type corresponds to a different severity level:
/// - [LogType.info]: Informational messages for normal application flow
/// - [LogType.warning]: Warning messages for potentially problematic situations
/// - [LogType.error]: Error messages for exceptional conditions requiring attention
/// - [LogType.debug]: Debug messages for development-time troubleshooting (only output in debug mode)
enum LogType {
  /// Informational log level for normal application flow messages.
  info,

  /// Warning log level for potentially problematic situations that don't stop execution.
  warning,

  /// Error log level for exceptional conditions that require attention.
  error,

  /// Debug log level for development-time troubleshooting (only output when kDebugMode is true).
  debug,
}

/// A utility class providing centralized logging functionality for EggyByte applications.
///
/// This class implements a platform-aware logging system that automatically handles
/// ANSI escape sequences based on the detected platform and debug environment.
/// All methods are static as per the utility class guidelines.
///
/// Features:
/// - Colored output support with automatic platform detection
/// - Bold text formatting for emphasis using markdown-like syntax (*text*)
/// - Debug log filtering (only outputs in debug mode)
/// - Native platform logging with automatic prefix detection
/// - No timestamp in log output (as per requirements)
///
/// Example usage:
/// ```dart
/// LoggingUtils.info('Application started successfully');
/// LoggingUtils.warning('This is a warning message');
/// LoggingUtils.error('Error occurred', stackTrace: StackTrace.current);
/// LoggingUtils.debug('Debug information'); // Only outputs in debug mode
/// ```
class LoggingUtils {
  /// Private constructor to prevent instantiation of this utility class.
  /// All methods are static and should be called directly on the class.
  LoggingUtils._();

  /// Flag indicating whether ANSI color codes should be enabled in log output.
  ///
  /// When `true`, log messages will include color formatting based on log type:
  /// - INFO: green
  /// - WARNING: yellow
  /// - ERROR: red
  /// - DEBUG: blue
  ///
  /// Defaults to `true` but can be disabled via [configureFormatting] for
  /// environments that don't support ANSI colors (e.g., iOS debug console).
  static bool _enableColors = true;

  /// Flag indicating whether bold text formatting should be enabled in log output.
  ///
  /// When `true`, text wrapped in asterisks (*text*) will be formatted as bold.
  /// When `false`, asterisks will be removed or replaced with markdown syntax.
  ///
  /// Defaults to `true` but can be disabled via [configureFormatting] for
  /// environments that don't support ANSI escape sequences.
  static bool _enableBold = true;

  /// Optional function that provides the platform prefix for native logging.
  ///
  /// This function is set by [EggyByteCore.initialize()] to automatically
  /// provide platform-specific prefixes (e.g., "ANDROID NATIVE", "IOS NATIVE")
  /// for native logging methods without requiring manual prefix specification.
  ///
  /// If `null`, native logging methods will require explicit platform prefix
  /// or will default to "[NATIVE]".
  static String? Function()? _platformPrefixProvider;

  /// Sets the platform prefix provider function for automatic platform prefix detection.
  ///
  /// This method should be called by [EggyByteCore.initialize()] during initialization
  /// to enable automatic platform prefix detection for native logging methods.
  ///
  /// Parameters:
  /// - [provider]: A function that returns the platform prefix string (e.g., "ANDROID NATIVE").
  ///   If `null`, the platform prefix provider will be cleared and manual prefixes will be required.
  ///
  /// Example:
  /// ```dart
  /// LoggingUtils.setPlatformPrefixProvider(() => 'ANDROID NATIVE');
  /// ```
  static void setPlatformPrefixProvider(String? Function()? provider) {
    _platformPrefixProvider = provider;
  }

  /// Configures the formatting options for all log output.
  ///
  /// This method allows runtime configuration of color and bold formatting behavior,
  /// which is useful for adapting to different terminal environments or user preferences.
  ///
  /// Parameters:
  /// - [enableColors]: Whether to enable ANSI color codes in log output.
  ///   When `false`, all logs will be plain text without color formatting.
  ///   Defaults to `true`.
  /// - [enableBold]: Whether to enable bold text formatting for emphasized keywords.
  ///   When `false`, asterisks (*text*) will be removed or replaced with markdown syntax.
  ///   Defaults to `true`.
  ///
  /// Example:
  /// ```dart
  /// // Disable colors for terminals that don't support ANSI escape sequences
  /// LoggingUtils.configureFormatting(enableColors: false, enableBold: false);
  ///
  /// // Re-enable formatting
  /// LoggingUtils.configureFormatting(enableColors: true, enableBold: true);
  /// ```
  static void configureFormatting({
    bool enableColors = true,
    bool enableBold = true,
  }) {
    _enableColors = enableColors;
    _enableBold = enableBold;
  }

  /// Logs a message with a specified log type and optional stack trace.
  ///
  /// This is the core logging method that handles all log formatting, colorization,
  /// and output. The log format is: `[LOG_TYPE] message` (no timestamp as per requirements).
  ///
  /// Log Format:
  /// - `[LOG_TYPE]`: The log type (INFO, WARNING, ERROR, DEBUG) displayed in brackets
  /// - `message`: The log content. Important keywords can be emphasized using markdown-like
  ///   syntax: wrap text in asterisks (*text*) to make it bold (if bold formatting is enabled)
  ///
  /// Special Handling:
  /// - DEBUG logs: Only output when running in debug mode (`kDebugMode`). Skipped in release builds.
  /// - ERROR logs: If a [stackTrace] is provided, it will be printed separately after the error message.
  ///
  /// Parameters:
  /// - [message]: The log message to output. Can contain asterisks (*text*) for bold formatting.
  /// - [type]: The log severity level. Defaults to [LogType.info].
  /// - [stackTrace]: Optional stack trace to include with error logs for debugging purposes.
  ///
  /// Example:
  /// ```dart
  /// LoggingUtils.log('Application started', type: LogType.info);
  /// LoggingUtils.log('This is *important*', type: LogType.warning);
  /// LoggingUtils.log('Error occurred', type: LogType.error, stackTrace: StackTrace.current);
  /// ```
  static void log(
    String message, {
    LogType type = LogType.info,
    StackTrace? stackTrace,
  }) {
    // Skip debug logs in non-debug mode to improve performance in release builds
    if (type == LogType.debug && !kDebugMode) {
      return;
    }

    // Extract the log type name (e.g., "info", "warning") and convert to uppercase
    final String logTypeString = type.toString().split('.').last.toUpperCase();

    // Variables to hold formatted log components
    String logColorCode;
    String coloredLogTypeMessage;

    // Determine the appropriate ANSI color code based on log type
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

    if (_enableColors) {
      // Process bold formatting: Replace asterisks (*text*) with ANSI bold codes
      // After applying bold, we need to reapply the log color so the rest of
      // the message maintains the log type color
      if (_enableBold) {
        message = message.replaceAllMapped(RegExp(r'\*(.*?)\*'), (match) {
          final String? matchedGroup = match.group(1);
          if (matchedGroup != null && matchedGroup.isNotEmpty) {
            // Apply bold format, then content, then reset bold, then reapply log color
            return '$_ansiBold$matchedGroup$_ansiReset$logColorCode';
          }
          return '';
        });
      } else {
        // Remove asterisks without applying bold formatting when bold is disabled
        message = message.replaceAll(RegExp(r'\*(.*?)\*'), r'$1');
      }

      // Construct the final colored log message with log type in brackets
      coloredLogTypeMessage =
          '$logColorCode[$logTypeString] $message$_ansiReset';
    } else {
      // Plain text mode: No ANSI escape codes
      if (_enableBold) {
        // Convert asterisks to markdown-style bold (**text**) for plain text
        message = message.replaceAll(RegExp(r'\*(.*?)\*'), r'**$1**');
      } else {
        // Remove asterisks completely when both colors and bold are disabled
        message = message.replaceAll(RegExp(r'\*(.*?)\*'), r'$1');
      }

      // Construct plain text log message with log type in brackets
      coloredLogTypeMessage = '[$logTypeString] $message';
    }

    // Output the formatted log message to console
    // Using print for Flutter console output
    // ignore: avoid_print
    print(coloredLogTypeMessage);

    // Handle error-specific logging: Print stack trace if provided
    if (type == LogType.error && stackTrace != null) {
      if (_enableColors) {
        // Color the stack trace with the error color for better visibility
        // ignore: avoid_print
        print('$_ansiBrightRed${stackTrace.toString()}$_ansiReset');
      } else {
        // Plain text stack trace when colors are disabled
        // ignore: avoid_print
        print(stackTrace.toString());
      }
      // Note: This is where remote error tracking service integration could be added
      // As per guidelines: "Error logs (ERROR type) MUST be handled distinctively
      // to be easily identifiable and provide maximum debugging information".
    }
  }

  /// Logs a message with a platform-specific prefix for native platform operations.
  ///
  /// This method is designed for logging messages from platform-specific code (Android, iOS, etc.).
  /// It automatically prepends a platform identifier to the log message to help distinguish
  /// native platform logs from general application logs.
  ///
  /// Platform Prefix Resolution:
  /// 1. Uses [platformPrefix] if explicitly provided
  /// 2. Falls back to [EggyByteCore.getPlatformPrefix()] via [_platformPrefixProvider] if not provided
  /// 3. Defaults to "[NATIVE]" if no platform prefix is available
  ///
  /// Parameters:
  /// - [message]: The log message to output. Can contain asterisks (*text*) for bold formatting.
  /// - [platformPrefix]: Optional platform identifier string (e.g., "ANDROID NATIVE", "IOS NATIVE").
  ///   If `null`, the platform prefix will be automatically retrieved from EggyByteCore if available.
  /// - [type]: The log severity level. Defaults to [LogType.info].
  /// - [stackTrace]: Optional stack trace to include with error logs for debugging purposes.
  ///
  /// Example:
  /// ```dart
  /// LoggingUtils.logNative('Platform operation completed', platformPrefix: 'ANDROID NATIVE');
  /// LoggingUtils.logNative('Native error occurred', type: LogType.error); // Auto-detects platform
  /// ```
  static void logNative(
    String message, {
    String? platformPrefix,
    LogType type = LogType.info,
    StackTrace? stackTrace,
  }) {
    // Determine the effective platform prefix to use
    String? effectivePlatformPrefix = platformPrefix;

    // If no explicit platform prefix provided, try to get it from the provider set by EggyByteCore
    if (effectivePlatformPrefix == null && _platformPrefixProvider != null) {
      try {
        effectivePlatformPrefix = _platformPrefixProvider!();
      } catch (e) {
        // Fallback to generic NATIVE prefix if provider fails or throws an exception
        effectivePlatformPrefix = 'NATIVE';
      }
    }

    // Construct the prefixed message with platform identifier in brackets
    final String prefixedMessage = effectivePlatformPrefix != null
        ? '[$effectivePlatformPrefix] $message'
        : '[NATIVE] $message';

    // Delegate to the main log method with the prefixed message
    log(prefixedMessage, type: type, stackTrace: stackTrace);
  }

  // ============================================================================
  // Convenience Methods for Standard Logging
  // ============================================================================

  /// Logs an informational message at INFO level.
  ///
  /// This is a convenience method for logging normal application flow messages.
  /// Equivalent to calling [log] with [LogType.info].
  ///
  /// Parameters:
  /// - [message]: The informational message to log. Can contain asterisks (*text*) for bold formatting.
  ///
  /// Example:
  /// ```dart
  /// LoggingUtils.info('Application started successfully');
  /// LoggingUtils.info('User logged in: *username*');
  /// ```
  static void info(String message) {
    log(message, type: LogType.info);
  }

  /// Logs a warning message at WARNING level.
  ///
  /// This is a convenience method for logging potentially problematic situations
  /// that don't stop execution. Equivalent to calling [log] with [LogType.warning].
  ///
  /// Parameters:
  /// - [message]: The warning message to log. Can contain asterisks (*text*) for bold formatting.
  ///
  /// Example:
  /// ```dart
  /// LoggingUtils.warning('API rate limit approaching');
  /// LoggingUtils.warning('Cache size is *high*: ${cache.size}');
  /// ```
  static void warning(String message) {
    log(message, type: LogType.warning);
  }

  /// Logs an error message at ERROR level with optional stack trace.
  ///
  /// This is a convenience method for logging exceptional conditions that require attention.
  /// Equivalent to calling [log] with [LogType.error].
  ///
  /// Parameters:
  /// - [message]: The error message to log. Can contain asterisks (*text*) for bold formatting.
  /// - [stackTrace]: Optional stack trace to include for debugging purposes.
  ///   If provided, the stack trace will be printed separately after the error message.
  ///
  /// Example:
  /// ```dart
  /// LoggingUtils.error('Failed to connect to database');
  /// LoggingUtils.error('Validation failed', stackTrace: StackTrace.current);
  /// ```
  static void error(String message, {StackTrace? stackTrace}) {
    log(message, type: LogType.error, stackTrace: stackTrace);
  }

  /// Logs a debug message at DEBUG level.
  ///
  /// This is a convenience method for logging development-time troubleshooting information.
  /// Debug logs are only output when running in debug mode (kDebugMode = true).
  /// In release builds, these logs are completely skipped for performance.
  /// Equivalent to calling [log] with [LogType.debug].
  ///
  /// Parameters:
  /// - [message]: The debug message to log. Can contain asterisks (*text*) for bold formatting.
  ///
  /// Example:
  /// ```dart
  /// LoggingUtils.debug('Current state: $state');
  /// LoggingUtils.debug('Processing *item*: $itemId');
  /// ```
  static void debug(String message) {
    log(message, type: LogType.debug);
  }

  // ============================================================================
  // Convenience Methods for Native Platform Logging
  // ============================================================================

  /// Logs an informational message for native platform operations.
  ///
  /// This is a convenience method for logging INFO level messages from platform-specific code.
  /// The message will be automatically prefixed with the platform identifier if available.
  ///
  /// Parameters:
  /// - [message]: The informational message to log. Can contain asterisks (*text*) for bold formatting.
  /// - [platformPrefix]: Optional platform identifier (e.g., "ANDROID NATIVE", "IOS NATIVE").
  ///   If `null`, the platform prefix will be automatically retrieved from EggyByteCore.
  ///
  /// Example:
  /// ```dart
  /// LoggingUtils.nativeInfo('Native operation completed');
  /// LoggingUtils.nativeInfo('Platform feature initialized', platformPrefix: 'ANDROID NATIVE');
  /// ```
  static void nativeInfo(String message, {String? platformPrefix}) {
    logNative(message, platformPrefix: platformPrefix, type: LogType.info);
  }

  /// Logs a warning message for native platform operations.
  ///
  /// This is a convenience method for logging WARNING level messages from platform-specific code.
  /// The message will be automatically prefixed with the platform identifier if available.
  ///
  /// Parameters:
  /// - [message]: The warning message to log. Can contain asterisks (*text*) for bold formatting.
  /// - [platformPrefix]: Optional platform identifier (e.g., "ANDROID NATIVE", "IOS NATIVE").
  ///   If `null`, the platform prefix will be automatically retrieved from EggyByteCore.
  ///
  /// Example:
  /// ```dart
  /// LoggingUtils.nativeWarning('Native API deprecated');
  /// LoggingUtils.nativeWarning('Platform feature *unavailable*', platformPrefix: 'IOS NATIVE');
  /// ```
  static void nativeWarning(String message, {String? platformPrefix}) {
    logNative(message, platformPrefix: platformPrefix, type: LogType.warning);
  }

  /// Logs an error message for native platform operations with optional stack trace.
  ///
  /// This is a convenience method for logging ERROR level messages from platform-specific code.
  /// The message will be automatically prefixed with the platform identifier if available.
  ///
  /// Parameters:
  /// - [message]: The error message to log. Can contain asterisks (*text*) for bold formatting.
  /// - [platformPrefix]: Optional platform identifier (e.g., "ANDROID NATIVE", "IOS NATIVE").
  ///   If `null`, the platform prefix will be automatically retrieved from EggyByteCore.
  /// - [stackTrace]: Optional stack trace to include for debugging purposes.
  ///
  /// Example:
  /// ```dart
  /// LoggingUtils.nativeError('Native API call failed');
  /// LoggingUtils.nativeError('Platform error', stackTrace: StackTrace.current);
  /// ```
  static void nativeError(String message,
      {String? platformPrefix, StackTrace? stackTrace}) {
    logNative(message,
        platformPrefix: platformPrefix,
        type: LogType.error,
        stackTrace: stackTrace);
  }

  /// Logs a debug message for native platform operations.
  ///
  /// This is a convenience method for logging DEBUG level messages from platform-specific code.
  /// Debug logs are only output when running in debug mode (kDebugMode = true).
  /// The message will be automatically prefixed with the platform identifier if available.
  ///
  /// Parameters:
  /// - [message]: The debug message to log. Can contain asterisks (*text*) for bold formatting.
  /// - [platformPrefix]: Optional platform identifier (e.g., "ANDROID NATIVE", "IOS NATIVE").
  ///   If `null`, the platform prefix will be automatically retrieved from EggyByteCore.
  ///
  /// Example:
  /// ```dart
  /// LoggingUtils.nativeDebug('Native operation state: $state');
  /// LoggingUtils.nativeDebug('Platform feature *enabled*', platformPrefix: 'ANDROID NATIVE');
  /// ```
  static void nativeDebug(String message, {String? platformPrefix}) {
    logNative(message, platformPrefix: platformPrefix, type: LogType.debug);
  }
}
