class MenuList {
  final String name;
  final String image;
  final String price;
  final String weight;

  // ignore: non_constant_identifier_names
  final String product_category_id;

  MenuList(
      this.name, this.image, this.price, this.weight, this.product_category_id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuList &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          image == other.image &&
          price == other.price &&
          weight == other.weight &&
          product_category_id == other.product_category_id;

  @override
  int get hashCode =>
      name.hashCode ^
      image.hashCode ^
      price.hashCode ^
      weight.hashCode ^
      product_category_id.hashCode;
}
