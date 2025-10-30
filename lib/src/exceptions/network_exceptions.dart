import 'package:http/http.dart' as http;

/// Base exception class for all network-related errors.
///
/// This class serves as the foundation for all network exception types
/// thrown by NetworkUtils. It provides a common interface for error handling
/// and includes additional context about the failed request.
///
/// Example:
/// ```dart
/// try {
///   await NetworkUtils.get('https://api.example.com/data');
/// } on NetworkException catch (e) {
///   print('Network error: ${e.message}');
///   print('URL: ${e.url}');
/// }
/// ```
class NetworkException implements Exception {
  /// Creates a NetworkException instance.
  ///
  /// Parameters:
  /// - [message]: A descriptive error message explaining what went wrong.
  /// - [url]: The URL of the failed request (optional).
  /// - [statusCode]: The HTTP status code if available (optional).
  /// - [responseBody]: The response body if available (optional).
  /// - [originalError]: The original exception that caused this error (optional).
  const NetworkException({
    required this.message,
    this.url,
    this.statusCode,
    this.responseBody,
    this.originalError,
  });

  /// A descriptive error message explaining what went wrong.
  final String message;

  /// The URL of the failed request, if available.
  final String? url;

  /// The HTTP status code if the request completed but returned an error.
  final int? statusCode;

  /// The response body if available, useful for debugging.
  final String? responseBody;

  /// The original exception that caused this error.
  final Object? originalError;

  @override
  String toString() {
    final buffer = StringBuffer('NetworkException: $message');
    if (url != null) {
      buffer.write('\nURL: $url');
    }
    if (statusCode != null) {
      buffer.write('\nStatus Code: $statusCode');
    }
    if (originalError != null) {
      buffer.write('\nOriginal Error: $originalError');
    }
    return buffer.toString();
  }
}

/// Exception thrown when an HTTP request fails with a non-success status code.
///
/// This exception is thrown when a request completes but returns an HTTP
/// status code indicating an error (typically 400-599).
///
/// Example:
/// ```dart
/// try {
///   await NetworkUtils.get('https://api.example.com/data');
/// } on HttpException catch (e) {
///   print('HTTP error ${e.statusCode}: ${e.message}');
///   print('Response: ${e.responseBody}');
/// }
/// ```
class HttpException extends NetworkException {
  /// Creates an HttpException instance.
  ///
  /// Parameters:
  /// - [statusCode]: The HTTP status code (required).
  /// - [message]: A descriptive error message (defaults to status code description).
  /// - [url]: The URL of the failed request (optional).
  /// - [responseBody]: The response body if available (optional).
  /// - [response]: The complete HTTP response object (optional).
  HttpException({
    required this.statusCode,
    String? message,
    String? url,
    this.responseBody,
    this.response,
  }) : super(
          message: message ?? _getStatusMessage(statusCode),
          url: url,
          statusCode: statusCode,
          responseBody: responseBody,
        );

  /// The HTTP status code that caused this exception.
  final int statusCode;

  /// The response body if available.
  final String? responseBody;

  /// The complete HTTP response object if available.
  final http.Response? response;

  /// Determines if the status code indicates a client error (4xx).
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Determines if the status code indicates a server error (5xx).
  bool get isServerError => statusCode >= 500 && statusCode < 600;

  /// Determines if the status code indicates an authentication error (401).
  bool get isUnauthorized => statusCode == 401;

  /// Determines if the status code indicates a forbidden error (403).
  bool get isForbidden => statusCode == 403;

  /// Determines if the status code indicates a not found error (404).
  bool get isNotFound => statusCode == 404;

  @override
  String toString() {
    final buffer = StringBuffer('HttpException: $message');
    buffer.write('\nStatus Code: $statusCode');
    if (url != null) {
      buffer.write('\nURL: $url');
    }
    if (responseBody != null) {
      buffer.write('\nResponse Body: $responseBody');
    }
    return buffer.toString();
  }

  /// Gets a human-readable message for a given HTTP status code.
  static String _getStatusMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 408:
        return 'Request Timeout';
      case 409:
        return 'Conflict';
      case 422:
        return 'Unprocessable Entity';
      case 429:
        return 'Too Many Requests';
      case 500:
        return 'Internal Server Error';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Service Unavailable';
      case 504:
        return 'Gateway Timeout';
      default:
        if (statusCode >= 400 && statusCode < 500) {
          return 'Client Error';
        } else if (statusCode >= 500) {
          return 'Server Error';
        } else {
          return 'HTTP Error';
        }
    }
  }
}

/// Exception thrown when a network request times out.
///
/// This exception is thrown when a request exceeds the configured timeout
/// duration without receiving a response.
///
/// Example:
/// ```dart
/// try {
///   await NetworkUtils.get('https://api.example.com/data');
/// } on NetworkTimeoutException catch (e) {
///   print('Request timed out after ${e.timeoutDuration}');
/// }
/// ```
class NetworkTimeoutException extends NetworkException {
  /// Creates a NetworkTimeoutException instance.
  ///
  /// Parameters:
  /// - [timeoutDuration]: The timeout duration that was exceeded.
  /// - [url]: The URL of the timed-out request (optional).
  NetworkTimeoutException({
    required this.timeoutDuration,
    String? url,
  }) : super(
          message: 'Request timed out after ${timeoutDuration.toString()}',
          url: url,
        );

  /// The timeout duration that was exceeded.
  final Duration timeoutDuration;
}

/// Exception thrown when a network request fails due to connectivity issues.
///
/// This exception is thrown when a request fails because the device is not
/// connected to the internet or cannot reach the server.
///
/// Example:
/// ```dart
/// try {
///   await NetworkUtils.get('https://api.example.com/data');
/// } on NetworkConnectionException catch (e) {
///   print('No internet connection: ${e.message}');
/// }
/// ```
class NetworkConnectionException extends NetworkException {
  /// Creates a NetworkConnectionException instance.
  ///
  /// Parameters:
  /// - [message]: A descriptive error message (defaults to standard message).
  /// - [url]: The URL of the failed request (optional).
  /// - [originalError]: The original exception that caused this error (optional).
  NetworkConnectionException({
    String? message,
    String? url,
    Object? originalError,
  }) : super(
          message: message ?? 'No internet connection available',
          url: url,
          originalError: originalError,
        );
}

