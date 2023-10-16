// ignore_for_file: non_constant_identifier_names
class Categories {
  final String category_id;
  final String category_name;

  Categories(this.category_id, this.category_name);

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
