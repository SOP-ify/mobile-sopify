/// A single procedure step inside a generated/saved SOP
/// (matches the backend `StepItem`).
class SopStep {
  final int no;
  final String judul;
  final String deskripsi;
  final String? pic;
  final String? durasi;

  const SopStep({
    required this.no,
    required this.judul,
    required this.deskripsi,
    this.pic,
    this.durasi,
  });

  factory SopStep.fromJson(Map<String, dynamic> json) {
    return SopStep(
      no: (json['no'] is num) ? (json['no'] as num).toInt() : 0,
      judul: (json['judul'] ?? '').toString(),
      deskripsi: (json['deskripsi'] ?? '').toString(),
      pic: json['pic']?.toString(),
      durasi: json['durasi']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'no': no,
        'judul': judul,
        'deskripsi': deskripsi,
        'pic': pic,
        'durasi': durasi,
      };
}
