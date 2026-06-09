/// Result of `POST /api/v1/ml/audio-to-text`
/// (`data` = `{ transcript, duration_seconds, duration_formatted, word_count }`).
class Transcription {
  final String transcript;
  final double durationSeconds;
  final String durationFormatted;
  final int wordCount;

  const Transcription({
    required this.transcript,
    required this.durationSeconds,
    required this.durationFormatted,
    required this.wordCount,
  });

  factory Transcription.fromJson(Map<String, dynamic> json) {
    final seconds = (json['duration_seconds'] is num)
        ? (json['duration_seconds'] as num).toDouble()
        : 0.0;
    return Transcription(
      transcript: (json['transcript'] ?? '').toString(),
      durationSeconds: seconds,
      durationFormatted: (json['duration_formatted'] ?? '').toString(),
      wordCount: (json['word_count'] is num)
          ? (json['word_count'] as num).toInt()
          : 0,
    );
  }
}
