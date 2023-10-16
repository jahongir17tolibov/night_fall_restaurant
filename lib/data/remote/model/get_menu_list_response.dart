// ignore_for_file: non_constant_identifier_names
import 'categories.dart';
import 'menu_list.dart';

class GetMenuListResponse {
  final List<Categories> menu_categories;
  final List<MenuList> menu_products;

  GetMenuListResponse({
    required this.menu_categories,
    required this.menu_products,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'menu_categories': menu_categories,
        'menu_products': menu_products,
      };

  factory GetMenuListResponse.fromMap(Map<String, dynamic> map) =>
      GetMenuListResponse(
        menu_categories: map['menu_categories'],
        menu_products: map['menu_products'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetMenuListResponse &&
          runtimeType == other.runtimeType &&
          menu_categories == other.menu_categories &&
          menu_products == other.menu_products;

  @override
  int get hashCode => menu_categories.hashCode ^ menu_products.hashCode;
}
