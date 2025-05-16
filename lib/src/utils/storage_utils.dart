import 'dart:io';
import 'package:path_provider/path_provider.dart';
import './logging_utils.dart';

/// A utility class for persistent file storage.
/// All methods are static as per the guidelines.
class StorageUtils {
  // Private constructor to prevent instantiation.
  StorageUtils._();

  /// Gets the application documents directory path.
  static Future<String> get _documentsPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Persistently saves string content to a specified file in the app's documents directory.
  ///
  /// [fileName]: The name of the file (e.g., "my_data.txt").
  /// [content]: The string content to save.
  static Future<File> saveToFile(String fileName, String content) async {
    final path = await _documentsPath;
    final filePath = '$path/$fileName';
    LoggingUtils.debug('Attempting to save content to file: *$filePath*');
    try {
      final file = File(filePath);
      final writtenFile = await file.writeAsString(content);
      LoggingUtils.info('Content successfully saved to file: *$filePath*');
      return writtenFile;
    } catch (e, s) {
      LoggingUtils.error(
        'Failed to save content to file: *$filePath*. Error: $e',
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Reads and returns string content from a specified file in the app's documents directory.
  ///
  /// [fileName]: The name of the file (e.g., "my_data.txt").
  /// Returns the file content as a string, or null if the file does not exist or an error occurs.
  static Future<String?> readFromFile(String fileName) async {
    final path = await _documentsPath;
    final filePath = '$path/$fileName';
    LoggingUtils.debug('Attempting to read content from file: *$filePath*');
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final content = await file.readAsString();
        LoggingUtils.info('Content successfully read from file: *$filePath*');
        return content;
      } else {
        LoggingUtils.warning('File not found: *$filePath*');
        return null;
      }
    } catch (e, s) {
      LoggingUtils.error(
        'Failed to read content from file: *$filePath*. Error: $e',
        stackTrace: s,
      );
      return null; // Gracefully handle error by returning null
    }
  }

  /// Deletes a specified file from the app's documents directory.
  ///
  /// [fileName]: The name of the file to delete.
  /// Returns true if the file was deleted successfully, false otherwise.
  static Future<bool> deleteFile(String fileName) async {
    final path = await _documentsPath;
    final filePath = '$path/$fileName';
    LoggingUtils.debug('Attempting to delete file: *$filePath*');
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        LoggingUtils.info('File successfully deleted: *$filePath*');
        return true;
      } else {
        LoggingUtils.warning('File not found for deletion: *$filePath*');
        return false;
      }
    } catch (e, s) {
      LoggingUtils.error(
        'Failed to delete file: *$filePath*. Error: $e',
        stackTrace: s,
      );
      return false;
    }
  }
}
