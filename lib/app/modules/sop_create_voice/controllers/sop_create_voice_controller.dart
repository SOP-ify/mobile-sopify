import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../core/constants/sop_categories.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/app_dialogs.dart';
import '../../../core/utils/sop_saved_dialog.dart';
import '../../../core/utils/sop_share.dart';
import '../../../data/models/generated_sop.dart';
import '../../../data/models/save_sop_request.dart';
import '../../../data/models/text_to_sop_request.dart';
import '../../../data/repositories/sop_repository.dart';
import '../../home/controllers/home_controller.dart';
import '../../riwayat/controllers/riwayat_controller.dart';
import '../../sop_create/controllers/sop_result_source.dart';

/// Recording sub-state for stage 1 of the voice flow.
enum VoiceRecState { idle, recording, transcribing }

/// Drives the 3-stage voice-to-SOP flow:
/// 1 = record + transcribe, 2 = review transcript, 3 = generate + result.
class SopCreateVoiceController extends GetxController
    implements SopResultSource {
  final SopRepository _sopRepo = Get.find<SopRepository>();
  final AudioRecorder _recorder = AudioRecorder();

  static const String style = 'fine_tune';
  static const int maxRecordSeconds = 300;

  final TextEditingController sopNameController = TextEditingController();
  final TextEditingController transcriptController = TextEditingController();

  final RxString selectedKategori = ''.obs;

  /// Current stage of the flow (1, 2 or 3).
  final RxInt step = 1.obs;
  final Rx<VoiceRecState> recState = VoiceRecState.idle.obs;
  final RxInt elapsedSeconds = 0.obs;
  final RxBool isGenerating = false.obs;

  final RxString durationFormatted = ''.obs;
  final RxInt wordCount = 0.obs;

  @override
  final Rxn<GeneratedSop> result = Rxn<GeneratedSop>();
  @override
  final RxBool isSaving = false.obs;

  Timer? _timer;
  String? _recordPath;

  List<SopCategory> get categories => kSopCategories;

  @override
  String get sopName => sopNameController.text.trim();

  String get _kategoriLabel => kSopCategories
      .firstWhere(
        (c) => c.value == selectedKategori.value,
        orElse: () =>
            SopCategory(selectedKategori.value, selectedKategori.value),
      )
      .label;

  String get elapsedFormatted => _format(elapsedSeconds.value);
  String get maxFormatted => _format(maxRecordSeconds);

  String _format(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void selectKategori(String value) => selectedKategori.value = value;

  /// Tap handler for the record button: starts or stops the recording.
  Future<void> toggleRecord() async {
    if (recState.value == VoiceRecState.recording) {
      await stopRecording();
    } else if (recState.value == VoiceRecState.idle) {
      await startRecording();
    }
  }

  Future<void> startRecording() async {
    if (sopName.isEmpty) {
      AppDialogs.error('Nama SOP wajib diisi sebelum merekam.');
      return;
    }
    if (selectedKategori.value.isEmpty) {
      AppDialogs.error('Pilih bidang usaha terlebih dahulu.');
      return;
    }

    final allowed = await _recorder.hasPermission();
    if (!allowed) {
      AppDialogs.error('Izin mikrofon diperlukan untuk merekam.');
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/sopify_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(const RecordConfig(), path: path);
      _recordPath = path;
      elapsedSeconds.value = 0;
      recState.value = VoiceRecState.recording;
      _startTimer();
    } catch (_) {
      recState.value = VoiceRecState.idle;
      AppDialogs.error('Gagal memulai perekaman. Silakan coba lagi.');
    }
  }

  Future<void> stopRecording() async {
    // Guard against re-entrancy: a manual tap and the 300s auto-stop can race.
    if (recState.value != VoiceRecState.recording) return;
    _stopTimer();
    // Claim the pipeline before awaiting so a second call returns early.
    recState.value = VoiceRecState.transcribing;
    String? path;
    try {
      path = await _recorder.stop();
    } catch (_) {
      path = _recordPath;
    }
    path ??= _recordPath;

    if (path == null) {
      recState.value = VoiceRecState.idle;
      AppDialogs.error('Rekaman tidak tersimpan. Silakan coba lagi.');
      return;
    }

    try {
      final t = await _sopRepo.transcribeAudio(path, language: 'id');
      if (t.transcript.trim().isEmpty) {
        recState.value = VoiceRecState.idle;
        AppDialogs.error(
          'Tidak ada suara terdeteksi. Coba rekam ulang dengan lebih jelas.',
        );
        return;
      }
      transcriptController.text = t.transcript.trim();
      durationFormatted.value = t.durationFormatted;
      wordCount.value = t.wordCount;
      recState.value = VoiceRecState.idle;
      step.value = 2;
    } on ApiException catch (e) {
      recState.value = VoiceRecState.idle;
      AppDialogs.error(e.message);
    } catch (_) {
      recState.value = VoiceRecState.idle;
      AppDialogs.error('Gagal mentranskripsi audio. Silakan coba lagi.');
    }
  }

  /// Discards the current transcript and returns to the recording stage.
  void rekamUlang() {
    transcriptController.clear();
    durationFormatted.value = '';
    wordCount.value = 0;
    elapsedSeconds.value = 0;
    recState.value = VoiceRecState.idle;
    step.value = 1;
  }

  Future<void> generate() async {
    if (isGenerating.value) return;
    final catatan = transcriptController.text.trim();
    if (sopName.isEmpty) {
      AppDialogs.error('Nama SOP wajib diisi.');
      return;
    }
    if (selectedKategori.value.isEmpty) {
      AppDialogs.error('Pilih bidang usaha terlebih dahulu.');
      return;
    }
    if (catatan.isEmpty) {
      AppDialogs.error('Transkripsi masih kosong.');
      return;
    }

    step.value = 3;
    isGenerating.value = true;
    try {
      final generated = await _sopRepo.generateFromText(
        TextToSopRequest(
          sopName: sopName,
          kategori: selectedKategori.value,
          catatan: catatan,
          style: style,
        ),
      );
      result.value = generated;
      isGenerating.value = false;
    } on ApiException catch (e) {
      isGenerating.value = false;
      step.value = 2;
      AppDialogs.error(e.message);
    } catch (_) {
      isGenerating.value = false;
      step.value = 2;
      AppDialogs.error('Gagal membuat SOP. Silakan coba lagi.');
    }
  }

  @override
  Future<void> save() async {
    final generated = result.value;
    if (generated == null || isSaving.value) return;

    isSaving.value = true;
    try {
      await _sopRepo.save(
        SaveSopRequest.fromGenerated(
          sopName: sopName,
          kategori: selectedKategori.value,
          catatan: transcriptController.text.trim(),
          style: style,
          generated: generated,
        ),
      );
      _refreshLists();
      await showSopSavedDialog(
        shareText: SopShare.buildText(
          name: sopName,
          kategoriLabel: _kategoriLabel,
          sop: generated,
        ),
      );
      Get.back();
    } on ApiException catch (e) {
      AppDialogs.error(e.message);
    } catch (_) {
      AppDialogs.error('Gagal menyimpan SOP. Silakan coba lagi.');
    } finally {
      isSaving.value = false;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds.value += 1;
      if (elapsedSeconds.value >= maxRecordSeconds) {
        stopRecording();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _refreshLists() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().load();
    }
    if (Get.isRegistered<RiwayatController>()) {
      Get.find<RiwayatController>().load();
    }
  }

  @override
  void onClose() {
    _stopTimer();
    _recorder.dispose();
    sopNameController.dispose();
    transcriptController.dispose();
    super.onClose();
  }
}
