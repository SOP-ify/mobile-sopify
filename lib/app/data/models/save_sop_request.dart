import 'generated_sop.dart';
import 'sop_step.dart';

/// Body for `POST /api/v1/sop` (persist a generated SOP to history).
class SaveSopRequest {
  final String sopName;
  final String kategori;
  final String catatan;
  final String sop;
  final String style;
  final List<SopStep> steps;
  final int stepCount;
  final bool valid;
  final int attempt;
  final double? generationTimeSeconds;

  const SaveSopRequest({
    required this.sopName,
    required this.kategori,
    required this.catatan,
    required this.sop,
    required this.style,
    required this.steps,
    required this.stepCount,
    required this.valid,
    required this.attempt,
    this.generationTimeSeconds,
  });

  /// Builds the save payload from the original user input plus the AI result.
  factory SaveSopRequest.fromGenerated({
    required String sopName,
    required String kategori,
    required String catatan,
    required String style,
    required GeneratedSop generated,
  }) {
    return SaveSopRequest(
      sopName: sopName,
      kategori: kategori,
      catatan: catatan,
      sop: generated.sop,
      style: style,
      steps: generated.steps,
      stepCount: generated.stepCount,
      valid: generated.valid,
      attempt: generated.attempt,
      generationTimeSeconds: generated.generationTimeSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
        'sop_name': sopName,
        'kategori': kategori,
        'catatan': catatan,
        'sop': sop,
        'style': style,
        'steps': steps.map((e) => e.toJson()).toList(),
        'step_count': stepCount,
        'valid': valid,
        'attempt': attempt,
        'generation_time_seconds': generationTimeSeconds,
      };
}
