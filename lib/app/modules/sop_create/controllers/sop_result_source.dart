import 'package:get/get.dart';

import '../../../data/models/generated_sop.dart';

/// Shared contract consumed by the result stage (`SopResult`) so both the
/// text and voice flows can drive the same widget.
abstract class SopResultSource {
  /// The generated SOP to render (null until generation finishes).
  Rxn<GeneratedSop> get result;

  /// True while a save request is in flight.
  RxBool get isSaving;

  /// The selected business-field value (wire token, e.g. `FnB`).
  RxString get selectedKategori;

  /// The trimmed SOP name entered by the user.
  String get sopName;

  /// Persists the generated SOP to history, then surfaces the saved dialog.
  Future<void> save();
}
