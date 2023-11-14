import 'package:night_fall_restaurant/domain/model/order_products_model.dart';

class OrderProductsForPostModel {
  final String orderId;
  final String productName;
  final String fireId;
  final String price;
  final String weight;
  final String image;
  final String amount;

  OrderProductsForPostModel({
    required this.orderId,
    required this.productName,
    required this.fireId,
    required this.price,
    required this.weight,
    required this.image,
    required this.amount,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'orderId': orderId,
        'productName': productName,
        'fireId': fireId,
        'image': image,
        'price': price,
        'weight': weight,
        'amount': amount,
      };

  factory OrderProductsForPostModel.fromMap(Map<String, dynamic> map) =>
      OrderProductsForPostModel(
        orderId: map['orderId'],
        productName: map['productName'],
        fireId: map['fireId'],
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
        fireId: orderProductsModel.fireId,
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
          fireId == other.fireId &&
          image == other.image &&
          price == other.price &&
          weight == other.weight &&
          amount == other.amount;

  @override
  int get hashCode =>
      orderId.hashCode ^
      productName.hashCode ^
      fireId.hashCode ^
      weight.hashCode ^
      image.hashCode ^
      price.hashCode ^
      amount.hashCode;
}
