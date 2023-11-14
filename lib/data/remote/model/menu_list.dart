// ignore_for_file: non_constant_identifier_names

class MenuList {
  final String name;
  final String fireId;
  final String image;
  final String price;
  final String weight;
  final String product_category_id;

  MenuList({
    required this.name,
    required this.fireId,
    required this.image,
    required this.price,
    required this.weight,
    required this.product_category_id,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'fireId': fireId,
        'image': image,
        'price': price,
        'weight': weight,
        'product_category_id': product_category_id,
      };

  factory MenuList.fromMap(Map<String, dynamic> map) => MenuList(
        name: map['name'],
        fireId: map['fireId'],
        image: map['image'],
        price: map['price'],
        weight: map['weight'],
        product_category_id: map['product_category_id'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuList &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          fireId == other.fireId &&
          image == other.image &&
          price == other.price &&
          weight == other.weight &&
          product_category_id == other.product_category_id;

  @override
  int get hashCode =>
      name.hashCode ^
      fireId.hashCode ^
      image.hashCode ^
      price.hashCode ^
      weight.hashCode ^
      product_category_id.hashCode;
}
