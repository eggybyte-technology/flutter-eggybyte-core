import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import './logging_utils.dart';

/// A utility class for screen-related functionalities.
/// All methods are static as per the guidelines.
class ScreenUtils {
  // Private constructor to prevent instantiation.
  ScreenUtils._();

  /// Gets the physical width of the device screen in logical pixels.
  /// Note: `window.physicalSize` provides dimensions in physical pixels.
  /// `window.devicePixelRatio` is the number of device pixels for each logical pixel.
  /// So, physicalSize.width / devicePixelRatio gives logical pixels.
  static double getDeviceScreenWidth() {
    // Ensure WidgetsBinding is initialized if using this outside of a widget tree early in startup.
    // However, usually, this would be called where binding is available.
    // For direct access to window properties, WidgetsBinding.instance might not be strictly necessary
    // if ui.window is directly accessed, but it's good practice if platform features are used.
    final screenWidth =
        ui.PlatformDispatcher.instance.implicitView!.physicalSize.width /
        ui.PlatformDispatcher.instance.implicitView!.devicePixelRatio;
    LoggingUtils.debug(
      'Device screen width fetched: *$screenWidth* logical pixels.',
    );
    return screenWidth;
  }

  /// Gets the physical height of the device screen in logical pixels.
  static double getDeviceScreenHeight() {
    final screenHeight =
        ui.PlatformDispatcher.instance.implicitView!.physicalSize.height /
        ui.PlatformDispatcher.instance.implicitView!.devicePixelRatio;
    LoggingUtils.debug(
      'Device screen height fetched: *$screenHeight* logical pixels.',
    );
    return screenHeight;
  }

  /// Gets the width of the current widget's BuildContext.
  static double getContextWidth(BuildContext context) {
    final contextWidth = MediaQuery.of(context).size.width;
    LoggingUtils.debug(
      'Context width fetched: *$contextWidth* logical pixels.',
    );
    return contextWidth;
  }

  /// Gets the height of the current widget's BuildContext.
  static double getContextHeight(BuildContext context) {
    final contextHeight = MediaQuery.of(context).size.height;
    LoggingUtils.debug(
      'Context height fetched: *$contextHeight* logical pixels.',
    );
    return contextHeight;
  }
}
