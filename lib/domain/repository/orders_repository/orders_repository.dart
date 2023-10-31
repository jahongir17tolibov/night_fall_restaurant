import 'package:night_fall_restaurant/core/result/result_handle.dart';

import '../../../data/local/entities/orders_entity.dart';
import '../../../data/remote/model/send_to_firebase_models/send_orders_model.dart';

abstract class OrdersRepository {
  Future<Result<List<OrdersEntity>>> getProductsFromOrdersDb();

  Future<OrdersEntity> getSingleOrderFromDb(int orderId);

  Future<String?> getSingleOrdersProductId(String orderProductId);

  Future<void> insertProductToOrdersDb(OrdersEntity ordersEntity);

  Future<void> deleteProductFromOrderDb(String orderProductId);

  Future<void> clearAllProductsFromOrdersDb();

  Future<void> sendOrdersToFireStore(SendOrdersModel sendOrdersModel);
}
