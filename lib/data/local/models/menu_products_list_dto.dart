class MenuProductsListDto {
  final int? id;
  final String name;
  final String image;
  final String price;
  final String weight;
  final String productCategoryId;

  MenuProductsListDto({
    this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.weight,
    required this.productCategoryId,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'name': name,
        'image': image,
        'price': price,
        'weight': weight,
        'productCategoryId': productCategoryId,
      };

  factory MenuProductsListDto.fromMap(Map<String, dynamic> map) =>
      MenuProductsListDto(
        id: map['id'],
        name: map['name'],
        image: map['image'],
        price: map['price'],
        weight: map['weight'],
        productCategoryId: map['productCategoryId'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuProductsListDto &&
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
