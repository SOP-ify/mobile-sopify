/// Body for `PUT /api/v1/user/me`. Only non-null fields are sent.
class UpdateProfileRequest {
  final String? fullName;
  final String? username;
  final String? jabatan;

  const UpdateProfileRequest({this.fullName, this.username, this.jabatan});

  Map<String, dynamic> toJson() => {
        if (fullName != null) 'full_name': fullName,
        if (username != null) 'username': username,
        if (jabatan != null) 'jabatan': jabatan,
      };
}
