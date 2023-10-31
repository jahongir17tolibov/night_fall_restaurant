import 'package:night_fall_restaurant/data/local/entities/menu_products_list_dto.dart';

class OrdersEntity {
  final int? id;
  final String productCategoryId;
  final String orderProductId;
  final String name;
  final String image;
  final String price;
  final String weight;
  int quantity;

  OrdersEntity({
    this.id,
    required this.productCategoryId,
    required this.orderProductId,
    required this.name,
    required this.image,
    required this.price,
    required this.weight,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'productCategoryId': productCategoryId,
        'orderProductId': orderProductId,
        'name': name,
        'image': image,
        'price': price,
        'weight': weight,
        'quantity': quantity,
      };

  factory OrdersEntity.fromMap(Map<String, dynamic> map) => OrdersEntity(
        id: map['id'],
        productCategoryId: map['productCategoryId'],
        orderProductId: map['orderProductId'],
        name: map['name'],
        image: map['image'],
        price: map['price'],
        weight: map['weight'],
        quantity: map['quantity'],
      );

  factory OrdersEntity.fromMenuProductsListDto({
    required MenuProductsListDto menuProductsList,
  }) =>
      OrdersEntity(
        productCategoryId: menuProductsList.productCategoryId,
        orderProductId: menuProductsList.id.toString(),
        name: menuProductsList.name,
        image: menuProductsList.image,
        price: menuProductsList.price,
        weight: menuProductsList.weight,
        quantity: 1,
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
          weight == other.weight &&
          quantity == other.quantity;

  @override
  int get hashCode =>
      id.hashCode ^
      orderProductId.hashCode ^
      productCategoryId.hashCode ^
      name.hashCode ^
      image.hashCode ^
      price.hashCode ^
      weight.hashCode ^
      quantity.hashCode;
}
