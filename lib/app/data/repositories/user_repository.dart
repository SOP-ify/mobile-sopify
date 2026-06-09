import '../../core/network/api_client.dart';
import '../models/api_response.dart';
import '../models/update_profile_request.dart';
import '../models/user_model.dart';
import '../models/user_summary.dart';
import '../services/auth_service.dart';

/// Profile + account stats endpoints under `/api/v1/user`.
class UserRepository {
  UserRepository({ApiClient? client, AuthService? auth})
      : _client = client ?? ApiClient.instance,
        _auth = auth ?? AuthService.to;

  final ApiClient _client;
  final AuthService _auth;

  Future<UserModel> getProfile() async {
    final json = await _client.get('/api/v1/user/me', token: _auth.token);
    final user = ApiResponse.fromJson(json, UserModel.fromJson).dataOrThrow();
    await _auth.setUser(user);
    return user;
  }

  Future<UserModel> updateProfile(UpdateProfileRequest request) async {
    final json = await _client.put(
      '/api/v1/user/me',
      body: request.toJson(),
      token: _auth.token,
    );
    final user = ApiResponse.fromJson(json, UserModel.fromJson).dataOrThrow();
    await _auth.setUser(user);
    return user;
  }

  Future<UserSummary> getSummary() async {
    final json =
        await _client.get('/api/v1/user/me/summary', token: _auth.token);
    return ApiResponse.fromJson(json, UserSummary.fromJson).dataOrThrow();
  }
}
