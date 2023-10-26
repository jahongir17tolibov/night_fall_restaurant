import 'package:night_fall_restaurant/data/local/db/orders_db_dao.dart';
import 'package:night_fall_restaurant/data/local/entities/orders_entity.dart';
import 'package:night_fall_restaurant/domain/repository/orders_repository/ordres_repository.dart';

class OrdersRepositoryImpl extends OrdersRepository {
  final OrdersDao dao;

  OrdersRepositoryImpl({required this.dao});

  @override
  Future<void> clearAllProductsFromOrdersDb() async =>
      await dao.clearAllProductsFromOrders();

  @override
  Future<void> deleteProductFromOrderDb(int productId) async =>
      await dao.deleteProductFromOrders(productId);

  @override
  Future<List<OrdersEntity>> getProductsFromOrdersDb() async =>
      await dao.getProductsFromOrders();

  @override
  Future<void> insertProductToOrdersDb(OrdersEntity ordersEntity) async =>
      await dao.insertProductToOrders(ordersEntity);
}
