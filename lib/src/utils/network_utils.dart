import 'dart:convert';
import 'package:http/http.dart' as http;
import './logging_utils.dart'; // Assuming LoggingUtils is in the same directory or path is adjusted

/// A utility class for network operations.
/// All methods are static as per the guidelines.
class NetworkUtils {
  // Private constructor to prevent instantiation.
  NetworkUtils._();

  static String? _bearerToken;

  /// Sets the global Bearer token for API requests.
  static void setBearerToken(String token) {
    _bearerToken = token;
    LoggingUtils.info('Bearer token has been *set*.');
  }

  /// Clears the global Bearer token.
  static void clearBearerToken() {
    _bearerToken = null;
    LoggingUtils.info('Bearer token has been *cleared*.');
  }

  /// Internal method to get headers, including the Bearer token if set.
  static Map<String, String> _getHeaders({
    Map<String, String>? additionalHeaders,
  }) {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (_bearerToken != null) {
      headers['Authorization'] = 'Bearer $_bearerToken';
    }
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }

  /// Performs a GET request.
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
      return response;
    } catch (e, s) {
      LoggingUtils.error('GET request to $uri *failed*: $e', stackTrace: s);
      rethrow;
    }
  }

  /// Performs a POST request.
  static Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final Uri uri = Uri.parse(url).replace(queryParameters: queryParameters);
    final String requestBody = body == null ? '{}' : jsonEncode(body);
    LoggingUtils.debug(
      'Executing *POST* request to: $uri with body: ${requestBody.substring(0, requestBody.length > 100 ? 100 : requestBody.length)}',
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
      return response;
    } catch (e, s) {
      LoggingUtils.error('POST request to $uri *failed*: $e', stackTrace: s);
      rethrow;
    }
  }

  // Add other HTTP methods like PUT, DELETE as needed, following a similar pattern.
  // static Future<http.Response> put(...) async { ... }
  // static Future<http.Response> delete(...) async { ... }

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

  static void _logResponse(http.Response response) {
    if (response.body.isNotEmpty) {
      LoggingUtils.debug(
        'Response Body: ${response.body}',
      );
    }
    if (response.statusCode >= 400) {
      LoggingUtils.warning(
        'HTTP request to ${response.request?.url} completed with error status: *${response.statusCode}*. Response: ${response.body}',
      );
    }
  }
}
