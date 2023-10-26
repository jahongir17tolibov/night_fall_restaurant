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

  Future<void> deleteProductFromOrders(int productId) async {
    final database = await myDatabase.getDb();
    try {
      await database.rawDelete(
        "DELETE FROM $tableName WHERE id = '$productId'",
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

  Future<void> clearAllProductsFromOrders() async {
    final database = await myDatabase.getDb();
    try {
      await database.rawDelete("DELETE FROM $tableName");
    } catch (_) {
      rethrow;
    }
  }
}
