import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/generated_sop.dart';

/// Builds shareable plain text from a generated SOP and exposes share targets.
class SopShare {
  SopShare._();

  static String buildText({
    required String name,
    required String kategoriLabel,
    required GeneratedSop sop,
  }) {
    final b = StringBuffer();
    b.writeln('*${name.isEmpty ? 'SOP' : name}*');
    b.writeln('Bidang usaha: $kategoriLabel');
    b.writeln('Dibuat dengan SOP-ify');
    b.writeln();
    if (sop.steps.isNotEmpty) {
      for (final s in sop.steps) {
        b.writeln('${s.no}. ${s.judul}');
        if (s.deskripsi.isNotEmpty && s.deskripsi != s.judul) {
          b.writeln('   ${s.deskripsi}');
        }
        final meta = <String>[
          if (s.pic != null && s.pic!.isNotEmpty) 'PIC: ${s.pic}',
          if (s.durasi != null && s.durasi!.isNotEmpty) 'Durasi: ${s.durasi}',
        ];
        if (meta.isNotEmpty) b.writeln('   (${meta.join(', ')})');
      }
    } else if (sop.sop.isNotEmpty) {
      b.writeln(sop.sop);
    }
    return b.toString().trim();
  }

  /// Opens WhatsApp with the SOP text prefilled. Falls back to the system
  /// share sheet when WhatsApp can't be launched.
  static Future<void> whatsapp(String text) async {
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) await other(text);
  }

  /// Opens the system share sheet (WhatsApp, email, etc.).
  static Future<void> other(String text) async {
    await Share.share(text);
  }
}
