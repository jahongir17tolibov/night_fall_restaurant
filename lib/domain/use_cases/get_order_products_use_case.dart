import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/local/db/dao/orders_db_dao.dart';
import 'package:night_fall_restaurant/data/local/entities/orders_entity.dart';

@immutable
class GetOrderProductsUseCase {
  final OrdersDao ordersDao;

  const GetOrderProductsUseCase(this.ordersDao);

  Future<List<OrdersEntity>> call() async => ordersDao.getProductsFromOrders();
}
