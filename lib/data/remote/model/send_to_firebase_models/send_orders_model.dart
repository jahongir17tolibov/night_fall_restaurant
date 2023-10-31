import 'order_products_for_post_model.dart';

class SendOrdersModel {
  final String orderId;
  final String tableNumber;
  final String sendTime;
  final String totalPrice;
  final List<OrderProductsForPostModel> orderProducts;

  SendOrdersModel({
    required this.orderId,
    required this.tableNumber,
    required this.sendTime,
    required this.totalPrice,
    required this.orderProducts,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'orderId': orderId,
        'tableNumber': tableNumber,
        'sendTime': sendTime,
        'totalPrice': totalPrice,
        'orderProducts':
            orderProducts.map((product) => product.toMap()).toList(),
      };

  factory SendOrdersModel.fromMap(Map<String, dynamic> map) {
    List<dynamic> orderProductsData = map['orderProducts'];

    List<OrderProductsForPostModel> orderProductsList = orderProductsData
        .map((products) => OrderProductsForPostModel.fromMap(products))
        .toList();

    return SendOrdersModel(
      orderId: map['orderId'],
      tableNumber: map['tableNumber'],
      sendTime: map['sendTime'],
      totalPrice: map['totalPrice'],
      orderProducts: orderProductsList,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SendOrdersModel &&
          runtimeType == other.runtimeType &&
          orderId == other.orderId &&
          tableNumber == other.tableNumber &&
          sendTime == other.sendTime &&
          totalPrice == other.totalPrice &&
          orderProducts == other.orderProducts;

  @override
  int get hashCode =>
      orderId.hashCode ^
      tableNumber.hashCode ^
      sendTime.hashCode ^
      totalPrice.hashCode ^
      orderProducts.hashCode;
}
