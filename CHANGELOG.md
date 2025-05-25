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
