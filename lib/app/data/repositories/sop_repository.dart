import '../../core/network/api_client.dart';
import '../models/api_response.dart';
import '../models/sop_page.dart';
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
}
