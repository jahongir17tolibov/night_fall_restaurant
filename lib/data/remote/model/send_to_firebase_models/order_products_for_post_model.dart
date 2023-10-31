import '../../../local/entities/orders_entity.dart';

class OrderProductsForPostModel {
  final String orderProductId;
  final String productName;
  final String price;
  final String weight;
  final String image;
  final String amount;

  OrderProductsForPostModel({
    required this.orderProductId,
    required this.productName,
    required this.price,
    required this.weight,
    required this.image,
    required this.amount,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'orderProductId': orderProductId,
        'productName': productName,
        'image': image,
        'price': price,
        'weight': weight,
        'amount': amount,
      };

  factory OrderProductsForPostModel.fromMap(Map<String, dynamic> map) =>
      OrderProductsForPostModel(
        orderProductId: map['orderProductId'],
        productName: map['productName'],
        image: map['image'],
        price: map['price'],
        weight: map['weight'],
        amount: map['amount'],
      );

  factory OrderProductsForPostModel.fromOrdersEntity(
          OrdersEntity ordersEntity) =>
      OrderProductsForPostModel(
        orderProductId: ordersEntity.orderProductId,
        productName: ordersEntity.name,
        price: ordersEntity.price,
        weight: ordersEntity.weight,
        image: ordersEntity.image,
        amount: ordersEntity.quantity.toString(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderProductsForPostModel &&
          runtimeType == other.runtimeType &&
          orderProductId == other.orderProductId &&
          productName == other.productName &&
          image == other.image &&
          price == other.price &&
          weight == other.weight &&
          amount == other.amount;

  @override
  int get hashCode =>
      orderProductId.hashCode ^
      productName.hashCode ^
      weight.hashCode ^
      image.hashCode ^
      price.hashCode ^
      amount.hashCode;
}
