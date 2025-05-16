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

<div align="center">
  <img src="https://img.shields.io/badge/version-0.0.1-green.svg" alt="Version 0.0.1">
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License MIT">
  <img src="https://img.shields.io/badge/Flutter-%3E%3D1.17.0-blue.svg" alt="Flutter >=1.17.0">
  <img src="https://img.shields.io/badge/Dart-%3E%3D2.19.0%20%3C4.0.0-purple.svg" alt="Dart >=2.19.0 <4.0.0">
</div>

# eggybyte_core

A foundational Flutter package for EggyByte Technology, providing a collection of common utilities and core functionalities.

**Core Principle:** Wherever possible, this library should integrate and utilize pre-existing, verified implementations from EggyByte Technology's internal resources rather than reimplementing functionality from scratch.

## 🌟 Key Modules and Features

Based on the development guidelines, this package provides the following core utilities:

*   **Unified Logging (`LoggingUtils`)**:
    *   Centralized logging mechanism.
    *   Formatted output: `time [log_type] message`.
    *   Customizable colors for timestamp and log types.
    *   Emphasis for important keywords within messages.
    *   Distinct handling for error logs including stack traces.
*   **Networking Utilities (`NetworkUtils`)**:
    *   **HTTP Client**:
        *   Static methods for `GET`, `POST` requests (extendable for `PUT`, `DELETE`, etc.).
        *   Customizable headers, body, and query parameters.
        *   Global Bearer token management: `setBearerToken(String token)`, `clearBearerToken()`.
    *   **WebSocket Client**:
        *   Functionality to establish and manage WebSocket connections.
        *   Methods for connecting, sending/receiving messages, and disconnecting.
*   **Screen Utilities (`ScreenUtils`)**:
    *   `getDeviceScreenWidth()`: Physical width of the device screen.
    *   `getDeviceScreenHeight()`: Physical height of the device screen.
    *   `getContextWidth(BuildContext context)`: Width of the current widget's `BuildContext`.
    *   `getContextHeight(BuildContext context)`: Height of the current widget's `BuildContext`.
*   **Storage Utilities (`StorageUtils`)**:
    *   `saveToFile(String fileName, String content)`: Persistently saves string content to a file.
    *   `readFromFile(String fileName)`: Reads string content from a file, with graceful error handling for non-existent files.
*   **Formatting Utilities (`FormatUtils`)**:
    *   **Time Formatting**:
        *   `formatTimeSymbolSeparated(DateTime time, String separator = ':')` (e.g., "14:30:55")
        *   `formatTimeChineseSeparated(DateTime time)` (e.g., "14时30分55秒")
    *   **Date Formatting**:
        *   `formatDateSymbolSeparated(DateTime date, String separator = '-')` (e.g., "2023-10-27")
        *   `formatDateChineseSeparated(DateTime date)` (e.g., "2023年10月27日")
    *   **Number Formatting**:
        *   `formatNumberDecimalPlaces(double number, int decimalPlaces)`
        *   `formatNumberWithUnits(double number, {int decimalPlaces = 2})` (e.g., 12000 -> "1.2万", 120000000 -> "1.2亿")

## 🚀 Getting Started

### 📋 Prerequisites

| Requirement | Version             | Purpose                                  |
|-------------|---------------------|------------------------------------------|
| Flutter SDK | `>=1.17.0`          | Flutter application development          |
| Dart SDK    | `>=2.19.0 <4.0.0`   | Dart language support                    |

### 🔧 Installation

1.  Add `eggybyte_core` to your `pubspec.yaml` dependencies:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      eggybyte_core: ^0.0.1 # Replace with the latest version from pub.dev
    ```

2.  Install the package by running the following command in your project's root directory:

    ```bash
    flutter pub get
    ```

## 💻 Usage Examples

Import the main library or specific utilities as needed:

```dart
// Import all utilities (assuming a central export file `eggybyte_core.dart`)
import 'package:eggybyte_core/eggybyte_core.dart';

// Or import individual utilities if preferred:
// import 'package:eggybyte_core/src/utils/logging_utils.dart';
// import 'package:eggybyte_core/src/utils/network_utils.dart';
// import 'package:eggybyte_core/src/utils/screen_utils.dart';
// import 'package:eggybyte_core/src/utils/storage_utils.dart';
// import 'package:eggybyte_core/src/utils/format_utils.dart';
```

### Logging Example

```dart
// Ensure LoggingUtils is initialized if required by its implementation.
LoggingUtils.info('User logged in: **user_id_123**');
LoggingUtils.warning('Low disk space detected.');
try {
  throw Exception('Something went wrong!');
} catch (e, s) {
  LoggingUtils.error('Critical operation failed', error: e, stackTrace: s);
}
```

### Network Example

```dart
Future<void> fetchData() async {
  NetworkUtils.setBearerToken('your_secure_bearer_token');
  try {
    final response = await NetworkUtils.get(
      'https://api.example.com/data',
      queryParameters: {'page': '1', 'limit': '10'},
    );
    // Process response.data (assuming your NetworkUtils parses JSON or returns response body)
    LoggingUtils.info('Data fetched successfully: ${response.body}');
  } catch (e) {
    LoggingUtils.error('Failed to fetch data', error: e);
  }
}

Future<void> postData() async {
  try {
    final response = await NetworkUtils.post(
      'https://api.example.com/submit',
      body: {'name': 'EggyByte Core', 'status': 'active'},
    );
    LoggingUtils.info('Data posted, response: ${response.body}');
  } catch (e) {
    LoggingUtils.error('Failed to post data', error: e);
  }
}
```

### Screen Utilities Example (within a Flutter Widget)

```dart
// In a StatefulWidget or StatelessWidget build method:
// @override
// Widget build(BuildContext context) {
//   final double deviceWidth = ScreenUtils.getDeviceScreenWidth();
//   final double deviceHeight = ScreenUtils.getDeviceScreenHeight();
//   LoggingUtils.info('Device Screen: ${deviceWidth}w x ${deviceHeight}h');

//   final double contextWidth = ScreenUtils.getContextWidth(context);
//   final double contextHeight = ScreenUtils.getContextHeight(context);
//   LoggingUtils.info('Current Context: ${contextWidth}w x ${contextHeight}h');
   
//   return Container(); // Your widget UI
// }
```

### Storage Utilities Example

```dart
Future<void> manageLocalData() async {
  const String myFile = 'user_settings.json';
  final String settingsJson = '{"theme": "dark", "notifications": true}';

  bool saved = await StorageUtils.saveToFile(myFile, settingsJson);
  if (saved) {
    LoggingUtils.info('Settings saved to $myFile');
  } else {
    LoggingUtils.error('Failed to save settings to $myFile');
  }

  String? retrievedSettings = await StorageUtils.readFromFile(myFile);
  if (retrievedSettings != null) {
    LoggingUtils.info('Retrieved settings: $retrievedSettings');
  } else {
    LoggingUtils.warning('No settings found in $myFile or failed to read.');
  }
}
```

### Formatting Utilities Example

```dart
void demonstrateFormatting() {
  final DateTime now = DateTime.now();

  LoggingUtils.info('Time (Symbol): ${FormatUtils.formatTimeSymbolSeparated(now)}');
  LoggingUtils.info('Time (Chinese): ${FormatUtils.formatTimeChineseSeparated(now)}');

  LoggingUtils.info('Date (Symbol): ${FormatUtils.formatDateSymbolSeparated(now)}');
  LoggingUtils.info('Date (Chinese): ${FormatUtils.formatDateChineseSeparated(now)}');

  double complexNumber = 1234567.8912;
  LoggingUtils.info('Number (2 Decimals): ${FormatUtils.formatNumberDecimalPlaces(complexNumber, 2)}');
  LoggingUtils.info('Number (Units): ${FormatUtils.formatNumberWithUnits(complexNumber)}'); // e.g., 123.46万
  LoggingUtils.info('Number (Units Large): ${FormatUtils.formatNumberWithUnits(123456789.0)}'); // e.g., 1.23亿
}
```
*(Note: Actual implementation of these examples depends on the final utility method signatures and error handling.)*

## 📚 API Documentation

Detailed API documentation can be generated using the standard Dart documentation tool:

```bash
dart doc .
```

This will generate an HTML documentation site in the `doc/api` directory.
When published to [pub.dev](https://pub.dev/), the API documentation will also be available there.

## 📁 Project Structure

```
eggybyte_core/
├── .dart_tool/
├── .idea/
├── lib/
│   ├── eggybyte_core.dart    # Main export file for the package
│   └── src/                  # Internal source code
│       ├── utils/            # Core utility modules
│       │   ├── format_utils.dart
│       │   ├── logging_utils.dart
│       │   ├── network_utils.dart
│       │   ├── screen_utils.dart
│       │   └── storage_utils.dart
│       └── ...               # Other internal components (e.g., models, constants)
├── test/                     # Unit and widget tests
├── .gitignore
├── analysis_options.yaml
├── CHANGELOG.md
├── LICENSE                   # MIT License file
├── pubspec.lock
├── pubspec.yaml              # Package manifest
└── README.md                 # This file
```

## 🤝 Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:

1.  **Adhere to Guidelines**: Ensure your contributions align with the `eggybyte_core_guidelines.mdc` and coding standards (English for code/comments, static utils, logging).
2.  **Fork the Repository**: Click the 'Fork' button at the top right of this page.
3.  **Clone Your Fork**: `git clone https://github.com/YOUR_USERNAME/eggybyte_core.git`
4.  **Create a Branch**: `git checkout -b feature/your-amazing-feature`
5.  **Make Your Changes**: Implement your feature or bug fix.
6.  **Add Logging**: Ensure comprehensive logging is added for new functionalities as per guidelines.
7.  **Test Your Changes**: Add relevant tests and ensure all tests pass.
8.  **Commit Your Changes**: `git commit -m 'feat: Add some amazing feature'` (follow conventional commit messages if applicable).
9.  **Push to the Branch**: `git push origin feature/your-amazing-feature`
10. **Open a Pull Request**: Go to the original repository and open a new pull request.

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <p>Developed by EggyByte Technology • 2025</p>
</div>
