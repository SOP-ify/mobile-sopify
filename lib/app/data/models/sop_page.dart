import 'sop_model.dart';

/// A paginated page of SOPs from `GET /api/v1/sop`
/// (`data` = `{ items, total, page, limit, has_next }`).
class SopPage {
  final List<SopModel> items;
  final int total;
  final int page;
  final int limit;
  final bool hasNext;

  const SopPage({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasNext,
  });

  factory SopPage.fromJson(Map<String, dynamic> json) {
    final dynamic raw = json['items'];
    final items = raw is List
        ? raw
            .whereType<Map>()
            .map((e) => SopModel.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <SopModel>[];
    return SopPage(
      items: items,
      total: (json['total'] as num?)?.toInt() ?? items.length,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? items.length,
      hasNext: json['has_next'] == true,
    );
  }
}
