// ignore_for_file: non_constant_identifier_names
class Categories {
  final String category_id;
  final String category_name;

  Categories({required this.category_id, required this.category_name});

  Map<String, dynamic> toMap() => <String, dynamic>{
        'category_id': category_id,
        'category_name': category_name,
      };

  factory Categories.fromMap(Map<String, dynamic> map) => Categories(
      category_id: map['category_id'], category_name: map['category_name']);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Categories &&
          runtimeType == other.runtimeType &&
          category_id == other.category_id &&
          category_name == other.category_name;

  @override
  int get hashCode => category_id.hashCode ^ category_name.hashCode;
}
