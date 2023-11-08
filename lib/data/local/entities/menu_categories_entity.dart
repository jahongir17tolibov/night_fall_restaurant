// ignore_for_file: constant_identifier_names

import 'package:night_fall_restaurant/data/remote/model/categories.dart';

class MenuCategoriesEntity {
  static const CM_ID = "menu_categories_id";
  static const CM_CATEGORY_NAME = "category_name";
  static const CM_CATEGORY_ID = "category_id";
  static const TABLE_NAME = "categories_entity";

  final int? id;
  final String categoryName;
  final String categoryId;

  MenuCategoriesEntity({
    this.id,
    required this.categoryName,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        CM_ID: id,
        CM_CATEGORY_NAME: categoryName,
        CM_CATEGORY_ID: categoryId,
      };

  factory MenuCategoriesEntity.fromMap(Map<String, dynamic> map) =>
      MenuCategoriesEntity(
        id: map[CM_ID],
        categoryName: map[CM_CATEGORY_NAME],
        categoryId: map[CM_CATEGORY_ID],
      );

  factory MenuCategoriesEntity.fromMenuProductsListResponse({
    required Categories categories,
  }) =>
      MenuCategoriesEntity(
        categoryName: categories.category_name,
        categoryId: categories.category_id,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuCategoriesEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          categoryName == other.categoryName &&
          categoryId == other.categoryId;

  @override
  int get hashCode => id.hashCode ^ categoryName.hashCode ^ categoryId.hashCode;
}
