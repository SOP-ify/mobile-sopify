/// Human-friendly "x ago" label in Indonesian, e.g. "2 jam lalu".
String timeAgo(DateTime? dt) {
  if (dt == null) return '-';
  final diff = DateTime.now().difference(dt.toLocal());
  if (diff.inMinutes < 1) return 'Baru saja';
  if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
  if (diff.inHours < 24) return '${diff.inHours} jam lalu';
  if (diff.inDays == 1) return '1 hari lalu';
  if (diff.inDays < 7) return '${diff.inDays} hari lalu';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} minggu lalu';
  if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} bulan lalu';
  return '${(diff.inDays / 365).floor()} tahun lalu';
}

/// Section header bucket for the Riwayat list, e.g. "HARI INI", "KEMARIN".
String dayBucket(DateTime? dt) {
  if (dt == null) return 'LAINNYA';
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final that = dt.toLocal();
  final diff = today.difference(DateTime(that.year, that.month, that.day)).inDays;
  if (diff <= 0) return 'HARI INI';
  if (diff == 1) return 'KEMARIN';
  if (diff < 7) return '$diff HARI LALU';
  if (diff < 30) return '${(diff / 7).floor()} MINGGU LALU';
  return 'LEBIH LAMA';
}
