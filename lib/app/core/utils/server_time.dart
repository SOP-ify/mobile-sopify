DateTime? parseServerDateTime(dynamic value) {
  if (value == null) return null;
  final raw = value.toString().trim();
  if (raw.isEmpty) return null;

  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return null;

  // Already carries a timezone (trailing Z or ±HH:MM / ±HHMM) → absolute instant.
  final hasTimezone =
      raw.endsWith('Z') || RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(raw);
  if (hasTimezone) return parsed.toLocal();

  // No timezone: value is UTC from the server but Dart parsed it as local.
  // Re-interpret the wall-clock fields as UTC, then localize.
  return DateTime.utc(
    parsed.year,
    parsed.month,
    parsed.day,
    parsed.hour,
    parsed.minute,
    parsed.second,
    parsed.millisecond,
    parsed.microsecond,
  ).toLocal();
}