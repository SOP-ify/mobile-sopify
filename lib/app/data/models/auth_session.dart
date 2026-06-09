import 'user_model.dart';

/// The `data` payload returned by login & register: a bearer token plus the
/// authenticated user.
class AuthSession {
  final String accessToken;
  final String tokenType;
  final int? expiresIn;
  final UserModel? user;

  const AuthSession({
    required this.accessToken,
    this.tokenType = 'bearer',
    this.expiresIn,
    this.user,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final dynamic rawUser = json['user'];
    final dynamic rawExpires = json['expires_in'];
    return AuthSession(
      accessToken: (json['access_token'] ?? '').toString(),
      tokenType: (json['token_type'] ?? 'bearer').toString(),
      expiresIn: rawExpires is int
          ? rawExpires
          : int.tryParse('${rawExpires ?? ''}'),
      user: rawUser is Map<String, dynamic>
          ? UserModel.fromJson(rawUser)
          : null,
    );
  }
}
