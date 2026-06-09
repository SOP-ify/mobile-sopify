import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../models/api_response.dart';
import '../models/generated_sop.dart';
import '../models/save_sop_request.dart';
import '../models/sop_detail.dart';
import '../models/sop_page.dart';
import '../models/text_to_sop_request.dart';
import '../models/transcription.dart';
import '../services/auth_service.dart';

/// SOP history endpoints under `/api/v1/sop`.
class SopRepository {
  SopRepository({ApiClient? client, AuthService? auth})
      : _client = client ?? ApiClient.instance,
        _auth = auth ?? AuthService.to;

  final ApiClient _client;
  final AuthService _auth;

  Future<SopPage> list({int page = 1, int limit = 10}) async {
    final json = await _client.get(
      '/api/v1/sop?page=$page&limit=$limit',
      token: _auth.token,
    );
    return ApiResponse.fromJson(json, SopPage.fromJson).dataOrThrow();
  }

  /// Fetches the full saved SOP (including steps) by id from
  /// `GET /api/v1/sop/{id}`.
  Future<SopDetail> detail(String id) async {
    final json = await _client.get('/api/v1/sop/$id', token: _auth.token);
    return ApiResponse.fromJson(json, SopDetail.fromJson).dataOrThrow();
  }

  /// Transcribes a recorded audio file to text via the ML endpoint
  /// (`POST /api/v1/ml/audio-to-text`). Uses an extended timeout.
  Future<Transcription> transcribeAudio(
    String filePath, {
    String language = 'id',
  }) async {
    final json = await _client.postMultipart(
      '/api/v1/ml/audio-to-text',
      filePath: filePath,
      fileField: 'audio',
      fields: {'language': language},
      token: _auth.token,
      timeout: const Duration(seconds: 120),
    );
    return ApiResponse.fromJson(json, Transcription.fromJson).dataOrThrow();
  }

  /// Generates a structured SOP from free-text via the ML endpoint. This call
  /// can take ~30s, so it uses an extended timeout.
  Future<GeneratedSop> generateFromText(TextToSopRequest request) async {
    final json = await _client.post(
      '/api/v1/ml/text-to-sop',
      body: request.toJson(),
      token: _auth.token,
      timeout: const Duration(seconds: 120),
    );
    return ApiResponse.fromJson(json, GeneratedSop.fromJson).dataOrThrow();
  }

  /// Persists a generated SOP to the user's history.
  Future<void> save(SaveSopRequest request) async {
    final json = await _client.post(
      '/api/v1/sop',
      body: request.toJson(),
      token: _auth.token,
    );
    final res = ApiResponse.fromJson(json, (m) => m);
    if (!res.success) {
      throw ApiException(
        res.message.isEmpty ? 'Gagal menyimpan SOP.' : res.message,
      );
    }
  }
}
