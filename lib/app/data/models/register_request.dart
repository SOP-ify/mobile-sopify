/// Request body for `POST /api/v1/auth/register`.
class RegisterRequest {
  final String fullName;
  final String email;
  final String password;
  final String? phoneNumber;
  final bool agreeToTerms;

  const RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.agreeToTerms = true,
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'email': email,
        'password': password,
        if (phoneNumber != null && phoneNumber!.isNotEmpty)
          'phone_number': phoneNumber,
        'agree_to_terms': agreeToTerms,
      };
}
