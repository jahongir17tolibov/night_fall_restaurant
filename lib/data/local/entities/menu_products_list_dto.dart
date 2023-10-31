import 'package:night_fall_restaurant/data/remote/model/menu_list.dart';

class MenuProductsListDto {
  final int? id;
  final String name;
  final String image;
  final String price;
  final String weight;
  final String productCategoryId;
  final bool isAddedToOrder;

  MenuProductsListDto({
    this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.weight,
    required this.productCategoryId,
    this.isAddedToOrder = false,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'name': name,
        'image': image,
        'price': price,
        'weight': weight,
        'productCategoryId': productCategoryId,
        // 'isAddedToOrder': isAddedToOrder,
      };

  factory MenuProductsListDto.fromMap(Map<String, dynamic> map) =>
      MenuProductsListDto(
        id: map['id'],
        name: map['name'],
        image: map['image'],
        price: map['price'],
        weight: map['weight'],
        productCategoryId: map['productCategoryId'],
        // isAddedToOrder: map['isAddedToOrder'],
      );

  factory MenuProductsListDto.fromMenuProductsListResponse({
    required MenuList menuList,
  }) =>
      MenuProductsListDto(
        name: menuList.name,
        image: menuList.image,
        price: menuList.price,
        weight: menuList.weight,
        productCategoryId: menuList.product_category_id,
      );

  MenuProductsListDto copyWith({
    int? id,
    required String? name,
    required String? image,
    required String? price,
    required String? weight,
    required String? productCategoryId,
    required bool? isAddedToOrder,
  }) =>
      MenuProductsListDto(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        price: price ?? this.price,
        weight: weight ?? this.weight,
        productCategoryId: productCategoryId ?? this.productCategoryId,
        isAddedToOrder: isAddedToOrder ?? this.isAddedToOrder,
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
          isAddedToOrder == other.isAddedToOrder &&
          productCategoryId == other.productCategoryId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      image.hashCode ^
      price.hashCode ^
      weight.hashCode ^
      productCategoryId.hashCode ^
      isAddedToOrder.hashCode;
}
