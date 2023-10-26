import '../../../data/local/entities/orders_entity.dart';

abstract class OrdersRepository {
  Future<List<OrdersEntity>> getProductsFromOrdersDb();

  Future<void> insertProductToOrdersDb(OrdersEntity ordersEntity);

  Future<void> deleteProductFromOrderDb(int productId);

  Future<void> clearAllProductsFromOrdersDb();
}
