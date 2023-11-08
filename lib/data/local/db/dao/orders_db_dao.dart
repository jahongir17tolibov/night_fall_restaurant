import 'package:night_fall_restaurant/data/local/entities/orders_entity.dart';
import 'package:sqflite/sqflite.dart';

class OrdersDao {
  final Database database;

  OrdersDao(this.database);

  Future<void> insertProductToOrders(OrdersEntity ordersEntity) async {
    try {
      await database.insert(
        OrdersEntity.TABLE_NAME,
        ordersEntity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> deleteProductFromOrders(String orderProductId) async {
    try {
      String sqlQuery = """
      DELETE FROM ${OrdersEntity.TABLE_NAME} WHERE ${OrdersEntity.CM_ORDER_PRODUCT_ID} = '$orderProductId'
      """;
      await database.rawDelete(sqlQuery);
    } catch (_) {
      rethrow;
    }
  }

  Future<List<OrdersEntity>> getProductsFromOrders() async {
    try {
      String sqlQuery = """
      SELECT * FROM ${OrdersEntity.TABLE_NAME} ORDER BY ${OrdersEntity.CM_ID} ASC
      """;
      final List<Map<String, dynamic>> query =
          await database.rawQuery(sqlQuery);
      return query.map((e) => OrdersEntity.fromMap(e)).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<OrdersEntity> getSingleOrderProduct(int orderId) async {
    try {
      String sqlQuery = """
      SELECT * FROM ${OrdersEntity.TABLE_NAME} WHERE ${OrdersEntity.CM_ID} = '$orderId'
      """;
      final List<Map<String, dynamic>> query =
          await database.rawQuery(sqlQuery);
      if (query.isNotEmpty) {
        return OrdersEntity.fromMap(query.first);
      } else {
        throw Exception('Orders data is Empty');
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<String?> getSingleOrderProductId(String orderProductId) async {
    try {
      String sqlQuery = """
          SELECT '$orderProductId' FROM ${OrdersEntity.TABLE_NAME} WHERE ${OrdersEntity.CM_ORDER_PRODUCT_ID} = '$OrdersEntity'
          """;
      final List<Map<String, dynamic>> query =
          await database.rawQuery(sqlQuery);
      if (query.isNotEmpty) {
        return query.first['orderProductId'];
      } else {
        return null;
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> clearAllProductsFromOrders() async {
    try {
      String sqlQuery = """
      DELETE FROM ${OrdersEntity.TABLE_NAME}
      """;
      await database.rawDelete(sqlQuery);
    } catch (_) {
      rethrow;
    }
  }
}
