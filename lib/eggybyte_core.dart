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
    show kIsWeb, kDebugMode, defaultTargetPlatform;
import 'package:flutter/foundation.dart' as flutter show TargetPlatform;

/// Supported target platforms
enum TargetPlatform { android, ios, web, windows, macos, linux }

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
      return TargetPlatform.web;
    }

    // For native platforms, use dart:io Platform
    try {
      if (Platform.isAndroid) return TargetPlatform.android;
      if (Platform.isIOS) return TargetPlatform.ios;
      if (Platform.isWindows) return TargetPlatform.windows;
      if (Platform.isMacOS) return TargetPlatform.macos;
      if (Platform.isLinux) return TargetPlatform.linux;
    } catch (e) {
      // Fallback: try to determine from Flutter's defaultTargetPlatform
      try {
        switch (defaultTargetPlatform) {
          case flutter.TargetPlatform.android:
            return TargetPlatform.android;
          case flutter.TargetPlatform.iOS:
            return TargetPlatform.ios;
          case flutter.TargetPlatform.windows:
            return TargetPlatform.windows;
          case flutter.TargetPlatform.macOS:
            return TargetPlatform.macos;
          case flutter.TargetPlatform.linux:
            return TargetPlatform.linux;
          default:
            return TargetPlatform.web;
        }
      } catch (e) {
        // Ultimate fallback
        return TargetPlatform.web;
      }
    }

    // Should not reach here, but just in case
    return TargetPlatform.web;
  }

  /// Determines if colors should be enabled based on platform and environment
  static bool _shouldEnableColors() {
    // Disable colors on iOS debug to avoid ANSI escape sequences in console
    if (_targetPlatform == TargetPlatform.ios && kDebugMode) {
      return false;
    }
    // Enable colors for all other cases
    return true;
  }

  /// Determines if bold text should be enabled based on platform and environment
  static bool _shouldEnableBold() {
    // Disable bold on iOS debug to avoid ANSI escape sequences in console
    if (_targetPlatform == TargetPlatform.ios && kDebugMode) {
      return false;
    }
    // Enable bold for all other cases
    return true;
  }

  // Deprecated methods (kept for backward compatibility)

  /// Sets the current target platform for the application
  ///
  /// ⚠️ **Deprecated**: Use [initialize()] instead. Platform is now auto-detected.
  @Deprecated(
      'Use EggyByteCore.initialize() instead. Platform is now auto-detected.')
  static void setTargetPlatform(TargetPlatform platform) {
    _targetPlatform = platform;
    LoggingUtils.warning(
        'setTargetPlatform is deprecated. Use EggyByteCore.initialize() for automatic platform detection.');
    LoggingUtils.info(
        'Target platform manually set to: *${platform.name.toUpperCase()}*');
  }
}
