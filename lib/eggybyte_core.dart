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
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart'
    show kIsWeb, kDebugMode, defaultTargetPlatform, TargetPlatform;

/// Main configuration class for EggyByte Core
class EggyByteCore {
  // Private constructor to prevent instantiation
  EggyByteCore._();

  static TargetPlatform? _targetPlatform;
  static bool _isInitialized = false;

  /// Initializes EggyByte Core with automatic platform detection and optimal settings
  ///
  /// [enableColors]: Whether to enable ANSI color codes in logs.
  /// If null, automatically determined based on platform and debug mode.
  /// [enableBold]: Whether to enable bold text formatting in logs.
  /// If null, automatically determined based on platform and debug mode.
  static void initialize({
    bool? enableColors,
    bool? enableBold,
  }) {
    if (_isInitialized) {
      LoggingUtils.warning('EggyByte Core is already initialized');
      return;
    }

    // Automatically detect platform
    _targetPlatform = _detectCurrentPlatform();
    LoggingUtils.info(
        'Platform auto-detected: *${_targetPlatform!.name.toUpperCase()}*');

    // Set platform prefix provider for LoggingUtils
    LoggingUtils.setPlatformPrefixProvider(() => getPlatformPrefix());

    // Auto-configure logging based on platform and environment
    final bool autoEnableColors = enableColors ?? _shouldEnableColors();
    final bool autoEnableBold = enableBold ?? _shouldEnableBold();

    LoggingUtils.configureFormatting(
      enableColors: autoEnableColors,
      enableBold: autoEnableBold,
    );

    LoggingUtils.info(
      'EggyByte Core initialized - Platform: *${_targetPlatform!.name.toUpperCase()}*, Colors: *$autoEnableColors*, Bold: *$autoEnableBold*',
    );

    _isInitialized = true;
  }

  /// Resets the initialization state (mainly for testing purposes)
  static void reset() {
    _isInitialized = false;
    _targetPlatform = null;
    LoggingUtils.configureFormatting(enableColors: true, enableBold: true);
  }

  /// Gets the current target platform (auto-detected during initialization)
  static TargetPlatform? getTargetPlatform() {
    return _targetPlatform;
  }

  /// Gets the platform prefix for native logging
  static String? getPlatformPrefix() {
    if (_targetPlatform == null) return null;
    return '${_targetPlatform!.name.toUpperCase()} NATIVE';
  }

  /// Checks if EggyByte Core has been initialized
  static bool get isInitialized => _isInitialized;

  /// Manually configures logging (available after initialization)
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
      'Logging reconfigured - Colors: *$enableColors*, Bold: *$enableBold*',
    );
  }

  // Private methods

  /// Automatically detects the current platform
  static TargetPlatform _detectCurrentPlatform() {
    // Check if running on web first
    if (kIsWeb) {
      // Web doesn't have a specific TargetPlatform, use defaultTargetPlatform
      // or return a fallback based on user agent if needed
      return defaultTargetPlatform;
    }

    // For native platforms, use dart:io Platform
    try {
      if (Platform.isAndroid) return TargetPlatform.android;
      if (Platform.isIOS) return TargetPlatform.iOS;
      if (Platform.isWindows) return TargetPlatform.windows;
      if (Platform.isMacOS) return TargetPlatform.macOS;
      if (Platform.isLinux) return TargetPlatform.linux;
    } catch (e) {
      // Fallback: use Flutter's defaultTargetPlatform
      return defaultTargetPlatform;
    }

    // Should not reach here, but just in case
    return defaultTargetPlatform;
  }

  /// Determines if colors should be enabled based on platform and environment
  static bool _shouldEnableColors() {
    // Disable colors on iOS debug to avoid ANSI escape sequences in console
    if (_targetPlatform == TargetPlatform.iOS && kDebugMode) {
      return false;
    }
    // Enable colors for all other cases
    return true;
  }

  /// Determines if bold text should be enabled based on platform and environment
  static bool _shouldEnableBold() {
    // Disable bold on iOS debug to avoid ANSI escape sequences in console
    if (_targetPlatform == TargetPlatform.iOS && kDebugMode) {
      return false;
    }
    // Enable bold for all other cases
    return true;
  }
}
