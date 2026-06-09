import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

/// Thin HTTP wrapper around the SOP-ify backend.
///
/// Decodes the JSON envelope, raises [ApiException] with a human-readable
/// message for non-2xx responses (parsing FastAPI's `detail` field), and keeps
/// auth concerns out by accepting an optional bearer [token] per call.
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  static const String baseUrl =
      'https://backend-api-464880705922.asia-southeast1.run.app';
  static const Duration _timeout = Duration(seconds: 30);

  Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
    Duration? timeout,
  }) {
    return _send(
      () => http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: _headers(token),
            body: jsonEncode(body ?? <String, dynamic>{}),
          )
          .timeout(timeout ?? _timeout),
    );
  }

  /// Uploads a single file via `multipart/form-data` alongside optional text
  /// [fields]. Used by the audio-to-text ML endpoint.
  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required String filePath,
    required String fileField,
    Map<String, String>? fields,
    String? token,
    Duration? timeout,
  }) {
    return _send(() async {
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl$path'));
      request.headers['Accept'] = 'application/json';
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      fields?.forEach((key, value) => request.fields[key] = value);
      request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
      final streamed = await request.send().timeout(timeout ?? _timeout);
      return http.Response.fromStream(streamed);
    });
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) {
    return _send(
      () => http
          .put(
            Uri.parse('$baseUrl$path'),
            headers: _headers(token),
            body: jsonEncode(body ?? <String, dynamic>{}),
          )
          .timeout(_timeout),
    );
  }

  Future<Map<String, dynamic>> delete(String path, {String? token}) {
    return _send(
      () => http
          .delete(Uri.parse('$baseUrl$path'), headers: _headers(token))
          .timeout(_timeout),
    );
  }

  Future<Map<String, dynamic>> get(String path, {String? token}) {
    return _send(
      () => http
          .get(Uri.parse('$baseUrl$path'), headers: _headers(token))
          .timeout(_timeout),
    );
  }

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    final http.Response res;
    try {
      res = await request();
    } catch (_) {
      throw ApiException(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    }

    final dynamic decoded =
        res.body.isEmpty ? <String, dynamic>{} : jsonDecode(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (decoded is Map<String, dynamic>) return decoded;
      return <String, dynamic>{'data': decoded};
    }

    throw ApiException(_parseError(decoded), statusCode: res.statusCode);
  }

  String _parseError(dynamic decoded) {
    if (decoded is Map) {
      final detail = decoded['detail'];
      if (detail is String && detail.isNotEmpty) return detail;
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map && first['msg'] != null) {
          return first['msg'].toString();
        }
      }
      final message = decoded['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}
