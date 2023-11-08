// ignore_for_file: constant_identifier_names

import 'package:night_fall_restaurant/data/local/entities/menu_products_list_entity.dart';

class OrdersEntity {
  static const CM_ID = "orders_entity_id";
  static const CM_PRODUCT_CATEGORY_ID = "product_category_id";
  static const CM_ORDER_PRODUCT_ID = "order_product_id";
  static const CM_ORDER_NAME = "order_name";
  static const CM_IMAGE = "order_image";
  static const CM_PRICE = "order_price";
  static const CM_WEIGHT = "order_weight";
  static const TABLE_NAME = "orders_entity";

  final int? id;
  final String productCategoryId;
  final String orderProductId;
  final String name;
  final String image;
  final String price;
  final String weight;

  OrdersEntity({
    this.id,
    required this.productCategoryId,
    required this.orderProductId,
    required this.name,
    required this.image,
    required this.price,
    required this.weight,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        CM_ID: id,
        CM_PRODUCT_CATEGORY_ID: productCategoryId,
        CM_ORDER_PRODUCT_ID: orderProductId,
        CM_ORDER_NAME: name,
        CM_IMAGE: image,
        CM_PRICE: price,
        CM_WEIGHT: weight,
      };

  factory OrdersEntity.fromMap(Map<String, dynamic> map) => OrdersEntity(
        id: map[CM_ID],
        productCategoryId: map[CM_PRODUCT_CATEGORY_ID],
        orderProductId: map[CM_ORDER_PRODUCT_ID],
        name: map[CM_ORDER_NAME],
        image: map[CM_IMAGE],
        price: map[CM_PRICE],
        weight: map[CM_WEIGHT],
      );

  factory OrdersEntity.fromMenuProductsListDto({
    required MenuProductsEntity menuProductsList,
  }) =>
      OrdersEntity(
        productCategoryId: menuProductsList.productCategoryId,
        orderProductId: menuProductsList.id.toString(),
        name: menuProductsList.name,
        image: menuProductsList.image,
        price: menuProductsList.price,
        weight: menuProductsList.weight,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          orderProductId == other.orderProductId &&
          productCategoryId == other.productCategoryId &&
          name == other.name &&
          image == other.image &&
          price == other.price &&
          weight == other.weight;

  @override
  int get hashCode =>
      id.hashCode ^
      orderProductId.hashCode ^
      productCategoryId.hashCode ^
      name.hashCode ^
      image.hashCode ^
      price.hashCode ^
      weight.hashCode;
}
