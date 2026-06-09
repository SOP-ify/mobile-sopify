/// A single SOP as returned in the `GET /api/v1/sop` list.
class SopModel {
  final String id;
  final String userId;
  final String sopName;
  final String kategori;
  final String style;
  final int stepCount;
  final DateTime? createdAt;

  const SopModel({
    required this.id,
    required this.userId,
    required this.sopName,
    required this.kategori,
    required this.style,
    required this.stepCount,
    this.createdAt,
  });

  factory SopModel.fromJson(Map<String, dynamic> json) {
    return SopModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      sopName: (json['sop_name'] ?? '').toString(),
      kategori: (json['kategori'] ?? '').toString(),
      style: (json['style'] ?? '').toString(),
      stepCount:
          (json['step_count'] is num) ? (json['step_count'] as num).toInt() : 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
    );
  }
}
