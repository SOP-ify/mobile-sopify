/// A business field (bidang usaha) the AI has an SOP dataset for.
///
/// [label] is shown in the UI; [value] is sent as `kategori` to the API.
class SopCategory {
  final String label;
  final String value;

  const SopCategory(this.label, this.value);
}

/// The 11 supported UMKM business fields that have an SOP dataset.
const List<SopCategory> kSopCategories = [
  SopCategory('Food & Beverages', 'FnB'),
  SopCategory('Retail', 'retail'),
  SopCategory('Konveksi', 'konveksi'),
  SopCategory('Kreatif', 'kreatif'),
  SopCategory('Pendidikan', 'pendidikan'),
  SopCategory('Jasa Teknik', 'jasa teknik'),
  SopCategory('Jasa Perawatan', 'jasa perawatan'),
  SopCategory('Agribisnis', 'agribisnis'),
  SopCategory('Otomotif', 'otomotif'),
  SopCategory('Properti', 'properti'),
  SopCategory('Kesehatan', 'kesehatan'),
];
