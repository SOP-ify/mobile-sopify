import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

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
  }) {
    return _send(
      () => http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: _headers(token),
            body: jsonEncode(body ?? <String, dynamic>{}),
          )
          .timeout(_timeout),
    );
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
