
class PagingModel {
  final int page;
  final int pageSize;
  final bool hasNext;

  PagingModel({
    required this.page,
    required this.pageSize,
    required this.hasNext,
  });

  factory PagingModel.fromJson(Map<String, dynamic> json) {
    return PagingModel(
      page: _toInt(json['page']) ?? 0,
      pageSize: _toInt(json['page_size']) ?? 10,
      hasNext: json['has_next'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'page_size': pageSize,
    'has_next': hasNext,
  };
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
