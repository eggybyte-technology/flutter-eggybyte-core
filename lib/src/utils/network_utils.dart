import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:eggybyte_core/src/utils/logging_utils.dart';
import 'package:eggybyte_core/src/exceptions/network_exceptions.dart';

/// A utility class providing comprehensive HTTP client functionality for network operations.
///
/// This class implements a complete HTTP client with support for all standard HTTP methods
/// (GET, POST, PUT, PATCH, DELETE, HEAD) and includes built-in Bearer token authentication,
/// comprehensive error handling with typed exceptions, and detailed request/response logging.
///
/// All methods are static as per the utility class guidelines.
///
/// Features:
/// - Complete HTTP method support (GET, POST, PUT, PATCH, DELETE, HEAD)
/// - Bearer token authentication with global token management
/// - Typed exception handling (NetworkException, HttpException, etc.)
/// - Automatic JSON encoding/decoding for request bodies
/// - Comprehensive request and response logging
/// - Query parameter support for all HTTP methods
///
/// Example usage:
/// ```dart
/// // Set authentication token
/// NetworkUtils.setBearerToken('your_api_token');
///
/// // Make GET request
/// final response = await NetworkUtils.get('https://api.example.com/data');
///
/// // Make POST request with body
/// final response = await NetworkUtils.post(
///   'https://api.example.com/create',
///   body: {'name': 'EggyByte'},
/// );
///
/// // Clear token when done
/// NetworkUtils.clearBearerToken();
/// ```
class NetworkUtils {
  /// Private constructor to prevent instantiation of this utility class.
  /// All methods are static and should be called directly on the class.
  NetworkUtils._();

  /// The global Bearer token used for authentication in all HTTP requests.
  ///
  /// This token is automatically included in the Authorization header of all requests
  /// when set via [setBearerToken]. The token format is "Bearer {token}".
  ///
  /// When `null`, no Authorization header is added to requests.
  /// Set this value using [setBearerToken] and clear it using [clearBearerToken].
  static String? _bearerToken;

  /// Sets the global Bearer token that will be included in all subsequent HTTP requests.
  ///
  /// This method stores the provided token and automatically includes it in the
  /// Authorization header of all HTTP requests made through this utility class.
  /// The token format used is "Bearer {token}".
  ///
  /// Parameters:
  /// - [token]: The Bearer token string to use for authentication.
  ///   This token will be sent in the Authorization header of all requests.
  ///
  /// Example:
  /// ```dart
  /// NetworkUtils.setBearerToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');
  /// ```
  ///
  /// Note: To update the token, simply call this method again with the new token.
  /// To remove the token, call [clearBearerToken].
  static void setBearerToken(String token) {
    _bearerToken = token;
    LoggingUtils.info('Bearer token has been *set*.');
  }

  /// Clears the global Bearer token, removing authentication from all subsequent requests.
  ///
  /// After calling this method, no Authorization header will be included in
  /// HTTP requests until a new token is set via [setBearerToken].
  ///
  /// Example:
  /// ```dart
  /// NetworkUtils.clearBearerToken();
  /// ```
  static void clearBearerToken() {
    _bearerToken = null;
    LoggingUtils.info('Bearer token has been *cleared*.');
  }

  /// Internal helper method to construct HTTP headers for requests.
  ///
  /// This method creates a base set of headers including Content-Type and optionally
  /// the Authorization header with the Bearer token if one is set. Additional headers
  /// can be merged in via the [additionalHeaders] parameter.
  ///
  /// Parameters:
  /// - [additionalHeaders]: Optional map of additional headers to include in the request.
  ///   These headers will be merged with the default headers. If a header key conflicts
  ///   with a default header, the additional header value will take precedence.
  ///
  /// Returns:
  /// A [Map<String, String>] containing all headers to be used in the HTTP request.
  ///
  /// Default headers included:
  /// - `Content-Type: application/json; charset=UTF-8`
  /// - `Authorization: Bearer {token}` (if token is set)
  static Map<String, String> _getHeaders({
    Map<String, String>? additionalHeaders,
  }) {
    // Start with default headers: Content-Type for JSON requests
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    // Add Bearer token authentication header if token is set
    if (_bearerToken != null) {
      headers['Authorization'] = 'Bearer $_bearerToken';
    }

    // Merge any additional headers provided by the caller
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Performs a GET request.
  ///
  /// Parameters:
  /// - [url]: The URL to send the GET request to.
  /// - [headers]: Optional additional headers to include in the request.
  /// - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  /// A [Future] that completes with an [http.Response] containing the response data.
  ///
  /// Throws:
  /// - [NetworkException]: If the request fails due to network issues.
  /// - [HttpException]: If the request completes but returns an error status code.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final response = await NetworkUtils.get(
  ///     'https://api.example.com/data',
  ///     queryParameters: {'page': '1', 'limit': '10'},
  ///   );
  ///   print('Response: ${response.body}');
  /// } on HttpException catch (e) {
  ///   print('HTTP error: ${e.statusCode}');
  /// }
  /// ```
  static Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final Uri uri = Uri.parse(url).replace(queryParameters: queryParameters);
    LoggingUtils.debug('Executing *GET* request to: $uri');
    try {
      final response = await http.get(
        uri,
        headers: _getHeaders(additionalHeaders: headers),
      );
      LoggingUtils.debug(
        'GET request to $uri completed with status *${response.statusCode}*.',
      );
      _logResponse(response);
      _checkResponseStatus(response, url);
      return response;
    } on SocketException catch (e) {
      LoggingUtils.error('GET request to $uri *failed*: $e');
      throw NetworkConnectionException(
        url: url,
        originalError: e,
      );
    } on http.ClientException catch (e) {
      LoggingUtils.error('GET request to $uri *failed*: $e');
      throw NetworkException(
        message: 'Network request failed: ${e.message}',
        url: url,
        originalError: e,
      );
    } catch (e, s) {
      LoggingUtils.error('GET request to $uri *failed*: $e', stackTrace: s);
      throw NetworkException(
        message: 'Unexpected error during GET request: $e',
        url: url,
        originalError: e,
      );
    }
  }

  /// Performs a POST request.
  ///
  /// Parameters:
  /// - [url]: The URL to send the POST request to.
  /// - [headers]: Optional additional headers to include in the request.
  /// - [body]: Optional body data to send (will be JSON encoded).
  /// - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  /// A [Future] that completes with an [http.Response] containing the response data.
  ///
  /// Throws:
  /// - [NetworkException]: If the request fails due to network issues.
  /// - [HttpException]: If the request completes but returns an error status code.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final response = await NetworkUtils.post(
  ///     'https://api.example.com/create',
  ///     body: {'name': 'EggyByte', 'type': 'technology'},
  ///   );
  ///   print('Created: ${response.body}');
  /// } on HttpException catch (e) {
  ///   print('HTTP error: ${e.statusCode}');
  /// }
  /// ```
  static Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final Uri uri = Uri.parse(url).replace(queryParameters: queryParameters);
    final String requestBody = body == null ? '{}' : jsonEncode(body);
    final bodyPreview = requestBody.length > 100
        ? '${requestBody.substring(0, 100)}...'
        : requestBody;
    LoggingUtils.debug(
      'Executing *POST* request to: $uri with body: $bodyPreview',
    );
    try {
      final response = await http.post(
        uri,
        headers: _getHeaders(additionalHeaders: headers),
        body: requestBody,
      );
      LoggingUtils.debug(
        'POST request to $uri completed with status *${response.statusCode}*.',
      );
      _logResponse(response);
      _checkResponseStatus(response, url);
      return response;
    } on SocketException catch (e) {
      LoggingUtils.error('POST request to $uri *failed*: $e');
      throw NetworkConnectionException(
        url: url,
        originalError: e,
      );
    } on http.ClientException catch (e) {
      LoggingUtils.error('POST request to $uri *failed*: $e');
      throw NetworkException(
        message: 'Network request failed: ${e.message}',
        url: url,
        originalError: e,
      );
    } catch (e, s) {
      LoggingUtils.error('POST request to $uri *failed*: $e', stackTrace: s);
      throw NetworkException(
        message: 'Unexpected error during POST request: $e',
        url: url,
        originalError: e,
      );
    }
  }

  /// Performs a PUT request.
  ///
  /// Parameters:
  /// - [url]: The URL to send the PUT request to.
  /// - [headers]: Optional additional headers to include in the request.
  /// - [body]: Optional body data to send (will be JSON encoded).
  /// - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  /// A [Future] that completes with an [http.Response] containing the response data.
  ///
  /// Throws:
  /// - [NetworkException]: If the request fails due to network issues.
  /// - [HttpException]: If the request completes but returns an error status code.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final response = await NetworkUtils.put(
  ///     'https://api.example.com/users/123',
  ///     body: {'name': 'Updated Name'},
  ///   );
  ///   print('Updated: ${response.body}');
  /// } on HttpException catch (e) {
  ///   print('HTTP error: ${e.statusCode}');
  /// }
  /// ```
  static Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final Uri uri = Uri.parse(url).replace(queryParameters: queryParameters);
    final String requestBody = body == null ? '{}' : jsonEncode(body);
    final bodyPreview = requestBody.length > 100
        ? '${requestBody.substring(0, 100)}...'
        : requestBody;
    LoggingUtils.debug(
      'Executing *PUT* request to: $uri with body: $bodyPreview',
    );
    try {
      final response = await http.put(
        uri,
        headers: _getHeaders(additionalHeaders: headers),
        body: requestBody,
      );
      LoggingUtils.debug(
        'PUT request to $uri completed with status *${response.statusCode}*.',
      );
      _logResponse(response);
      _checkResponseStatus(response, url);
      return response;
    } on SocketException catch (e) {
      LoggingUtils.error('PUT request to $uri *failed*: $e');
      throw NetworkConnectionException(
        url: url,
        originalError: e,
      );
    } on http.ClientException catch (e) {
      LoggingUtils.error('PUT request to $uri *failed*: $e');
      throw NetworkException(
        message: 'Network request failed: ${e.message}',
        url: url,
        originalError: e,
      );
    } catch (e, s) {
      LoggingUtils.error('PUT request to $uri *failed*: $e', stackTrace: s);
      throw NetworkException(
        message: 'Unexpected error during PUT request: $e',
        url: url,
        originalError: e,
      );
    }
  }

  /// Performs a PATCH request.
  ///
  /// Parameters:
  /// - [url]: The URL to send the PATCH request to.
  /// - [headers]: Optional additional headers to include in the request.
  /// - [body]: Optional body data to send (will be JSON encoded).
  /// - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  /// A [Future] that completes with an [http.Response] containing the response data.
  ///
  /// Throws:
  /// - [NetworkException]: If the request fails due to network issues.
  /// - [HttpException]: If the request completes but returns an error status code.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final response = await NetworkUtils.patch(
  ///     'https://api.example.com/users/123',
  ///     body: {'email': 'new@example.com'},
  ///   );
  ///   print('Patched: ${response.body}');
  /// } on HttpException catch (e) {
  ///   print('HTTP error: ${e.statusCode}');
  /// }
  /// ```
  static Future<http.Response> patch(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final Uri uri = Uri.parse(url).replace(queryParameters: queryParameters);
    final String requestBody = body == null ? '{}' : jsonEncode(body);
    final bodyPreview = requestBody.length > 100
        ? '${requestBody.substring(0, 100)}...'
        : requestBody;
    LoggingUtils.debug(
      'Executing *PATCH* request to: $uri with body: $bodyPreview',
    );
    try {
      final response = await http.patch(
        uri,
        headers: _getHeaders(additionalHeaders: headers),
        body: requestBody,
      );
      LoggingUtils.debug(
        'PATCH request to $uri completed with status *${response.statusCode}*.',
      );
      _logResponse(response);
      _checkResponseStatus(response, url);
      return response;
    } on SocketException catch (e) {
      LoggingUtils.error('PATCH request to $uri *failed*: $e');
      throw NetworkConnectionException(
        url: url,
        originalError: e,
      );
    } on http.ClientException catch (e) {
      LoggingUtils.error('PATCH request to $uri *failed*: $e');
      throw NetworkException(
        message: 'Network request failed: ${e.message}',
        url: url,
        originalError: e,
      );
    } catch (e, s) {
      LoggingUtils.error(
        'PATCH request to $uri *failed*: $e',
        stackTrace: s,
      );
      throw NetworkException(
        message: 'Unexpected error during PATCH request: $e',
        url: url,
        originalError: e,
      );
    }
  }

  /// Performs a DELETE request.
  ///
  /// Parameters:
  /// - [url]: The URL to send the DELETE request to.
  /// - [headers]: Optional additional headers to include in the request.
  /// - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  /// A [Future] that completes with an [http.Response] containing the response data.
  ///
  /// Throws:
  /// - [NetworkException]: If the request fails due to network issues.
  /// - [HttpException]: If the request completes but returns an error status code.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final response = await NetworkUtils.delete(
  ///     'https://api.example.com/users/123',
  ///   );
  ///   print('Deleted: ${response.statusCode}');
  /// } on HttpException catch (e) {
  ///   print('HTTP error: ${e.statusCode}');
  /// }
  /// ```
  static Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final Uri uri = Uri.parse(url).replace(queryParameters: queryParameters);
    LoggingUtils.debug('Executing *DELETE* request to: $uri');
    try {
      final response = await http.delete(
        uri,
        headers: _getHeaders(additionalHeaders: headers),
      );
      LoggingUtils.debug(
        'DELETE request to $uri completed with status *${response.statusCode}*.',
      );
      _logResponse(response);
      _checkResponseStatus(response, url);
      return response;
    } on SocketException catch (e) {
      LoggingUtils.error('DELETE request to $uri *failed*: $e');
      throw NetworkConnectionException(
        url: url,
        originalError: e,
      );
    } on http.ClientException catch (e) {
      LoggingUtils.error('DELETE request to $uri *failed*: $e');
      throw NetworkException(
        message: 'Network request failed: ${e.message}',
        url: url,
        originalError: e,
      );
    } catch (e, s) {
      LoggingUtils.error(
        'DELETE request to $uri *failed*: $e',
        stackTrace: s,
      );
      throw NetworkException(
        message: 'Unexpected error during DELETE request: $e',
        url: url,
        originalError: e,
      );
    }
  }

  /// Performs a HEAD request.
  ///
  /// HEAD requests are useful for checking if a resource exists without
  /// downloading the entire response body. They return only the headers.
  ///
  /// Parameters:
  /// - [url]: The URL to send the HEAD request to.
  /// - [headers]: Optional additional headers to include in the request.
  /// - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  /// A [Future] that completes with an [http.Response] containing only headers.
  ///
  /// Throws:
  /// - [NetworkException]: If the request fails due to network issues.
  /// - [HttpException]: If the request completes but returns an error status code.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final response = await NetworkUtils.head(
  ///     'https://api.example.com/resource',
  ///   );
  ///   print('Resource exists: ${response.statusCode == 200}');
  /// } on HttpException catch (e) {
  ///   if (e.isNotFound) {
  ///     print('Resource not found');
  ///   }
  /// }
  /// ```
  static Future<http.Response> head(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final Uri uri = Uri.parse(url).replace(queryParameters: queryParameters);
    LoggingUtils.debug('Executing *HEAD* request to: $uri');
    try {
      final response = await http.head(
        uri,
        headers: _getHeaders(additionalHeaders: headers),
      );
      LoggingUtils.debug(
        'HEAD request to $uri completed with status *${response.statusCode}*.',
      );
      _checkResponseStatus(response, url);
      return response;
    } on SocketException catch (e) {
      LoggingUtils.error('HEAD request to $uri *failed*: $e');
      throw NetworkConnectionException(
        url: url,
        originalError: e,
      );
    } on http.ClientException catch (e) {
      LoggingUtils.error('HEAD request to $uri *failed*: $e');
      throw NetworkException(
        message: 'Network request failed: ${e.message}',
        url: url,
        originalError: e,
      );
    } catch (e, s) {
      LoggingUtils.error('HEAD request to $uri *failed*: $e', stackTrace: s);
      throw NetworkException(
        message: 'Unexpected error during HEAD request: $e',
        url: url,
        originalError: e,
      );
    }
  }

  /// Placeholder for WebSocket client functionality.
  /// This section would include methods for connecting, sending messages,
  /// receiving messages, and disconnecting WebSocket connections.
  /// Example:
  /// ```dart
  /// static Future<WebSocketChannel> connectWebSocket(String url) async {
  ///   LoggingUtils.info('Attempting to connect to WebSocket: $url');
  ///   // Implementation using package:web_socket_channel or similar
  ///   // final channel = WebSocketChannel.connect(Uri.parse(url));
  ///   // LoggingUtils.info('WebSocket connection established to $url');
  ///   // return channel;
  ///   throw UnimplementedError('WebSocket connect has not been implemented yet.');
  /// }
  /// ```

  /// Checks the HTTP response status code and throws an [HttpException] if the status indicates an error.
  ///
  /// This internal helper method validates that the HTTP response has a successful status code
  /// (2xx range). If the status code is 400 or higher, it throws an [HttpException] with
  /// detailed error information including the status code, URL, and response body.
  ///
  /// Parameters:
  /// - [response]: The HTTP response object to check for error status codes.
  /// - [url]: The original URL of the request, used for error context in the exception.
  ///
  /// Throws:
  /// - [HttpException]: If the response status code is 400 or higher (4xx or 5xx).
  ///
  /// Note: This method is called automatically by all HTTP request methods before returning
  /// the response to ensure consistent error handling across all network operations.
  static void _checkResponseStatus(http.Response response, String url) {
    // HTTP status codes 400-599 indicate errors (client errors 4xx, server errors 5xx)
    if (response.statusCode >= 400) {
      throw HttpException(
        statusCode: response.statusCode,
        url: url,
        responseBody: response.body,
        response: response,
      );
    }
  }

  /// Logs HTTP response details for debugging purposes.
  ///
  /// This internal helper method logs the response body and warns about error status codes.
  /// It is called automatically by HTTP request methods after receiving a response to aid
  /// in debugging network operations.
  ///
  /// Parameters:
  /// - [response]: The HTTP response object to log.
  ///
  /// Logging behavior:
  /// - Response body: Logged at DEBUG level if the body is not empty
  /// - Error status codes (4xx, 5xx): Logged at WARNING level with status code and response body
  static void _logResponse(http.Response response) {
    // Log the full response body for debugging (only if body is not empty)
    if (response.body.isNotEmpty) {
      LoggingUtils.debug(
        'Response Body: ${response.body}',
      );
    }

    // Log warning for error status codes (4xx client errors, 5xx server errors)
    if (response.statusCode >= 400) {
      LoggingUtils.warning(
        'HTTP request to ${response.request?.url} completed with error status: *${response.statusCode}*. Response: ${response.body}',
      );
    }
  }
}
