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

# eggybyte_core

A foundational Flutter package for EggyByte Technology, providing a collection of common utilities and core functionalities.

**Core Principle:** Wherever possible, this library should integrate and utilize pre-existing, verified implementations from EggyByte Technology's internal resources rather than reimplementing functionality from scratch.

## Features

Based on the development guidelines, this package aims to provide:

*   **Unified Logging (`LoggingUtils`)**: Centralized logging with formatted output (timestamps, log types with colors, bolded keywords).
*   **Networking Utilities (`NetworkUtils`)**: 
    *   HTTP client with GET/POST methods, header/body customization, and Bearer token management.
    *   WebSocket client functionalities.
*   **Screen Utilities (`ScreenUtils`)**: Get device and context screen dimensions.
*   **Storage Utilities (`StorageUtils`)**: Persistent file storage (save/read string content).
*   **Formatting Utilities (`FormatUtils`)**: 
    *   Time formatting (symbol-separated, Chinese-separated).
    *   Date formatting (symbol-separated, Chinese-separated).
    *   Number formatting (decimal places, Chinese units like "万", "亿").

## Getting Started

### Prerequisites

*   Flutter SDK: >=1.17.0 (Ensure your Flutter version matches or is higher)
*   Dart SDK: >=2.19.0 <4.0.0

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  eggybyte_core: ^0.0.1 # Replace with the latest version
```

Then, run `flutter pub get` in your terminal.

## Usage

Import the necessary utility classes:

```dart
import 'package:eggybyte_core/eggybyte_core.dart'; // This might change based on your export structure
// Or import specific utilities:
// import 'package:eggybyte_core/src/utils/logging_utils.dart';
// import 'package:eggybyte_core/src/utils/network_utils.dart';
// import 'package:eggybyte_core/src/utils/screen_utils.dart';
// import 'package:eggybyte_core/src/utils/storage_utils.dart';
// import 'package:eggybyte_core/src/utils/format_utils.dart';
```

### Logging Example

```dart
// Assuming LoggingUtils is set up as per guidelines
// LoggingUtils.info('This is an informational message with **important** data.');
// LoggingUtils.warning('This is a warning.');
// LoggingUtils.error('An error occurred!', stackTrace: StackTrace.current);
```

### Network Example

```dart
// Initialize NetworkUtils if needed (e.g., setting base URL or default headers)
// NetworkUtils.setBearerToken('your_jwt_token');

// try {
//   final response = await NetworkUtils.get('https://api.example.com/data');
//   print(response.body);
// } catch (e) {
//   LoggingUtils.error('API call failed: $e');
// }

// final postData = {'name': 'EggyByte', 'type': 'Core'};
// try {
//   final response = await NetworkUtils.post(
//     'https://api.example.com/submit',
//     body: postData,
//   );
//   print(response.body);
// } catch (e) {
//   LoggingUtils.error('API post failed: $e');
// }
```

### Screen Utilities Example

```dart
// final screenWidth = ScreenUtils.getDeviceScreenWidth();
// final screenHeight = ScreenUtils.getDeviceScreenHeight();
// LoggingUtils.info('Device dimensions: $screenWidth x $screenHeight');

// In a widget:
// final contextWidth = ScreenUtils.getContextWidth(context);
// final contextHeight = ScreenUtils.getContextHeight(context);
// LoggingUtils.info('Widget context dimensions: $contextWidth x $contextHeight');
```

### Storage Utilities Example

```dart
// const fileName = 'my_data.txt';
// const content = 'Hello from EggyByte Core Storage!';

// await StorageUtils.saveToFile(fileName, content);
// LoggingUtils.info('Content saved to $fileName');

// final readContent = await StorageUtils.readFromFile(fileName);
// if (readContent != null) {
//   LoggingUtils.info('Content read from $fileName: $readContent');
// } else {
//   LoggingUtils.warning('Could not read $fileName or file does not exist.');
// }
```

### Formatting Utilities Example

```dart
// final now = DateTime.now();

// LoggingUtils.info(FormatUtils.formatTimeSymbolSeparated(now)); // e.g., 14:30:55
// LoggingUtils.info(FormatUtils.formatTimeChineseSeparated(now)); // e.g., 14时30分55秒

// LoggingUtils.info(FormatUtils.formatDateSymbolSeparated(now)); // e.g., 2023-10-27
// LoggingUtils.info(FormatUtils.formatDateChineseSeparated(now)); // e.g., 2023年10月27日

// LoggingUtils.info(FormatUtils.formatNumberDecimalPlaces(123.4567, 2)); // 123.46
// LoggingUtils.info(FormatUtils.formatNumberWithUnits(12000)); // 1.2万
// LoggingUtils.info(FormatUtils.formatNumberWithUnits(120000000)); // 1.2亿
```

## Contributing

Contributions are welcome! Please adhere to the coding standards outlined in the development guidelines and ensure all code includes appropriate logging.

1.  Fork the repository.
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
*This README was generated based on `eggybyte_core_guidelines.mdc`.*
