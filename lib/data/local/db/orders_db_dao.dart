import 'package:night_fall_restaurant/data/local/db/database_service.dart';
import 'package:night_fall_restaurant/data/local/entities/orders_entity.dart';
import 'package:night_fall_restaurant/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class OrdersDao {
  final DataBaseService myDatabase;

  OrdersDao(this.myDatabase);

  static const String tableName = ordersTableName;

  Future<void> insertProductToOrders(OrdersEntity ordersEntity) async {
    final database = await myDatabase.getDb();
    try {
      await database.insert(
        tableName,
        ordersEntity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> deleteProductFromOrders(String orderProductId) async {
    final database = await myDatabase.getDb();
    try {
      await database.rawDelete(
        "DELETE FROM $tableName WHERE orderProductId = ?",
        [orderProductId],
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<List<OrdersEntity>> getProductsFromOrders() async {
    final database = await myDatabase.getDb();
    try {
      final List<Map<String, dynamic>> query = await database.query(tableName);
      return query.map((e) => OrdersEntity.fromMap(e)).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<OrdersEntity> getSingleOrderProduct(int orderId) async {
    final database = await myDatabase.getDb();
    try {
      final List<Map<String, dynamic>> query = await database.rawQuery(
        "SELECT * FROM $tableName where id = $orderId",
      );
      if (query.isNotEmpty) {
        return OrdersEntity.fromMap(query.first);
      } else {
        throw Exception('orders data is Empty');
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<String?> getSingleOrdersProductId(String orderProductId) async {
    final database = await myDatabase.getDb();
    const String getIdSqlQuery =
        "SELECT orderProductId FROM $tableName WHERE orderProductId = ?";
    try {
      final List<Map<String, dynamic>> query =
          await database.rawQuery(getIdSqlQuery, [orderProductId]);
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
    final database = await myDatabase.getDb();
    try {
      await database.rawDelete("DELETE FROM $tableName");
    } catch (_) {
      rethrow;
    }
  }
}
