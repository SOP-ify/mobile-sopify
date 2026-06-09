/// Body for `POST /api/v1/ml/text-to-sop`.
///
/// [style] is fixed to `fine_tune` for this app's text-to-SOP flow.
class TextToSopRequest {
  final String sopName;
  final String kategori;
  final String catatan;
  final String style;
  final int maxNewTokens;
  final double temperature;

  const TextToSopRequest({
    required this.sopName,
    required this.kategori,
    required this.catatan,
    this.style = 'fine_tune',
    this.maxNewTokens = 512,
    this.temperature = 0.7,
  });

  Map<String, dynamic> toJson() => {
        'sop_name': sopName,
        'kategori': kategori,
        'catatan': catatan,
        'style': style,
        'max_new_tokens': maxNewTokens,
        'temperature': temperature,
      };
}
