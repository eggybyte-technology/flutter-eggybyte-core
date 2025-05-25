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
[![style: flutter lints](https://img.shields.io/badge/style-flutter__lints-blue)](https://pub.dev/packages/flutter_lints)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A foundational Flutter package for EggyByte Technology, providing a collection of common utilities and core functionalities including logging, networking, screen utilities, storage, and formatting.

## ✨ Features

- **🔍 Centralized Logging**: Rich, configurable logging with color support and platform-specific native logging
- **🌐 Network Utilities**: HTTP client with Bearer token authentication and WebSocket support  
- **📱 Screen Utilities**: Device and context dimension helpers
- **💾 Storage Utilities**: Persistent file storage operations
- **📅 Format Utilities**: Time, date, and number formatting with Chinese localization
- **⚙️ Platform Configuration**: Target platform detection and configuration

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  eggybyte_core: ^1.0.1
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

```dart
import 'package:eggybyte_core/eggybyte_core.dart';

void main() {
  // Configure the core library
  EggyByteCore.setTargetPlatform(TargetPlatform.android);
  EggyByteCore.configureLogging(
    enableColors: true,
    enableBold: true,
  );

  // Start using the utilities
  LoggingUtils.info('Application *started* successfully!');
}
```

## 📖 Documentation

### Configuration

#### Platform Setup
```dart
// Set the target platform
EggyByteCore.setTargetPlatform(TargetPlatform.android);

// Configure logging appearance
EggyByteCore.configureLogging(
  enableColors: true,  // Enable ANSI colors (disable for some IDEs)
  enableBold: true,    // Enable bold text formatting
);
```

### Logging Utilities

#### Basic Logging
```dart
// Standard log levels
LoggingUtils.info('This is an *info* message');
LoggingUtils.warning('This is a *warning* message');
LoggingUtils.error('This is an *error* message');
LoggingUtils.debug('This is a *debug* message');
```

#### Native Platform Logging
```dart
// Log with platform prefix
LoggingUtils.nativeInfo('SDK initialized', platformPrefix: 'ANDROID NATIVE');
LoggingUtils.nativeError('Connection failed', platformPrefix: 'IOS NATIVE');

// Or use the configured platform automatically
final prefix = EggyByteCore.getPlatformPrefix(); // Returns "ANDROID NATIVE"
LoggingUtils.nativeDebug('Native method called', platformPrefix: prefix);
```

### Network Utilities

#### HTTP Operations
```dart
// Set Bearer token for authentication
NetworkUtils.setBearerToken('your-auth-token');

// GET request
final response = await NetworkUtils.get(
  'https://api.example.com/data',
  queryParameters: {'page': '1', 'limit': '10'},
);

// POST request
final postResponse = await NetworkUtils.post(
  'https://api.example.com/users',
  body: {'name': 'John', 'email': 'john@example.com'},
);

// Clear token when needed
NetworkUtils.clearBearerToken();
```

### Screen Utilities

```dart
// Get device screen dimensions
final screenWidth = ScreenUtils.getDeviceScreenWidth();
final screenHeight = ScreenUtils.getDeviceScreenHeight();

// Get context dimensions (in a Widget)
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contextWidth = ScreenUtils.getContextWidth(context);
    final contextHeight = ScreenUtils.getContextHeight(context);
    
    return Container(
      width: contextWidth * 0.8,
      height: contextHeight * 0.6,
      child: Text('Responsive Widget'),
    );
  }
}
```

### Storage Utilities

```dart
// Save data to file
await StorageUtils.saveToFile('user_data.json', jsonEncode(userData));

// Read data from file
final content = await StorageUtils.readFromFile('user_data.json');
if (content != null) {
  final userData = jsonDecode(content);
}

// Delete file
final deleted = await StorageUtils.deleteFile('temp_data.txt');
```

### Format Utilities

#### Time Formatting
```dart
final now = DateTime.now();

// Symbol-separated time: "14:30:55"
final timeSymbol = FormatUtils.formatTimeSymbolSeparated(now);

// Chinese time format: "14时30分55秒"
final timeChinese = FormatUtils.formatTimeChineseSeparated(now);
```

#### Date Formatting
```dart
final today = DateTime.now();

// Symbol-separated date: "2023-10-27"
final dateSymbol = FormatUtils.formatDateSymbolSeparated(today);

// Chinese date format: "2023年10月27日"
final dateChinese = FormatUtils.formatDateChineseSeparated(today);
```

#### Number Formatting
```dart
// Decimal places: "123.46"
final formatted = FormatUtils.formatNumberDecimalPlaces(123.456, 2);

// Chinese units: "1.2万", "1.5亿"
final withUnits1 = FormatUtils.formatNumberWithUnits(12000); // "1.20万"
final withUnits2 = FormatUtils.formatNumberWithUnits(150000000); // "1.50亿"
```

## 🎯 Platform Support

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Guidelines

1. **Language**: All code, comments, and logs must be in English
2. **Architecture**: All utilities must be implemented as static methods
3. **Logging**: All methods must use the centralized `LoggingUtils`
4. **Testing**: Write comprehensive tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏢 About EggyByte Technology

EggyByte Technology is committed to creating high-quality, reusable Flutter components and utilities. This core library serves as the foundation for our Flutter applications and packages.

## 📞 Support

- 📧 Email: support@eggybyte.tech
- 🐛 Issues: [GitHub Issues](https://github.com/eggybyte-technology/flutter-eggybyte-core/issues)
- 📖 Documentation: [API Reference](https://pub.dev/documentation/eggybyte_core/latest/)

---

Made with ❤️ by [EggyByte Technology](https://github.com/eggybyte-technology)
