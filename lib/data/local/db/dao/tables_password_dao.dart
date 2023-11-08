import 'package:sqflite/sqflite.dart';

import '../../entities/table_passwords_entity.dart';

class TablesPasswordDao {
  final Database database;

  TablesPasswordDao(this.database);

  Future<void> insertTablesPassword(TablePasswordsEntity tablesPassword) async {
    try {
      await database.insert(
        TablePasswordsEntity.TABLE_NAME,
        tablesPassword.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<List<TablePasswordsEntity>> getCachedTablesPassword() async {
    String sqlQuery = """
    SELECT * FROM ${TablePasswordsEntity.TABLE_NAME} ORDER BY ${TablePasswordsEntity.CM_TABLE_NUMBER} ASC
    """;
    try {
      final List<Map<String, dynamic>> query =
          await database.rawQuery(sqlQuery);
      return query.map((e) => TablePasswordsEntity.fromMap(e)).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateTablePasswords(TablePasswordsEntity tablesPassword) async {
    try {
      String updateQuery = """
      UPDATE ${TablePasswordsEntity.TABLE_NAME} 
         SET ${TablePasswordsEntity.CM_TABLE_NUMBER} = '${tablesPassword.tableNumber}',
             ${TablePasswordsEntity.CM_TABLE_PASSWORD} = '${tablesPassword.tablePassword}'
       WHERE ${TablePasswordsEntity.CM_TABLE_NUMBER} = '${tablesPassword.tableNumber}'
      """;
      await database.rawQuery(updateQuery);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> clearAllTablePasswords() async {
    try {
      String sqlQuery = """
    DELETE FROM ${TablePasswordsEntity.TABLE_NAME}
    """;
      await database.rawDelete(sqlQuery);
    } catch (_) {
      rethrow;
    }
  }
}
