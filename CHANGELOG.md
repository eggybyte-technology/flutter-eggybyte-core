## 1.1.1

### Changed
- **Platform-Aware Color Output Enhancement**:
  - Colors are now automatically disabled for non-web platforms in `EggyByteCore.initialize()`
  - Improved `_shouldEnableColors()` method to automatically check `kIsWeb` platform
  - Default color setting changed to `false` to prevent ANSI escape sequence display issues on native platforms
  - Colors are automatically enabled only for web platforms, preventing garbled text in iOS/Android console logs

### Fixed
- Fixed ANSI escape sequence display issues on non-web platforms (iOS, Android) by defaulting colors to disabled
- Improved automatic platform detection for color output configuration

### Technical Improvements
- Better platform-aware initialization defaults
- Enhanced developer experience with automatic platform optimization

## 1.2.0

### Changed
- **Simplified Logging System**:
  - Removed support for asterisk-based formatting (`*text*`) to simplify API
  - LoggingUtils now accepts fully interpolated strings only (e.g., `'Value: $value'`)
  - Eliminated complex string parsing and formatting logic
  - Improved performance by removing regex processing
- **Platform-Aware Color Output**:
  - Colors disabled by default (`_enableColors = false`) to prevent ANSI escape sequence issues on non-web platforms
  - Colors are only enabled when explicitly configured via `configureFormatting()` for web platforms
  - Fixed color escape sequence display issues on iOS/Android debug consoles
  - Removed unused `_ansiBold` constant

### Fixed
- Fixed color escape sequence display issues on iOS/Android platforms (now disabled by default)
- Fixed variable interpolation issues in log messages (removed `*$variable*` format support)
- Improved log output reliability across all platforms

### Technical Improvements
- Simplified logging implementation for better maintainability
- Reduced code complexity by removing format string processing
- Better alignment with Flutter's standard logging patterns
- Enhanced developer experience with straightforward string interpolation

## 1.1.0

### Added
- **Enhanced Network Utils**:
  - Added `PUT`, `DELETE`, `PATCH`, and `HEAD` HTTP methods to `NetworkUtils`
  - Comprehensive error handling with custom exception types
  - Better request/response logging with improved error context
- **Custom Network Exceptions**:
  - `NetworkException`: Base exception class for all network-related errors
  - `HttpException`: Exception for HTTP errors with status code checking (e.g., `isUnauthorized`, `isNotFound`)
  - `NetworkConnectionException`: Exception for connectivity issues
  - `NetworkTimeoutException`: Exception for request timeouts
- **Enhanced Storage Utils**:
  - `fileExists()`: Check if a file exists in the app's documents directory
  - `getFileSize()`: Get file size in bytes
  - `listFiles()`: List all files in the directory with optional pattern filtering (e.g., `*.json`)
- **Enhanced Format Utils**:
  - `formatCurrency()`: Format numbers as currency with customizable symbol and locale
  - `formatFileSize()`: Format file sizes in human-readable format (B, KB, MB, GB, TB, PB)
  - `formatDuration()`: Format Duration objects to human-readable strings (e.g., "1h 30m 45s")

### Changed
- **ScreenUtils Modernization**:
  - Replaced deprecated `implicitView` API with `PlatformDispatcher.instance.views`
  - Added robust error handling and fallback mechanisms
  - Improved null safety and error recovery
- **Code Quality Enhancements**:
  - Enhanced `analysis_options.yaml` with comprehensive lint rules
  - Added strict type checking and code quality standards
  - Improved code organization and maintainability
- **Network Error Handling**:
  - All HTTP methods now throw typed exceptions (`HttpException`, `NetworkException`, etc.)
  - Better error messages with request context (URL, status code, response body)
  - Improved debugging experience with detailed error information
- **Logging Format**:
  - Removed timestamp from log output format for cleaner, more concise logs
  - Log format changed from `time [LOG_TYPE] message` to `[LOG_TYPE] message`
  - Maintains all existing functionality while improving readability
- **Documentation Improvements**:
  - Added comprehensive English documentation for all classes, methods, and variables
  - Every public API now includes detailed parameter descriptions, return values, exceptions, and usage examples
  - Enhanced inline comments explaining implementation details and design decisions
  - Improved code maintainability through better documentation standards

### Fixed
- Fixed deprecated API usage in `ScreenUtils` for Flutter 3.13+ compatibility
- Improved error handling in all utility classes
- Fixed import statements to use package imports instead of relative imports

### Technical Improvements
- Updated to Dart 3.0+ and Flutter 3.0+ standards
- Enhanced documentation with comprehensive examples
- Improved type safety throughout the codebase
- Better alignment with Flutter best practices

## 1.0.4

### Changed
- **Enhanced Network Response Logging**:
  - `NetworkUtils`: Removed 100-character limit on response body logging
  - HTTP response bodies are now logged in full for better debugging capabilities
  - Improved debugging experience for API integrations with complete response visibility

### Improved
- **Optimized Debug Logging**:
  - `LoggingUtils`: Debug logs (`LogType.debug`) are now only output when running in debug mode (`kDebugMode`)
  - Reduces log noise in production builds while maintaining full debugging capability during development
  - Performance improvement by avoiding unnecessary string processing for debug logs in release builds
  - Added `kDebugMode` import from `package:flutter/foundation.dart`

### Technical Improvements
- Enhanced logging efficiency with conditional debug output
- Improved network debugging with complete response visibility
- Better alignment with Flutter's debug/release build optimization patterns

## 1.0.3

### Added
- **Automatic Platform Detection & Unified Initialization**:
  - Added automatic platform detection using `dart:io` Platform and Flutter's `defaultTargetPlatform`
  - Introduced unified `EggyByteCore.initialize()` method that automatically detects platform and configures optimal settings
  - Automatic color/bold configuration based on platform and debug environment (fixes iOS ANSI escape sequences automatically)
  - Added `EggyByteCore.isInitialized` getter to check initialization state
  - Added `EggyByteCore.reset()` method for testing and re-initialization scenarios
- **Intelligent Environment Detection**:
  - Automatically disables ANSI colors and bold formatting on iOS debug builds to prevent escape sequence display issues
  - Smart fallback system: `dart:io` Platform → Flutter `defaultTargetPlatform` → Web fallback
  - Supports all platforms: Android, iOS, Web, Windows, macOS, Linux
- **Improved Developer Experience**:
  - One-line initialization: `EggyByteCore.initialize()` - no manual platform configuration needed
  - Optional custom configuration: `EggyByteCore.initialize(enableColors: false, enableBold: true)`
  - Prevents double initialization with warning messages
  - LoggingUtils now automatically uses platform prefix from EggyByteCore when no explicit prefix is provided
- **Enhanced Native Logging Integration**:
  - `LoggingUtils.logNative()` and convenience methods (`nativeInfo()`, `nativeWarning()`, etc.) now automatically use EggyByteCore's detected platform prefix when no custom prefix is provided
  - Added platform prefix provider system to avoid circular dependencies
  - Seamless integration between EggyByteCore and LoggingUtils for native platform logging

### Changed
- **Breaking Changes (with backward compatibility)**:
  - **REMOVED**: Custom `TargetPlatform` enum - now uses Flutter's native `TargetPlatform` from `package:flutter/foundation.dart`
  - **REMOVED**: `EggyByteCore.setTargetPlatform()` deprecated method (was marked deprecated in previous version)
  - Platform detection now returns Flutter's native `TargetPlatform` values (`TargetPlatform.iOS` instead of custom `TargetPlatform.ios`, etc.)
  - Platform prefix format updated to match Flutter's native naming: "IOS NATIVE", "MACOS NATIVE" instead of "ios NATIVE", "macos NATIVE"
- **Enhanced API Design**:
  - Platform detection is now fully automatic and more reliable using Flutter's standard TargetPlatform
  - Logging configuration automatically optimized for detected platform
  - Simplified initialization flow reduces integration complexity
  - Better alignment with Flutter's native platform detection system

### Removed
- **Deprecated API Cleanup**:
  - Removed deprecated `EggyByteCore.setTargetPlatform()` method
  - Removed custom `TargetPlatform` enum in favor of Flutter's native implementation
  - Cleaned up all backward compatibility code for deprecated platform handling
  - Removed outdated tests for deprecated functionality

### Fixed
- Resolved ANSI escape sequence display issues on iOS debug builds (now automatically detected and disabled)
- Improved platform detection reliability across different Flutter environments
- Enhanced error handling for unsupported platform detection scenarios
- Fixed platform naming consistency with Flutter's standard TargetPlatform enum

### Technical Improvements
- Updated comprehensive test coverage for new platform integration (41 passing tests)
- Enhanced platform detection logic using Flutter's native TargetPlatform system
- Improved code organization with removal of deprecated APIs
- Simplified codebase by eliminating custom platform enumeration
- Added platform prefix provider pattern for LoggingUtils integration
- Enhanced documentation for new platform detection patterns

## 1.0.2

### Added
- **Platform Configuration**: 
  - Added `EggyByteCore` main configuration class with platform detection support
  - New `TargetPlatform` enum supporting Android, iOS, Web, Windows, macOS, and Linux
  - Added `setTargetPlatform()` and `getTargetPlatform()` methods for platform management
- **Enhanced Logging System**:
  - Added `configureLogging()` method to control color and bold formatting
  - Implemented native platform logging with `logNative()` and convenience methods
  - Added platform prefix support for native logs (e.g., "ANDROID NATIVE", "IOS NATIVE")
  - Fixed ANSI escape sequence display issues in macOS iOS debugging environment
  - Made color and bold formatting configurable to address compatibility issues with different IDEs
- **Improved Developer Experience**:
  - Enhanced logging with configurable formatting to prevent visual clutter in incompatible terminals
  - Added native logging methods: `nativeInfo()`, `nativeWarning()`, `nativeError()`, `nativeDebug()`
  - Better error handling and graceful fallbacks for unsupported terminal features
- **Comprehensive Test Suite**:
  - Added extensive tests for `EggyByteCore` configuration functionality
  - Enhanced `LoggingUtils` tests including native logging features
  - Extended `FormatUtils` tests with edge cases and negative decimal handling
  - Improved `NetworkUtils` tests with better token management coverage
  - Added integration tests demonstrating cross-utility functionality
  - Platform switching tests validating all supported platforms

### Fixed
- Resolved ANSI escape sequence display issues when debugging iOS apps on macOS
- Fixed log formatting inconsistencies across different development environments
- Improved color code handling for terminals that don't support ANSI formatting

### Changed
- Updated minimum Flutter version requirement to 3.0.0
- Enhanced pubspec.yaml with better metadata and platform support information
- Improved README.md with comprehensive documentation and usage examples

### Technical Improvements
- Added configuration flags for color and bold text support
- Implemented conditional formatting based on environment capabilities
- Enhanced error logging with better stack trace handling
- Improved code organization with better separation of concerns
- Comprehensive test coverage for all new features
- 37 passing unit tests covering all utility modules

## 1.0.1

### Fixed
- Resolved an issue in `LoggingUtils` where ANSI color for the log type was reset after a bolded (`*word*`) segment, causing subsequent parts of the message to lose their color. The log type color is now correctly reapplied after bolded segments.
- Ensured stack traces in error logs also use the designated error color.

## 1.0.0

### Added
- Initial stable release of `eggybyte_core`.
- **Project Setup**:
  - Standardized `pubspec.yaml` with essential dependencies (`http`, `path_provider`, `intl`).
  - Comprehensive `README.md` including badges, overview, detailed feature list, getting started guide, usage examples for all utilities, API documentation guidelines, project structure, and contribution steps.
  - MIT License file (`LICENSE`).
- **Core Utilities (as per `eggybyte_core_guidelines.mdc`)**:
  - **`LoggingUtils`**: Centralized logging with timestamp, log types (INFO, WARNING, ERROR, DEBUG), colored output, and support for bolding important keywords. Distinct error handling with stack traces.
  - **`NetworkUtils`**: (Placeholder/Interface for) HTTP client (GET, POST, headers, body, query params, Bearer token) and WebSocket client functionalities.
  - **`ScreenUtils`**: (Placeholder/Interface for) Utilities to get device screen dimensions and Flutter `BuildContext` dimensions.
  - **`StorageUtils`**: (Placeholder/Interface for) Persistent file storage for string content (save, read) with error handling.
  - **`FormatUtils`**: (Placeholder/Interface for) 
    - Time formatting: symbol-separated (e.g., "14:30:55") and Chinese-separated (e.g., "14时30分55秒").
    - Date formatting: symbol-separated (e.g., "2023-10-27") and Chinese-separated (e.g., "2023年10月27日").
    - Number formatting: specified decimal places and formatting with Chinese units (e.g., "万", "亿").
