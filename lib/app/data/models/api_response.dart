import '../../core/network/api_exception.dart';

/// Generic wrapper for the backend's `{ success, message, data }` envelope.
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Returns [data] when the envelope is valid, otherwise throws a controlled
  /// [ApiException] so callers never have to force-unwrap a possibly-null
  /// payload (e.g. a 2xx response with `success:false` or `data:null`).
  T dataOrThrow() {
    if (!success || data == null) {
      throw ApiException(
        message.isEmpty ? 'Respons tidak valid dari server.' : message,
      );
    }
    return data as T;
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> data)? parser,
  ) {
    final dynamic raw = json['data'];
    return ApiResponse<T>(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data: (parser != null && raw is Map<String, dynamic>)
          ? parser(raw)
          : null,
    );
  }
}
