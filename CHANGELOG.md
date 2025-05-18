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
