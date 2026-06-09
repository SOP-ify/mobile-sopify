import 'sop_step.dart';

/// The SOP produced by `POST /api/v1/ml/text-to-sop`
/// (`data` = `{ sop, steps, step_count, valid, attempt, generation_time_seconds }`).
class GeneratedSop {
  final String sop;
  final List<SopStep> steps;
  final int stepCount;
  final bool valid;
  final int attempt;
  final double? generationTimeSeconds;

  const GeneratedSop({
    required this.sop,
    required this.steps,
    required this.stepCount,
    required this.valid,
    required this.attempt,
    this.generationTimeSeconds,
  });

  factory GeneratedSop.fromJson(Map<String, dynamic> json) {
    final dynamic raw = json['steps'];
    final steps = raw is List
        ? raw
            .whereType<Map>()
            .map((e) => SopStep.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <SopStep>[];
    return GeneratedSop(
      sop: (json['sop'] ?? '').toString(),
      steps: steps,
      stepCount: (json['step_count'] is num)
          ? (json['step_count'] as num).toInt()
          : steps.length,
      valid: json['valid'] == null ? true : json['valid'] == true,
      attempt: (json['attempt'] is num) ? (json['attempt'] as num).toInt() : 1,
      generationTimeSeconds: (json['generation_time_seconds'] is num)
          ? (json['generation_time_seconds'] as num).toDouble()
          : null,
    );
  }
}
