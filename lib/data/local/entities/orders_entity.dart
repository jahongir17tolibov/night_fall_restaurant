class OrdersEntity {
  final int? id;
  final String productCategoryId;
  final String name;
  final String image;
  final String price;
  int quantity;

  OrdersEntity({
    this.id,
    required this.productCategoryId,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'productCategoryId': productCategoryId,
        'name': name,
        'image': image,
        'price': price,
        'quantity': quantity,
      };

  factory OrdersEntity.fromMap(Map<String, dynamic> map) => OrdersEntity(
        id: map['id'],
        productCategoryId: map['productCategoryId'],
        name: map['name'],
        image: map['image'],
        price: map['price'],
        quantity: map['quantity'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          image == other.image &&
          price == other.price &&
          productCategoryId == other.productCategoryId &&
          quantity == other.quantity;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      image.hashCode ^
      price.hashCode ^
      productCategoryId.hashCode ^
      quantity.hashCode;
}
