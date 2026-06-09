import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/sop_categories.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/app_dialogs.dart';
import '../../../core/utils/sop_pdf.dart';
import '../../../core/utils/sop_share.dart';
import '../../../data/models/sop_detail.dart';
import '../../../data/models/sop_model.dart';
import '../../../data/repositories/sop_repository.dart';

/// Loads a saved SOP's full content and powers the share / copy / PDF actions
/// on the detail screen. The list item ([summary]) is passed via
/// `Get.arguments` so the header can render instantly while the full SOP loads.
class SopDetailController extends GetxController {
  SopDetailController(this.summary);

  final SopModel? summary;
  final SopRepository _repo = Get.find<SopRepository>();

  final Rxn<SopDetail> detail = Rxn<SopDetail>();
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxBool isExporting = false.obs;

  String get title => detail.value?.sopName ?? summary?.sopName ?? 'Detail SOP';

  String get kategoriLabel {
    final value = detail.value?.kategori ?? summary?.kategori ?? '';
    return kSopCategories
        .firstWhere(
          (c) => c.value == value,
          orElse: () => SopCategory(value, value),
        )
        .label;
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final id = summary?.id ?? '';
    if (id.isEmpty) {
      isLoading.value = false;
      error.value = 'SOP tidak ditemukan.';
      return;
    }
    isLoading.value = true;
    error.value = '';
    try {
      detail.value = await _repo.detail(id);
    } on ApiException catch (e) {
      error.value = e.message;
    } catch (_) {
      error.value = 'Gagal memuat detail SOP. Silakan coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  String _shareText() {
    final d = detail.value;
    if (d == null) return '';
    return SopShare.buildText(
      name: d.sopName.isEmpty ? (summary?.sopName ?? 'SOP') : d.sopName,
      kategoriLabel: kategoriLabel,
      sop: d.asGenerated,
    );
  }

  Future<void> share() async {
    final text = _shareText();
    if (text.isEmpty) return;
    await SopShare.other(text);
  }

  Future<void> copy() async {
    final text = _shareText();
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    AppDialogs.success('SOP disalin ke clipboard.');
  }

  Future<void> exportPdf() async {
    final d = detail.value;
    if (d == null || isExporting.value) return;
    isExporting.value = true;
    try {
      final result = await SopPdf.saveToDownloads(
        name: d.sopName.isEmpty ? (summary?.sopName ?? 'SOP') : d.sopName,
        kategoriLabel: kategoriLabel,
        steps: d.steps,
        fallbackText: d.sop,
        createdAt: d.createdAt ?? summary?.createdAt,
      );
      if (result.inDownloads) {
        AppDialogs.success('PDF tersimpan di folder Download.');
      } else {
        AppDialogs.success('PDF tersimpan di:\n${result.path}');
      }
    } catch (_) {
      AppDialogs.error('Gagal menyimpan PDF. Periksa izin penyimpanan.');
    } finally {
      isExporting.value = false;
    }
  }
}
