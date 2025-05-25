library;

// Exports for utility modules will be added here
// e.g., export 'src/utils/logging_utils.dart';
// export 'src/utils/network_utils.dart';
// ... and so on for all utilities

// Utility Modules Exports
export 'src/utils/logging_utils.dart';
export 'src/utils/network_utils.dart';
export 'src/utils/screen_utils.dart';
export 'src/utils/storage_utils.dart';
export 'src/utils/format_utils.dart';

import 'src/utils/logging_utils.dart';

/// Supported target platforms
enum TargetPlatform { android, ios, web, windows, macos, linux }

/// Main configuration class for EggyByte Core
class EggyByteCore {
  // Private constructor to prevent instantiation
  EggyByteCore._();

  static TargetPlatform? _targetPlatform;

  /// Sets the current target platform for the application
  /// This affects how logs are formatted and displayed
  static void setTargetPlatform(TargetPlatform platform) {
    _targetPlatform = platform;
    LoggingUtils.info(
        'Target platform set to: *${platform.name.toUpperCase()}*');
  }

  /// Gets the current target platform
  static TargetPlatform? getTargetPlatform() {
    return _targetPlatform;
  }

  /// Configures logging color and formatting support
  ///
  /// [enableColors]: Whether to enable ANSI color codes in logs
  /// [enableBold]: Whether to enable bold text formatting in logs
  static void configureLogging({
    bool enableColors = true,
    bool enableBold = true,
  }) {
    LoggingUtils.configureFormatting(
      enableColors: enableColors,
      enableBold: enableBold,
    );
    LoggingUtils.info(
      'Logging configured - Colors: *$enableColors*, Bold: *$enableBold*',
    );
  }

  /// Gets the platform prefix for native logging
  static String? getPlatformPrefix() {
    if (_targetPlatform == null) return null;
    return '${_targetPlatform!.name.toUpperCase()} NATIVE';
  }
}
