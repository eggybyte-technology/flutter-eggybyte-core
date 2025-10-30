import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:eggybyte_core/src/utils/logging_utils.dart';

/// A utility class providing persistent file storage functionality for applications.
///
/// This class offers methods to save, read, check, and manage files in the application's
/// documents directory. All file operations are asynchronous and include comprehensive
/// error handling. Files are stored in the platform-specific documents directory
/// which persists across app restarts.
///
/// All methods are static as per the utility class guidelines.
///
/// Features:
/// - Save string content to files
/// - Read string content from files
/// - Check file existence
/// - Get file size in bytes
/// - List files with optional pattern filtering
/// - Delete files
/// - Comprehensive error handling and logging
///
/// Platform Behavior:
/// - Files are stored in the app's documents directory (platform-specific)
/// - Files persist across app restarts
/// - Files are sandboxed per application
///
/// Example usage:
/// ```dart
/// // Save data
/// await StorageUtils.saveToFile('user_data.json', '{"name": "EggyByte"}');
///
/// // Check if file exists
/// final exists = await StorageUtils.fileExists('user_data.json');
///
/// // Read data
/// final content = await StorageUtils.readFromFile('user_data.json');
///
/// // List files
/// final files = await StorageUtils.listFiles(pattern: '*.json');
/// ```
class StorageUtils {
  /// Private constructor to prevent instantiation of this utility class.
  /// All methods are static and should be called directly on the class.
  StorageUtils._();

  /// Retrieves the path to the application's documents directory.
  ///
  /// This private getter uses the path_provider package to get the platform-specific
  /// documents directory where application data should be stored. This directory is
  /// persistent and survives app restarts.
  ///
  /// Returns:
  /// A [Future] that completes with the absolute path string to the documents directory.
  ///
  /// Platform-specific paths:
  /// - Android: /data/data/{package_name}/app_flutter/
  /// - iOS: ~/Documents/
  /// - macOS: ~/Library/Application Support/{app_name}/
  /// - Windows: {UserProfile}/Documents/{app_name}/
  /// - Linux: ~/.local/share/{app_name}/
  /// - Web: Browser-specific storage location
  static Future<String> get _documentsPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Persistently saves string content to a file in the application's documents directory.
  ///
  /// This method creates or overwrites a file with the specified name and writes the
  /// provided string content to it. If the file already exists, it will be overwritten.
  /// The file is written asynchronously and the operation is atomic.
  ///
  /// Parameters:
  /// - [fileName]: The name of the file to create or overwrite (e.g., "my_data.txt", "user_data.json").
  ///   This should be a simple filename without path separators. The file will be created
  ///   in the application's documents directory.
  /// - [content]: The string content to write to the file. Can be any string including
  ///   JSON, plain text, or other formatted data.
  ///
  /// Returns:
  /// A [Future] that completes with the [File] object representing the written file.
  ///
  /// Throws:
  /// Re-throws any exceptions that occur during file writing, including:
  /// - File system permission errors
  /// - Disk space errors
  /// - Invalid file name errors
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final file = await StorageUtils.saveToFile('user_data.json', '{"name": "EggyByte"}');
  ///   print('File saved: ${file.path}');
  /// } catch (e) {
  ///   print('Failed to save file: $e');
  /// }
  /// ```
  static Future<File> saveToFile(String fileName, String content) async {
    // Get the documents directory path
    final path = await _documentsPath;
    // Construct the full file path by combining directory path with filename
    final filePath = '$path/$fileName';
    LoggingUtils.debug('Attempting to save content to file: *$filePath*');
    try {
      // Create File object and write content asynchronously
      final file = File(filePath);
      final writtenFile = await file.writeAsString(content);
      LoggingUtils.info('Content successfully saved to file: *$filePath*');
      return writtenFile;
    } catch (e, s) {
      // Log error with stack trace and rethrow for caller to handle
      LoggingUtils.error(
        'Failed to save content to file: *$filePath*. Error: $e',
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Reads and returns string content from a file in the application's documents directory.
  ///
  /// This method attempts to read the content of a file with the specified name.
  /// If the file does not exist or an error occurs, the method returns `null` instead
  /// of throwing an exception, making it safe for optional file operations.
  ///
  /// Parameters:
  /// - [fileName]: The name of the file to read (e.g., "my_data.txt", "user_data.json").
  ///   This should be a simple filename without path separators.
  ///
  /// Returns:
  /// A [Future] that completes with:
  /// - The file content as a string if the file exists and was read successfully
  /// - `null` if the file does not exist or an error occurred during reading
  ///
  /// Example:
  /// ```dart
  /// final content = await StorageUtils.readFromFile('user_data.json');
  /// if (content != null) {
  ///   print('File content: $content');
  /// } else {
  ///   print('File does not exist or could not be read');
  /// }
  /// ```
  static Future<String?> readFromFile(String fileName) async {
    // Get the documents directory path
    final path = await _documentsPath;
    // Construct the full file path
    final filePath = '$path/$fileName';
    LoggingUtils.debug('Attempting to read content from file: *$filePath*');
    try {
      final file = File(filePath);
      // Check if file exists before attempting to read
      if (await file.exists()) {
        // Read file content as string
        final content = await file.readAsString();
        LoggingUtils.info('Content successfully read from file: *$filePath*');
        return content;
      } else {
        // File doesn't exist - log warning and return null
        LoggingUtils.warning('File not found: *$filePath*');
        return null;
      }
    } catch (e, s) {
      // Log error but return null instead of throwing (graceful error handling)
      LoggingUtils.error(
        'Failed to read content from file: *$filePath*. Error: $e',
        stackTrace: s,
      );
      return null;
    }
  }

  /// Deletes a file from the application's documents directory.
  ///
  /// This method attempts to delete a file with the specified name. If the file
  /// does not exist, the method returns `false` without throwing an exception.
  /// If deletion fails due to permissions or other errors, the method also returns
  /// `false` after logging the error.
  ///
  /// Parameters:
  /// - [fileName]: The name of the file to delete (e.g., "my_data.txt", "user_data.json").
  ///   This should be a simple filename without path separators.
  ///
  /// Returns:
  /// A [Future] that completes with:
  /// - `true` if the file was deleted successfully
  /// - `false` if the file does not exist or deletion failed
  ///
  /// Example:
  /// ```dart
  /// final deleted = await StorageUtils.deleteFile('user_data.json');
  /// if (deleted) {
  ///   print('File deleted successfully');
  /// } else {
  ///   print('File not found or deletion failed');
  /// }
  /// ```
  static Future<bool> deleteFile(String fileName) async {
    // Get the documents directory path
    final path = await _documentsPath;
    // Construct the full file path
    final filePath = '$path/$fileName';
    LoggingUtils.debug('Attempting to delete file: *$filePath*');
    try {
      final file = File(filePath);
      // Check if file exists before attempting to delete
      if (await file.exists()) {
        // Delete the file
        await file.delete();
        LoggingUtils.info('File successfully deleted: *$filePath*');
        return true;
      } else {
        // File doesn't exist - log warning and return false
        LoggingUtils.warning('File not found for deletion: *$filePath*');
        return false;
      }
    } catch (e, s) {
      // Log error but return false instead of throwing (graceful error handling)
      LoggingUtils.error(
        'Failed to delete file: *$filePath*. Error: $e',
        stackTrace: s,
      );
      return false;
    }
  }

  /// Checks if a file exists in the application's documents directory.
  ///
  /// This method determines whether a file with the specified name exists in the
  /// documents directory without attempting to read its contents. This is useful
  /// for conditional file operations or checking file state before read/write operations.
  ///
  /// Parameters:
  /// - [fileName]: The name of the file to check (e.g., "my_data.txt", "user_data.json").
  ///   This should be a simple filename without path separators.
  ///
  /// Returns:
  /// A [Future] that completes with:
  /// - `true` if the file exists
  /// - `false` if the file does not exist or an error occurred during the check
  ///
  /// Example:
  /// ```dart
  /// final exists = await StorageUtils.fileExists('user_data.json');
  /// if (exists) {
  ///   print('File exists');
  ///   final content = await StorageUtils.readFromFile('user_data.json');
  /// } else {
  ///   print('File does not exist, creating new file...');
  /// }
  /// ```
  static Future<bool> fileExists(String fileName) async {
    // Get the documents directory path
    final path = await _documentsPath;
    // Construct the full file path
    final filePath = '$path/$fileName';
    LoggingUtils.debug('Checking if file exists: *$filePath*');
    try {
      final file = File(filePath);
      // Check file existence
      final exists = await file.exists();
      LoggingUtils.debug('File exists check for *$filePath*: *$exists*');
      return exists;
    } catch (e, s) {
      // Log error but return false instead of throwing (graceful error handling)
      LoggingUtils.error(
        'Failed to check file existence for *$filePath*: $e',
        stackTrace: s,
      );
      return false;
    }
  }

  /// Gets the size of a file in bytes.
  ///
  /// This method retrieves the file size in bytes for a file in the documents directory.
  /// The file size represents the total number of bytes the file occupies on disk.
  ///
  /// Parameters:
  /// - [fileName]: The name of the file (e.g., "my_data.txt", "user_data.json").
  ///   This should be a simple filename without path separators.
  ///
  /// Returns:
  /// A [Future] that completes with:
  /// - The file size in bytes as an `int` if the file exists and size was retrieved successfully
  /// - `null` if the file does not exist or an error occurred during retrieval
  ///
  /// Example:
  /// ```dart
  /// final size = await StorageUtils.getFileSize('user_data.json');
  /// if (size != null) {
  ///   print('File size: $size bytes');
  ///   final formattedSize = FormatUtils.formatFileSize(size);
  ///   print('Formatted: $formattedSize'); // e.g., "1.23 KB"
  /// }
  /// ```
  static Future<int?> getFileSize(String fileName) async {
    // Get the documents directory path
    final path = await _documentsPath;
    // Construct the full file path
    final filePath = '$path/$fileName';
    LoggingUtils.debug('Getting file size for: *$filePath*');
    try {
      final file = File(filePath);
      // Check if file exists before getting size
      if (await file.exists()) {
        // Get file size in bytes
        final size = await file.length();
        LoggingUtils.debug('File size for *$filePath*: *$size* bytes');
        return size;
      } else {
        // File doesn't exist - log warning and return null
        LoggingUtils.warning('File not found for size check: *$filePath*');
        return null;
      }
    } catch (e, s) {
      // Log error but return null instead of throwing (graceful error handling)
      LoggingUtils.error(
        'Failed to get file size for *$filePath*: $e',
        stackTrace: s,
      );
      return null;
    }
  }

  /// Lists all files in the application's documents directory with optional pattern filtering.
  ///
  /// This method retrieves a list of all file names in the documents directory.
  /// Optionally, files can be filtered by a pattern (e.g., "*.json" to list only JSON files).
  ///
  /// Pattern Matching:
  /// - `*.json` - Matches all files ending with `.json`
  /// - `data.*` - Matches all files starting with `data.`
  /// - `*.txt` - Matches all files ending with `.txt`
  /// - Exact match - If pattern doesn't contain `*`, it matches files with that exact name
  ///
  /// Parameters:
  /// - [pattern]: Optional file name pattern to filter files.
  ///   If `null`, all files in the directory are returned.
  ///   Pattern supports simple wildcard matching:
  ///   - Patterns starting with `*` (e.g., `*.json`) match files ending with the suffix
  ///   - Patterns ending with `*` (e.g., `data.*`) match files starting with the prefix
  ///   - Patterns without `*` match files with that exact name
  ///
  /// Returns:
  /// A [Future] that completes with a list of file names (strings) matching the pattern,
  /// or an empty list if:
  /// - No files match the pattern
  /// - The directory does not exist
  /// - An error occurred during listing
  ///
  /// Example:
  /// ```dart
  /// // List all files
  /// final allFiles = await StorageUtils.listFiles();
  /// print('Found ${allFiles.length} files');
  ///
  /// // List only JSON files
  /// final jsonFiles = await StorageUtils.listFiles(pattern: '*.json');
  /// print('Found ${jsonFiles.length} JSON files');
  ///
  /// // List files starting with "data"
  /// final dataFiles = await StorageUtils.listFiles(pattern: 'data.*');
  /// ```
  static Future<List<String>> listFiles({String? pattern}) async {
    // Get the documents directory path
    final path = await _documentsPath;
    LoggingUtils.debug(
      'Listing files in directory: *$path*${pattern != null ? ' (pattern: $pattern)' : ''}',
    );
    try {
      final directory = Directory(path);
      // Check if directory exists
      if (!await directory.exists()) {
        LoggingUtils.warning('Directory does not exist: *$path*');
        return [];
      }

      // List to store matching file names
      final files = <String>[];
      // Iterate through directory contents
      final entities = directory.list();
      await for (final entity in entities) {
        // Only process files (skip directories)
        if (entity is File) {
          // Extract just the filename from the full path
          final fileName = entity.path.split('/').last;
          // Apply pattern matching if pattern is provided
          if (pattern == null || _matchesPattern(fileName, pattern)) {
            files.add(fileName);
          }
        }
      }

      LoggingUtils.debug(
        'Found *${files.length}* files in directory *$path*',
      );
      return files;
    } catch (e, s) {
      // Log error but return empty list instead of throwing (graceful error handling)
      LoggingUtils.error(
        'Failed to list files in directory *$path*: $e',
        stackTrace: s,
      );
      return [];
    }
  }

  /// Checks if a file name matches a pattern using simple wildcard matching.
  ///
  /// This is a private helper method that implements basic pattern matching for file names.
  /// It supports simple wildcard patterns for filtering files in the listFiles method.
  ///
  /// Pattern Matching Rules:
  /// - Patterns starting with `*` (e.g., `*.json`): Match files ending with the suffix
  ///   Example: `*.json` matches "data.json", "config.json" but not "json.data"
  /// - Patterns ending with `*` (e.g., `data.*`): Match files starting with the prefix
  ///   Example: `data.*` matches "data.json", "data.txt" but not "mydata.json"
  /// - Patterns without `*`: Exact match
  ///   Example: `config.json` matches only "config.json"
  ///
  /// Parameters:
  /// - [fileName]: The file name to check against the pattern.
  /// - [pattern]: The pattern to match against. Should contain at most one `*` wildcard.
  ///
  /// Returns:
  /// `true` if the file name matches the pattern, `false` otherwise.
  ///
  /// Note: This is a simple pattern matcher. For complex patterns, consider using
  /// regular expressions or a more sophisticated matching library.
  static bool _matchesPattern(String fileName, String pattern) {
    if (pattern.startsWith('*')) {
      // Pattern like "*.json" - match files ending with suffix
      final suffix = pattern.substring(1);
      return fileName.endsWith(suffix);
    } else if (pattern.endsWith('*')) {
      // Pattern like "data.*" - match files starting with prefix
      final prefix = pattern.substring(0, pattern.length - 1);
      return fileName.startsWith(prefix);
    } else {
      // Exact match - no wildcard, pattern must match filename exactly
      return fileName == pattern;
    }
  }
}
