import 'package:night_fall_restaurant/data/remote/model/categories.dart';

class MenuCategoriesDto {
  final int? id;
  final String categoryName;
  final String categoryId;

  MenuCategoriesDto({
    this.id,
    required this.categoryName,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'categoryName': categoryName,
        'categoryId': categoryId,
      };

  factory MenuCategoriesDto.fromMap(Map<String, dynamic> map) =>
      MenuCategoriesDto(
        id: map['id'],
        categoryName: map['categoryName'],
        categoryId: map['categoryId'],
      );

  factory MenuCategoriesDto.fromMenuProductsListResponse({
    required Categories categories,
  }) =>
      MenuCategoriesDto(
        categoryName: categories.category_name,
        categoryId: categories.category_id,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuCategoriesDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          categoryName == other.categoryName &&
          categoryId == other.categoryId;

  @override
  int get hashCode => id.hashCode ^ categoryName.hashCode ^ categoryId.hashCode;
}
