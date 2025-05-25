<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# EggyByte Core

[![pub package](https://img.shields.io/pub/v/eggybyte_core.svg)](https://pub.dev/packages/eggybyte_core)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20windows%20%7C%20macos%20%7C%20linux-blue)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A foundational Flutter package providing essential utilities and core functionalities for EggyByte Technology applications.

## ✨ Key Features

- **🚀 One-Line Initialization**: Automatic platform detection and optimal configuration
- **🎯 Smart Logging**: Platform-aware logging with automatic ANSI escape sequence handling
- **🔍 Optimized Debug Output**: Debug logs only appear in debug mode for better performance
- **📋 Complete Network Debugging**: Full HTTP response logging for comprehensive debugging
- **🌐 Universal Platform Support**: Android, iOS, Web, Windows, macOS, Linux
- **📱 Screen Utilities**: Device and context-aware screen dimension utilities
- **💾 Storage Management**: Persistent file storage with error handling
- **📊 Data Formatting**: Time, date, and number formatting with Chinese locale support
- **🌐 Network Operations**: HTTP client with Bearer token authentication
- **🧪 Comprehensive Testing**: 41+ unit tests ensuring reliability

## 🚀 Quick Start

### Installation

Add `eggybyte_core` to your `pubspec.yaml`:

```yaml
dependencies:
  eggybyte_core: ^1.0.4
```

Then run:
```bash
flutter pub get
```

### Basic Usage - New Simplified API

**Step 1: One-line initialization (New in v1.0.3)**
```dart
import 'package:eggybyte_core/eggybyte_core.dart';

void main() {
  // 🎉 That's it! Automatic platform detection and optimal configuration
  EggyByteCore.initialize();
  
  runApp(MyApp());
}
```

**Step 2: Start using utilities immediately**
```dart
void exampleUsage() {
  // Logging - automatically configured for your platform
  LoggingUtils.info('Application started successfully');
  LoggingUtils.warning('This is a warning message');
  LoggingUtils.error('Error occurred', stackTrace: StackTrace.current);
  
  // Native platform logging
  final platformPrefix = EggyByteCore.getPlatformPrefix(); // e.g., "ANDROID NATIVE"
  LoggingUtils.nativeInfo('Native operation completed', platformPrefix: platformPrefix);
  
  // Date and time formatting
  final now = DateTime.now();
  final chineseTime = FormatUtils.formatTimeChineseSeparated(now); // "14时30分55秒"
  final chineseDate = FormatUtils.formatDateChineseSeparated(now); // "2023年10月27日"
  
  // Number formatting with Chinese units
  final formattedNumber = FormatUtils.formatNumberWithUnits(12345); // "1.23万"
  
  LoggingUtils.info('Formatted time: *$chineseTime*, number: *$formattedNumber*');
}
```

### Advanced Configuration (Optional)

```dart
// Custom logging configuration
EggyByteCore.initialize(
  enableColors: false,  // Disable colors manually
  enableBold: true,     // Keep bold formatting
);

// Or reconfigure after initialization
EggyByteCore.configureLogging(enableColors: true, enableBold: false);
```

### Platform Detection

The library automatically detects your platform and applies optimal settings:

```dart
void showPlatformInfo() {
  EggyByteCore.initialize();
  
  final platform = EggyByteCore.getTargetPlatform(); // Auto-detected: android, ios, web, etc.
  final prefix = EggyByteCore.getPlatformPrefix();   // e.g., "IOS NATIVE"
  
  LoggingUtils.info('Running on: *${platform?.name.toUpperCase()}*');
}
```

## 🛠️ Comprehensive Utilities

### 📝 LoggingUtils - Smart Logging System

```dart
// Basic logging
LoggingUtils.info('Info message with *bold* keywords');
LoggingUtils.warning('Warning message');
LoggingUtils.error('Error message', stackTrace: StackTrace.current);
LoggingUtils.debug('Debug information'); // Only outputs in debug mode (kDebugMode)

// Native platform logging - automatically uses platform prefix
LoggingUtils.nativeInfo('iOS operation'); // Automatically gets platform prefix
LoggingUtils.nativeError('Android error', platformPrefix: 'CUSTOM NATIVE'); // Override if needed

// Configure formatting (colors automatically disabled on iOS debug)
LoggingUtils.configureFormatting(enableColors: true, enableBold: true);
```

**✨ Debug Optimization (New in v1.0.4)**: Debug logs are automatically suppressed in release builds for optimal performance.

### 🌐 NetworkUtils - HTTP Client

```dart
// Bearer token management
NetworkUtils.setBearerToken('your_api_token');

// HTTP requests with full response logging
try {
  final response = await NetworkUtils.get(
    'https://api.example.com/data',
    headers: {'Custom-Header': 'value'},
    queryParameters: {'page': '1', 'limit': '10'},
  );
  LoggingUtils.info('Response: ${response.statusCode}');
  // Complete response body is now logged for debugging (v1.0.4+)
} catch (e) {
  LoggingUtils.error('Request failed: $e');
}

// POST request
final postResponse = await NetworkUtils.post(
  'https://api.example.com/create',
  body: {'name': 'EggyByte', 'type': 'technology'},
);

NetworkUtils.clearBearerToken();
```

**🔍 Enhanced Debugging (New in v1.0.4)**: HTTP responses are now logged in full without character limits for comprehensive debugging.

### 📱 ScreenUtils - Screen Dimensions

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Device screen dimensions
    final deviceWidth = ScreenUtils.getDeviceScreenWidth();
    final deviceHeight = ScreenUtils.getDeviceScreenHeight();
    
    // Context-specific dimensions
    final contextWidth = ScreenUtils.getContextWidth(context);
    final contextHeight = ScreenUtils.getContextHeight(context);
    
    LoggingUtils.debug('Device: ${deviceWidth}x$deviceHeight, Context: ${contextWidth}x$contextHeight');
    
    return Container(/* ... */);
  }
}
```

### 💾 StorageUtils - File Management

```dart
Future<void> storageExample() async {
  try {
    // Save data
    await StorageUtils.saveToFile('user_data.json', '{"name": "EggyByte"}');
    LoggingUtils.info('Data saved successfully');
    
    // Read data
    final content = await StorageUtils.readFromFile('user_data.json');
    if (content != null) {
      LoggingUtils.info('Read data: *$content*');
    }
    
    // Delete file
    final deleted = await StorageUtils.deleteFile('user_data.json');
    LoggingUtils.info('File deleted: *$deleted*');
  } catch (e) {
    LoggingUtils.error('Storage operation failed: $e');
  }
}
```

### 📊 FormatUtils - Data Formatting

```dart
void formattingExamples() {
  final now = DateTime.now();
  
  // Time formatting
  final timeColon = FormatUtils.formatTimeSymbolSeparated(now); // "14:30:55"
  final timeDash = FormatUtils.formatTimeSymbolSeparated(now, separator: '-'); // "14-30-55"
  final timeChinese = FormatUtils.formatTimeChineseSeparated(now); // "14时30分55秒"
  
  // Date formatting
  final dateDefault = FormatUtils.formatDateSymbolSeparated(now); // "2023-10-27"
  final dateSlash = FormatUtils.formatDateSymbolSeparated(now, separator: '/'); // "2023/10/27"
  final dateChinese = FormatUtils.formatDateChineseSeparated(now); // "2023年10月27日"
  
  // Number formatting
  final decimal = FormatUtils.formatNumberDecimalPlaces(123.456, 2); // "123.46"
  final withUnits = FormatUtils.formatNumberWithUnits(12345); // "1.23万"
  final bigNumber = FormatUtils.formatNumberWithUnits(123456789); // "1.23亿"
  
  LoggingUtils.info('Formatted: time=*$timeChinese*, date=*$dateChinese*, number=*$withUnits*');
}
```

## 🔧 Migration Guide

### From v1.0.3 to v1.0.4

**No breaking changes** - this is a feature enhancement release:

✅ **Enhanced Debugging**: Debug logs now automatically respect debug/release mode
✅ **Better Network Debugging**: Full HTTP response logging
✅ **Improved Performance**: Debug logs are skipped in release builds

No code changes required for existing implementations.

### From v1.0.2 to v1.0.3+

If you're upgrading from v1.0.2, here's how to migrate:

**Old API (still supported but deprecated):**
```dart
// ❌ Manual platform configuration (deprecated)
EggyByteCore.setTargetPlatform(TargetPlatform.android);
EggyByteCore.configureLogging(enableColors: false, enableBold: false);
```

**New API (recommended):**
```dart
// ✅ Automatic platform detection and configuration
EggyByteCore.initialize(); // Automatically handles iOS ANSI escape issues!

// Or with custom settings
EggyByteCore.initialize(enableColors: false, enableBold: true);
```

## 🧪 Testing

The library includes comprehensive tests covering all functionality:

```bash
flutter test
```

**Test Coverage:**
- ✅ 41+ unit tests
- ✅ Automatic platform detection
- ✅ Logging system with native platform support
- ✅ All utility modules (Format, Network, Storage, Screen)
- ✅ Integration tests
- ✅ Backward compatibility

## 🎯 Platform Support

| Platform | Status | Auto-Detection | ANSI Colors |
|----------|--------|----------------|-------------|
| **Android** | ✅ Full Support | ✅ | ✅ |
| **iOS** | ✅ Full Support | ✅ | 🔄 Auto-disabled in debug |
| **Web** | ✅ Full Support | ✅ | ✅ |
| **Windows** | ✅ Full Support | ✅ | ✅ |
| **macOS** | ✅ Full Support | ✅ | ✅ |
| **Linux** | ✅ Full Support | ✅ | ✅ |

## 📖 API Documentation

### EggyByteCore

| Method | Description |
|--------|-------------|
| `initialize({bool? enableColors, bool? enableBold})` | **Auto-detects platform and configures optimal settings** |
| `isInitialized` | Checks if the library has been initialized |
| `getTargetPlatform()` | Returns the auto-detected platform |
| `getPlatformPrefix()` | Returns platform-specific prefix for native logging |
| `configureLogging({bool enableColors, bool enableBold})` | Manually reconfigure logging |
| `reset()` | Reset initialization state (mainly for testing) |

### LoggingUtils

| Method | Description |
|--------|-------------|
| `info(String message)` | Log info message |
| `warning(String message)` | Log warning message |
| `error(String message, {StackTrace? stackTrace})` | Log error with optional stack trace |
| `debug(String message)` | Log debug message |
| `nativeInfo/Warning/Error/Debug(String message, {String? platformPrefix})` | Platform-specific native logging |

### FormatUtils

| Method | Description |
|--------|-------------|
| `formatTimeSymbolSeparated(DateTime time, {String separator = ':'})` | Format time with custom separator |
| `formatTimeChineseSeparated(DateTime time)` | Format time in Chinese style |
| `formatDateSymbolSeparated(DateTime date, {String separator = '-'})` | Format date with custom separator |
| `formatDateChineseSeparated(DateTime date)` | Format date in Chinese style |
| `formatNumberDecimalPlaces(double number, int decimalPlaces)` | Format number with specific decimal places |
| `formatNumberWithUnits(double number, {int decimalPlaces = 2})` | Format number with Chinese units (万, 亿) |

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏢 About EggyByte Technology

EggyByte Core is maintained by [EggyByte Technology](https://eggybyte.com). We build innovative software solutions with cutting-edge technology.

---

**Happy coding! 🥳**
