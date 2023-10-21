import 'package:night_fall_restaurant/data/local/database_service.dart';
import 'package:night_fall_restaurant/data/local/models/menu_products_list_dto.dart';
import 'package:night_fall_restaurant/data/local/models/tables_password_dto.dart';
import 'package:sqflite/sqflite.dart';

import '../../utils/constants.dart';

 class DataBaseDao {
  final DataBaseService myDatabase;

  DataBaseDao({required this.myDatabase});

  Future<void> insertMenuProductsList(MenuProductsListDto menuList) async =>
      await insertToDatabaseHelper(
        menuProductsTableName,
        menuList.toMap(),
      );

  Future<void> insertTablesPassword(TablesPasswordDto tablesPassword) async =>
      await insertToDatabaseHelper(
        tablesPasswordsTableName,
        tablesPassword.toMap(),
      );

  Future<List<MenuProductsListDto>> getCachedMenuList() async {
    final List<Map<String, dynamic>> query = await getFromDatabaseHelper(
      tableName: menuProductsTableName,
      orderBy: 'id ASC',
    );
    return query.map((e) => MenuProductsListDto.fromMap(e)).toList();
  }

  Future<List<TablesPasswordDto>> getCachedTablesPassword() async {
    final List<Map<String, dynamic>> query = await getFromDatabaseHelper(
      tableName: tablesPasswordsTableName,
      orderBy: 'tableNumber ASC',
    );
    return query.map((e) => TablesPasswordDto.fromMap(e)).toList();
  }

  Future<void> updateMenuProductsList(MenuProductsListDto menuList) async =>
      updateTableFromDataBaseHelper(
        tableName: menuProductsTableName,
        dataValues: menuList.toMap(),
        whereArguments: [menuList.id],
      );

  Future<void> updateTablesPassword(TablesPasswordDto tablesPasswords) async =>
      updateTableFromDataBaseHelper(
        tableName: tablesPasswordsTableName,
        dataValues: tablesPasswords.toMap(),
        whereArguments: [tablesPasswords.id],
      );

  // helper for insert data to database
  Future<void> insertToDatabaseHelper(
    String tableName,
    Map<String, dynamic> dataValues,
  ) async {
    final database = await myDatabase.getDb();
    try {
      await database.insert(
        tableName,
        dataValues,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      rethrow;
    }
  }

  // helper for get data from database
  Future<List<Map<String, dynamic>>> getFromDatabaseHelper({
    required String tableName,
    required String orderBy,
  }) async {
    final database = await myDatabase.getDb();
    try {
      return await database.query(tableName, orderBy: orderBy);
    } catch (_) {
      rethrow;
    }
  }

  // helper for update data in database
  Future<void> updateTableFromDataBaseHelper({
    required String tableName,
    required Map<String, dynamic> dataValues,
    required List<dynamic> whereArguments,
  }) async {
    final database = await myDatabase.getDb();
    try {
      await database.update(
        tableName,
        dataValues,
        where: 'id = ?',
        whereArgs: whereArguments,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      rethrow;
    }
  }
}
