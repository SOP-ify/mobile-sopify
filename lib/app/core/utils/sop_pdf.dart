import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/sop_step.dart';

/// Outcome of a PDF export: the saved file path and whether it landed in the
/// public Downloads folder (vs. an app-private fallback directory).
class SopPdfResult {
  final String path;
  final bool inDownloads;
  const SopPdfResult({required this.path, required this.inDownloads});
}

/// Builds a printable PDF from a SOP and saves it to the device's Downloads
/// folder on Android. PDF generation is pure Dart (the `pdf` package).
class SopPdf {
  SopPdf._();

  static const PdfColor _brand = PdfColor.fromInt(0xFF005DA8);
  static const PdfColor _accent = PdfColor.fromInt(0xFF1A6FD4);
  static const PdfColor _accentBg = PdfColor.fromInt(0xFFEFF4FF);

  /// Generates the PDF and writes it to Downloads (Android). Falls back to an
  /// app-private directory if the public folder is not writable; the returned
  /// [SopPdfResult.inDownloads] reflects which happened.
  static Future<SopPdfResult> saveToDownloads({
    required String name,
    required String kategoriLabel,
    required List<SopStep> steps,
    String fallbackText = '',
    DateTime? createdAt,
  }) async {
    final bytes = await _build(
      name: name,
      kategoriLabel: kategoriLabel,
      steps: steps,
      fallbackText: fallbackText,
      createdAt: createdAt,
    );
    final fileName = _fileName(name);

    if (Platform.isAndroid) {
      await _ensureStoragePermission();
      try {
        final downloads = Directory('/storage/emulated/0/Download');
        if (await downloads.exists()) {
          final file = File('${downloads.path}/$fileName');
          await file.writeAsBytes(bytes, flush: true);
          return SopPdfResult(path: file.path, inDownloads: true);
        }
      } catch (_) {
        // Scoped storage may block the public path — fall back below.
      }
      final ext = await getExternalStorageDirectory();
      final dir = ext ?? await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      return SopPdfResult(path: file.path, inDownloads: false);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return SopPdfResult(path: file.path, inDownloads: false);
  }

  static Future<void> _ensureStoragePermission() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  static Future<Uint8List> _build({
    required String name,
    required String kategoriLabel,
    required List<SopStep> steps,
    required String fallbackText,
    DateTime? createdAt,
  }) async {
    final doc = pw.Document();
    final title = name.trim().isEmpty ? 'SOP' : name.trim();
    final meta = createdAt == null
        ? 'Dibuat dengan SOP-ify'
        : 'Dibuat dengan SOP-ify - ${_fmtDate(createdAt)}';

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: _brand,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Bidang usaha: $kategoriLabel',
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            meta,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 16),
          if (steps.isNotEmpty)
            ...steps.map(_stepWidget)
          else if (fallbackText.isNotEmpty)
            pw.Text(fallbackText, style: const pw.TextStyle(fontSize: 11))
          else
            pw.Text(
              'Belum ada langkah pada SOP ini.',
              style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
            ),
        ],
      ),
    );
    return doc.save();
  }

  static pw.Widget _stepWidget(SopStep s) {
    final metaParts = <String>[
      if (s.pic != null && s.pic!.isNotEmpty) 'PIC: ${s.pic}',
      if (s.durasi != null && s.durasi!.isNotEmpty) 'Durasi: ${s.durasi}',
    ];
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 22,
            height: 22,
            alignment: pw.Alignment.center,
            decoration: const pw.BoxDecoration(
              color: _accentBg,
              shape: pw.BoxShape.circle,
            ),
            child: pw.Text(
              '${s.no}',
              style: pw.TextStyle(
                fontSize: 10,
                color: _accent,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  s.judul,
                  style:
                      pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                if (s.deskripsi.isNotEmpty && s.deskripsi != s.judul) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    s.deskripsi,
                    style: const pw.TextStyle(
                        fontSize: 10, color: PdfColors.grey800),
                  ),
                ],
                if (metaParts.isNotEmpty) ...[
                  pw.SizedBox(height: 3),
                  pw.Text(
                    metaParts.join('   |   '),
                    style: const pw.TextStyle(
                        fontSize: 9, color: PdfColors.grey600),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  static String _fileName(String name) {
    final base = name.trim().isEmpty ? 'SOP' : name.trim();
    final slug = base
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final stamp = DateTime.now().millisecondsSinceEpoch;
    return 'SOP_${slug.isEmpty ? 'dokumen' : slug}_$stamp.pdf';
  }
}
