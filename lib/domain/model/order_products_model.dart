import 'package:flutter/material.dart';
import 'package:night_fall_restaurant/data/local/entities/orders_entity.dart';

class OrderProductsModel extends ChangeNotifier {
  final int? id;
  final String productCategoryId;
  final String name;
  final String image;
  final String price;
  final String weight;
  int _quantity;

  int get quantity => _quantity;

  OrderProductsModel({
    this.id,
    required this.productCategoryId,
    required this.name,
    required this.image,
    required this.price,
    required this.weight,
    required int quantity,
  }) : _quantity = quantity;

  void increase() {
    int newQuantity = _quantity + 1;
    if (newQuantity <= 10) {
      _quantity = newQuantity;
      notifyListeners();
    } else {
      throw Exception('no more than 10 items can be ordered');
    }
  }

  void decrease() {
    int newQuantity = _quantity - 1;
    if (newQuantity >= 0) {
      _quantity = newQuantity;
      notifyListeners();
    }
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'productCategoryId': productCategoryId,
        'name': name,
        'image': image,
        'price': price,
        'weight': weight,
        'quantity': _quantity,
      };

  factory OrderProductsModel.fromMap(Map<String, dynamic> map) =>
      OrderProductsModel(
        id: map['id'],
        productCategoryId: map['productCategoryId'],
        name: map['name'],
        image: map['image'],
        price: map['price'],
        weight: map['weight'],
        quantity: map['quantity'],
      );

  factory OrderProductsModel.fromOrdersEntity(OrdersEntity ordersEntity) =>
      OrderProductsModel(
        productCategoryId: ordersEntity.productCategoryId,
        name: ordersEntity.name,
        image: ordersEntity.image,
        price: ordersEntity.price,
        weight: ordersEntity.weight,
        quantity: 1,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderProductsModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productCategoryId == other.productCategoryId &&
          name == other.name &&
          image == other.image &&
          price == other.price &&
          weight == other.weight &&
          _quantity == other._quantity;

  @override
  int get hashCode =>
      id.hashCode ^
      productCategoryId.hashCode ^
      name.hashCode ^
      image.hashCode ^
      price.hashCode ^
      weight.hashCode ^
      _quantity.hashCode;
}
