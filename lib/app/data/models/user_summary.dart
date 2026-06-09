/// Aggregate stats for the current user, from `GET /api/v1/user/me/summary`.
class UserSummary {
  final String userId;
  final int totalSop;

  const UserSummary({required this.userId, required this.totalSop});

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      userId: (json['user_id'] ?? '').toString(),
      totalSop: (json['total_sop'] is num)
          ? (json['total_sop'] as num).toInt()
          : int.tryParse('${json['total_sop']}') ?? 0,
    );
  }
}
