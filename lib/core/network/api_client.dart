import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../storage/storage_service.dart';
import 'api_exception.dart';

/// Production-ready HTTP client wrapper for BuildMove FastAPI backend.
/// Automatically injects Bearer JWT, handles timeouts, and serializes JSON.
class ApiClient {
  final http.Client _httpClient;
  final StorageService _storageService;
  final String baseUrl;

  ApiClient({
    http.Client? httpClient,
    required StorageService storageService,
    String? baseUrlOverride,
  })  : _httpClient = httpClient ?? http.Client(),
        _storageService = storageService,
        baseUrl = baseUrlOverride ?? ApiEndpoints.devBaseUrl;

  Map<String, String> _buildHeaders({Map<String, String>? extraHeaders}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams, Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
    return _sendRequest(() => _httpClient.get(uri, headers: _buildHeaders(extraHeaders: headers)));
  }

  Future<dynamic> post(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return _sendRequest(() => _httpClient.post(
          uri,
          headers: _buildHeaders(extraHeaders: headers),
          body: body != null ? jsonEncode(body) : null,
        ));
  }

  Future<dynamic> put(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return _sendRequest(() => _httpClient.put(
          uri,
          headers: _buildHeaders(extraHeaders: headers),
          body: body != null ? jsonEncode(body) : null,
        ));
  }

  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return _sendRequest(() => _httpClient.delete(uri, headers: _buildHeaders(extraHeaders: headers)));
  }

  Future<dynamic> _sendRequest(Future<http.Response> Function() requestFn) async {
    try {
      final response = await requestFn().timeout(const Duration(seconds: 20));
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(
        message: 'No internet connection. Please verify your network.',
        statusCode: 0,
      );
    } on TimeoutException {
      throw const ApiException(
        message: 'Request timed out while contacting BuildMove servers.',
        statusCode: 408,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Unexpected network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    dynamic decodedBody;
    try {
      if (response.body.isNotEmpty) {
        decodedBody = jsonDecode(response.body);
      }
    } catch (_) {
      decodedBody = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    }

    final message = decodedBody is Map && decodedBody.containsKey('detail')
        ? decodedBody['detail'].toString()
        : 'Server error (${response.statusCode})';

    throw ApiException(
      message: message,
      statusCode: response.statusCode,
      details: decodedBody,
    );
  }
}
