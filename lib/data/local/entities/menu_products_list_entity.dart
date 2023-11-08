// ignore_for_file: constant_identifier_names

import 'package:night_fall_restaurant/data/remote/model/menu_list.dart';

class MenuProductsEntity {
  static const CM_ID = "menu_products_id";
  static const CM_PRODUCT_NAME = "product_name";
  static const CM_IMAGE = "product_image";
  static const CM_PRICE = "product_price";
  static const CM_WEIGHT = "product_weight";
  static const CM_PRODUCT_CATEGORY_ID = "product_category_id";
  static const TABLE_NAME = 'menu_products_entity';

  final int? id;
  final String name;
  final String image;
  final String price;
  final String weight;
  final String productCategoryId;

  MenuProductsEntity({
    this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.weight,
    required this.productCategoryId,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        CM_ID: id,
        CM_PRODUCT_NAME: name,
        CM_IMAGE: image,
        CM_PRICE: price,
        CM_WEIGHT: weight,
        CM_PRODUCT_CATEGORY_ID: productCategoryId,
      };

  factory MenuProductsEntity.fromMap(Map<String, dynamic> map) =>
      MenuProductsEntity(
        id: map[CM_ID],
        name: map[CM_PRODUCT_NAME],
        image: map[CM_IMAGE],
        price: map[CM_PRICE],
        weight: map[CM_WEIGHT],
        productCategoryId: map[CM_PRODUCT_CATEGORY_ID],
      );

  factory MenuProductsEntity.fromMenuProductsListResponse({
    required MenuList menuList,
  }) =>
      MenuProductsEntity(
        name: menuList.name,
        image: menuList.image,
        price: menuList.price,
        weight: menuList.weight,
        productCategoryId: menuList.product_category_id,
      );

  MenuProductsEntity copyWith({
    int? id,
    required String? name,
    required String? image,
    required String? price,
    required String? weight,
    required String? productCategoryId,
  }) =>
      MenuProductsEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        price: price ?? this.price,
        weight: weight ?? this.weight,
        productCategoryId: productCategoryId ?? this.productCategoryId,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuProductsEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          image == other.image &&
          price == other.price &&
          weight == other.weight &&
          productCategoryId == other.productCategoryId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      image.hashCode ^
      price.hashCode ^
      weight.hashCode ^
      productCategoryId.hashCode;
}
