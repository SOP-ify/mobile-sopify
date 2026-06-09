import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
import 'sop_result_source.dart';

/// Drives the 3-stage text-to-SOP flow:
/// 1 = input form, 2 = AI processing, 3 = result.
class SopCreateController extends GetxController implements SopResultSource {
  final SopRepository _sopRepo = Get.find<SopRepository>();

  static const int maxCatatan = 1500;
  static const String style = 'fine_tune';

  final TextEditingController sopNameController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  final RxInt charCount = 0.obs;
  @override
  final RxString selectedKategori = ''.obs;

  /// Current stage of the flow (1, 2 or 3).
  final RxInt step = 1.obs;
  @override
  final Rxn<GeneratedSop> result = Rxn<GeneratedSop>();
  @override
  final RxBool isSaving = false.obs;

  List<SopCategory> get categories => kSopCategories;

  bool get isProcessing => step.value == 2;

  @override
  String get sopName => sopNameController.text.trim();

  String get _kategoriLabel => kSopCategories
      .firstWhere(
        (c) => c.value == selectedKategori.value,
        orElse: () =>
            SopCategory(selectedKategori.value, selectedKategori.value),
      )
      .label;

  @override
  void onInit() {
    super.onInit();
    catatanController.addListener(
      () => charCount.value = catatanController.text.length,
    );
  }

  void selectKategori(String value) => selectedKategori.value = value;

  Future<void> generate() async {
    final name = sopNameController.text.trim();
    final catatan = catatanController.text.trim();
    final kategori = selectedKategori.value;

    if (name.isEmpty) {
      AppDialogs.error('Nama SOP wajib diisi.');
      return;
    }
    if (kategori.isEmpty) {
      AppDialogs.error('Pilih bidang usaha terlebih dahulu.');
      return;
    }
    if (catatan.isEmpty) {
      AppDialogs.error('Tulis prosedur kerja Anda terlebih dahulu.');
      return;
    }

    step.value = 2;
    try {
      final generated = await _sopRepo.generateFromText(
        TextToSopRequest(
          sopName: name,
          kategori: kategori,
          catatan: catatan,
          style: style,
        ),
      );
      result.value = generated;
      step.value = 3;
    } on ApiException catch (e) {
      step.value = 1;
      AppDialogs.error(e.message);
    } catch (_) {
      step.value = 1;
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
          sopName: sopNameController.text.trim(),
          kategori: selectedKategori.value,
          catatan: catatanController.text.trim(),
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

  /// Returns to the input stage so the user can tweak and regenerate.
  void editAgain() {
    result.value = null;
    step.value = 1;
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
    sopNameController.dispose();
    catatanController.dispose();
    super.onClose();
  }
}
