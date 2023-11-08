import 'package:night_fall_restaurant/data/remote/model/tables_password_response.dart';
import 'package:night_fall_restaurant/data/remote/model/send_to_firebase_models/order_products_for_post_model.dart';
import 'package:night_fall_restaurant/data/remote/model/send_to_firebase_models/send_orders_model.dart';
import '../model/get_menu_list_response.dart';

abstract class FireStoreService {
  Future<GetMenuListResponse> getMenuList();

  Future<List<TablesPasswordResponse>> getTablePasswords();

  Future<void> sendOrders(SendOrdersModel sendOrdersModel);
}
