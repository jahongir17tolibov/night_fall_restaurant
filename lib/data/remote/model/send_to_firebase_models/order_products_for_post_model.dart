import 'package:night_fall_restaurant/domain/model/order_products_model.dart';

class OrderProductsForPostModel {
  final String orderId;
  final String productName;
  final String price;
  final String weight;
  final String image;
  final String amount;

  OrderProductsForPostModel({
    required this.orderId,
    required this.productName,
    required this.price,
    required this.weight,
    required this.image,
    required this.amount,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'orderId': orderId,
        'productName': productName,
        'image': image,
        'price': price,
        'weight': weight,
        'amount': amount,
      };

  factory OrderProductsForPostModel.fromMap(Map<String, dynamic> map) =>
      OrderProductsForPostModel(
        orderId: map['orderId'],
        productName: map['productName'],
        image: map['image'],
        price: map['price'],
        weight: map['weight'],
        amount: map['amount'],
      );

  factory OrderProductsForPostModel.fromOrderProductsModel({
    required String orderUniqueId,
    required OrderProductsModel orderProductsModel,
  }) =>
      OrderProductsForPostModel(
        orderId: orderUniqueId,
        productName: orderProductsModel.name,
        price: orderProductsModel.price,
        weight: orderProductsModel.weight,
        image: orderProductsModel.image,
        amount: orderProductsModel.quantity.toString(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderProductsForPostModel &&
          runtimeType == other.runtimeType &&
          orderId == other.orderId &&
          productName == other.productName &&
          image == other.image &&
          price == other.price &&
          weight == other.weight &&
          amount == other.amount;

  @override
  int get hashCode =>
      orderId.hashCode ^
      productName.hashCode ^
      weight.hashCode ^
      image.hashCode ^
      price.hashCode ^
      amount.hashCode;
}
