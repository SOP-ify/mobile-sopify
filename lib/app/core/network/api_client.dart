import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_exception.dart';

/// Thin Dio wrapper around the SOP-ify backend.
///
/// Reads the base URL from `.env` (`API_BASE_URL`), decodes the JSON envelope,
/// and raises [ApiException] with a human-readable message for non-2xx
/// responses (parsing FastAPI's `detail` field). Auth stays out of here: each
/// call accepts an optional bearer [token].
class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        sendTimeout: _timeout,
        responseType: ResponseType.json,
        // Handle status codes ourselves so error parsing stays in one place.
        validateStatus: (_) => true,
        headers: const {'Accept': 'application/json'},
      ),
    );
    // Verbose request/response logging in debug builds only.
    assert(() {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
      return true;
    }());
  }

  static final ApiClient instance = ApiClient._();

  /// Base URL loaded from `.env`. Falls back to the hosted Cloud Run backend
  /// when the env entry is missing (e.g. `.env` not bundled).
  static String get baseUrl =>
      dotenv.maybeGet('API_BASE_URL') ??
      'https://backend-api-464880705922.asia-southeast1.run.app';

  static const Duration _timeout = Duration(seconds: 30);

  late final Dio _dio;

  Options _jsonOptions(String? token, {Duration? timeout}) => Options(
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
        sendTimeout: timeout,
        receiveTimeout: timeout,
      );

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
    Duration? timeout,
  }) {
    return _send(
      () => _dio.post(
        path,
        data: body ?? <String, dynamic>{},
        options: _jsonOptions(token, timeout: timeout),
      ),
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
      final formData = FormData.fromMap(<String, dynamic>{
        ...?fields,
        fileField: await MultipartFile.fromFile(filePath),
      });
      return _dio.post(
        path,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
      );
    });
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) {
    return _send(
      () => _dio.put(
        path,
        data: body ?? <String, dynamic>{},
        options: _jsonOptions(token),
      ),
    );
  }

  Future<Map<String, dynamic>> delete(String path, {String? token}) {
    return _send(() => _dio.delete(path, options: _jsonOptions(token)));
  }

  Future<Map<String, dynamic>> get(String path, {String? token}) {
    return _send(() => _dio.get(path, options: _jsonOptions(token)));
  }

  Future<Map<String, dynamic>> _send(
    Future<Response<dynamic>> Function() request,
  ) async {
    final Response<dynamic> res;
    try {
      res = await request();
    } on DioException catch (e) {
      // A server reply carried by the exception still holds a useful message.
      final response = e.response;
      if (response != null) {
        throw ApiException(
          _parseError(_decode(response.data)),
          statusCode: response.statusCode,
        );
      }
      throw ApiException(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    } catch (_) {
      throw ApiException(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    }

    final dynamic decoded = _decode(res.data);
    final int status = res.statusCode ?? 0;

    if (status >= 200 && status < 300) {
      if (decoded is Map<String, dynamic>) return decoded;
      return <String, dynamic>{'data': decoded};
    }

    throw ApiException(_parseError(decoded), statusCode: status);
  }

  /// Normalises a Dio response body to decoded JSON regardless of whether Dio
  /// already parsed it or handed back a raw string.
  dynamic _decode(dynamic data) {
    if (data == null) return <String, dynamic>{};
    if (data is String) {
      if (data.isEmpty) return <String, dynamic>{};
      try {
        return jsonDecode(data);
      } catch (_) {
        return <String, dynamic>{'message': data};
      }
    }
    return data;
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
