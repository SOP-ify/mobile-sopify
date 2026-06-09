/// A SOP-ify user as returned by `/auth/me`, `/user/me`, login and register.
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? username;
  final String? jabatan;
  final bool isActive;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.username,
    this.jabatan,
    this.isActive = true,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      fullName: (json['full_name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phoneNumber: json['phone_number']?.toString(),
      username: json['username']?.toString(),
      jabatan: json['jabatan']?.toString(),
      isActive: json['is_active'] == true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'username': username,
        'jabatan': jabatan,
        'is_active': isActive,
        'created_at': createdAt?.toIso8601String(),
      };
}
