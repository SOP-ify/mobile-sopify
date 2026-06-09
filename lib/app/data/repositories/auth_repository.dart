import '../../core/network/api_client.dart';
import '../models/api_response.dart';
import '../models/auth_session.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Coordinates auth API calls with token persistence via [AuthService].
class AuthRepository {
  AuthRepository({ApiClient? client, AuthService? auth})
      : _client = client ?? ApiClient.instance,
        _auth = auth ?? AuthService.to;

  final ApiClient _client;
  final AuthService _auth;

  Future<AuthSession> register(RegisterRequest request) async {
    final json = await _client.post(
      '/api/v1/auth/register',
      body: request.toJson(),
    );
    final session =
        ApiResponse.fromJson(json, AuthSession.fromJson).dataOrThrow();
    await _auth.saveSession(token: session.accessToken, user: session.user);
    return session;
  }

  Future<AuthSession> login(LoginRequest request) async {
    final json = await _client.post(
      '/api/v1/auth/login',
      body: request.toJson(),
    );
    final session =
        ApiResponse.fromJson(json, AuthSession.fromJson).dataOrThrow();
    await _auth.saveSession(token: session.accessToken, user: session.user);
    return session;
  }

  Future<UserModel> getProfile() async {
    final json = await _client.get('/api/v1/auth/me', token: _auth.token);
    final user = ApiResponse.fromJson(json, UserModel.fromJson).dataOrThrow();
    await _auth.setUser(user);
    return user;
  }

  Future<void> logout() async {
    try {
      await _client.post('/api/v1/auth/logout', token: _auth.token);
    } finally {
      await _auth.clear();
    }
  }
}
