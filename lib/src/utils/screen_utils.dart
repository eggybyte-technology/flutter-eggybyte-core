import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:eggybyte_core/src/utils/logging_utils.dart';

/// A utility class providing screen dimension and display-related functionality.
///
/// This class offers methods to retrieve device screen dimensions both with and without
/// requiring a BuildContext. It uses Flutter's modern platform dispatcher API for
/// accessing screen information without context, and MediaQuery for context-aware
/// dimensions that respect widget tree settings (padding, safe areas, etc.).
///
/// All methods are static as per the utility class guidelines.
///
/// Features:
/// - Device screen dimensions without BuildContext
/// - Context-aware screen dimensions via MediaQuery
/// - Robust error handling with fallback values
/// - Support for all Flutter platforms (Android, iOS, Web, Windows, macOS, Linux)
///
/// Example usage:
/// ```dart
/// // Without BuildContext
/// final deviceWidth = ScreenUtils.getDeviceScreenWidth();
///
/// // With BuildContext (preferred in widgets)
/// Widget build(BuildContext context) {
///   final contextWidth = ScreenUtils.getContextWidth(context);
///   return Container(width: contextWidth);
/// }
/// ```
class ScreenUtils {
  /// Private constructor to prevent instantiation of this utility class.
  /// All methods are static and should be called directly on the class.
  ScreenUtils._();

  /// Retrieves the physical width of the device screen in logical pixels without requiring a BuildContext.
  ///
  /// This method uses Flutter's platform dispatcher to access the first available view
  /// and calculates the screen width by dividing the physical pixel width by the device
  /// pixel ratio to obtain logical pixels.
  ///
  /// Returns:
  /// The screen width in logical pixels. Returns `0.0` if no view is available or
  /// if an error occurs during retrieval.
  ///
  /// Throws:
  /// May throw an exception if called before Flutter binding is initialized or if
  /// the platform dispatcher is not available.
  ///
  /// Example:
  /// ```dart
  /// final width = ScreenUtils.getDeviceScreenWidth();
  /// print('Screen width: $width'); // e.g., "414.0" for iPhone 12
  /// ```
  ///
  /// Note: For widget context-aware dimensions, prefer [getContextWidth] which respects
  /// MediaQuery settings like padding and safe areas.
  static double getDeviceScreenWidth() {
    try {
      // Get all available views from the platform dispatcher
      final views = ui.PlatformDispatcher.instance.views;

      // Check if any views are available
      if (views.isEmpty) {
        LoggingUtils.warning(
          'No view available for screen width detection. Returning 0.0.',
        );
        return 0.0;
      }

      // Use the first available view (typically the main window)
      final view = views.first;

      // Calculate logical pixels by dividing physical pixels by device pixel ratio
      // Logical pixels are the Flutter coordinate system units
      final screenWidth = view.physicalSize.width / view.devicePixelRatio;

      LoggingUtils.debug(
        'Device screen width fetched: *$screenWidth* logical pixels.',
      );
      return screenWidth;
    } catch (e, stackTrace) {
      // Log error and return safe fallback value
      LoggingUtils.error(
        'Failed to get device screen width: $e',
        stackTrace: stackTrace,
      );
      return 0.0;
    }
  }

  /// Retrieves the physical height of the device screen in logical pixels without requiring a BuildContext.
  ///
  /// This method uses Flutter's platform dispatcher to access the first available view
  /// and calculates the screen height by dividing the physical pixel height by the device
  /// pixel ratio to obtain logical pixels.
  ///
  /// Returns:
  /// The screen height in logical pixels. Returns `0.0` if no view is available or
  /// if an error occurs during retrieval.
  ///
  /// Throws:
  /// May throw an exception if called before Flutter binding is initialized or if
  /// the platform dispatcher is not available.
  ///
  /// Example:
  /// ```dart
  /// final height = ScreenUtils.getDeviceScreenHeight();
  /// print('Screen height: $height'); // e.g., "896.0" for iPhone 12
  /// ```
  ///
  /// Note: For widget context-aware dimensions, prefer [getContextHeight] which respects
  /// MediaQuery settings like padding and safe areas.
  static double getDeviceScreenHeight() {
    try {
      // Get all available views from the platform dispatcher
      final views = ui.PlatformDispatcher.instance.views;

      // Check if any views are available
      if (views.isEmpty) {
        LoggingUtils.warning(
          'No view available for screen height detection. Returning 0.0.',
        );
        return 0.0;
      }

      // Use the first available view (typically the main window)
      final view = views.first;

      // Calculate logical pixels by dividing physical pixels by device pixel ratio
      // Logical pixels are the Flutter coordinate system units
      final screenHeight = view.physicalSize.height / view.devicePixelRatio;

      LoggingUtils.debug(
        'Device screen height fetched: *$screenHeight* logical pixels.',
      );
      return screenHeight;
    } catch (e, stackTrace) {
      // Log error and return safe fallback value
      LoggingUtils.error(
        'Failed to get device screen height: $e',
        stackTrace: stackTrace,
      );
      return 0.0;
    }
  }

  /// Gets the width of the current widget's BuildContext.
  ///
  /// This method retrieves the screen width from the MediaQuery associated
  /// with the given BuildContext. This is the preferred method when you
  /// have access to a BuildContext as it respects the widget tree's
  /// MediaQuery settings (like padding, safe areas, etc.).
  ///
  /// Parameters:
  /// - [context]: The BuildContext to get the screen width from.
  ///
  /// Returns:
  /// The screen width in logical pixels from the MediaQuery.
  ///
  /// Example:
  /// ```dart
  /// class MyWidget extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final width = ScreenUtils.getContextWidth(context);
  ///     return Container(width: width);
  ///   }
  /// }
  /// ```
  static double getContextWidth(BuildContext context) {
    final contextWidth = MediaQuery.of(context).size.width;
    LoggingUtils.debug(
      'Context width fetched: *$contextWidth* logical pixels.',
    );
    return contextWidth;
  }

  /// Gets the height of the current widget's BuildContext.
  ///
  /// This method retrieves the screen height from the MediaQuery associated
  /// with the given BuildContext. This is the preferred method when you
  /// have access to a BuildContext as it respects the widget tree's
  /// MediaQuery settings (like padding, safe areas, etc.).
  ///
  /// Parameters:
  /// - [context]: The BuildContext to get the screen height from.
  ///
  /// Returns:
  /// The screen height in logical pixels from the MediaQuery.
  ///
  /// Example:
  /// ```dart
  /// class MyWidget extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final height = ScreenUtils.getContextHeight(context);
  ///     return Container(height: height);
  ///   }
  /// }
  /// ```
  static double getContextHeight(BuildContext context) {
    final contextHeight = MediaQuery.of(context).size.height;
    LoggingUtils.debug(
      'Context height fetched: *$contextHeight* logical pixels.',
    );
    return contextHeight;
  }
}
