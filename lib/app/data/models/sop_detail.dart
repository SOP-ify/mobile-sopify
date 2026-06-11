import '../../core/utils/server_time.dart';
import 'generated_sop.dart';
import 'sop_step.dart';

/// A saved SOP with its full content (steps + raw text), as returned by
/// `GET /api/v1/sop/{id}`.
class SopDetail {
  final String id;
  final String sopName;
  final String kategori;
  final String style;
  final String catatan;
  final String sop;
  final List<SopStep> steps;
  final int stepCount;
  final DateTime? createdAt;

  const SopDetail({
    required this.id,
    required this.sopName,
    required this.kategori,
    required this.style,
    required this.catatan,
    required this.sop,
    required this.steps,
    required this.stepCount,
    this.createdAt,
  });

  factory SopDetail.fromJson(Map<String, dynamic> json) {
    final dynamic raw = json['steps'];
    final steps = raw is List
        ? raw
        .whereType<Map>()
        .map((e) => SopStep.fromJson(Map<String, dynamic>.from(e)))
        .toList()
        : <SopStep>[];
    return SopDetail(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      sopName: (json['sop_name'] ?? '').toString(),
      kategori: (json['kategori'] ?? '').toString(),
      style: (json['style'] ?? '').toString(),
      catatan: (json['catatan'] ?? '').toString(),
      sop: (json['sop'] ?? '').toString(),
      steps: steps,
      stepCount: (json['step_count'] is num)
          ? (json['step_count'] as num).toInt()
          : steps.length,
      createdAt: parseServerDateTime(json['created_at']),
    );
  }

  /// Adapts this saved SOP to the [GeneratedSop] shape so it can reuse the
  /// shared share-text builder.
  GeneratedSop get asGenerated => GeneratedSop(
    sop: sop,
    steps: steps,
    stepCount: stepCount,
    valid: true,
    attempt: 1,
  );
}