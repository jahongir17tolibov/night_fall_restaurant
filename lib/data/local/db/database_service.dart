import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../../../utils/constants.dart';

class DataBaseService {
  static DataBaseService getInstance = DataBaseService._init();

  static const String _dataBaseName = 'night_fall.db';
  sql.Database? _database;

  DataBaseService._init();

  Future<sql.Database> getDb() async {
    _database ??= await getDatabaseInstance(dataBaseName: _dataBaseName);
    return _database!;
  }

  Future<sql.Database> getDatabaseInstance({
    required String dataBaseName,
  }) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _dataBaseName);
    return await sql.openDatabase(path, version: 1,
        onCreate: (sql.Database db, int version) async {
      await createMenuCategoriesTable(db); // menu categories data
      await createMenuProductsTable(db); // menu products list data
      await createTablePasswordsTable(db); // tables with passwords data
      await createOrdersTable(db); // tables for
    });
  }

  Future<void> createTablePasswordsTable(sql.Database database) async =>
      await database.execute("CREATE TABLE $tablesPasswordsTableName("
          "id $idType,"
          "tableNumber $intType,"
          "tablePassword $stringType"
          ")");

  Future<void> createMenuProductsTable(sql.Database database) async =>
      await database.execute("CREATE TABLE $menuProductsTableName("
          "id $idType,"
          "name $stringType,"
          "image $stringType,"
          "price $stringType,"
          "weight $stringType,"
          "productCategoryId $stringType"
          ")");

  Future<void> createMenuCategoriesTable(sql.Database database) async =>
      await database.execute("CREATE TABLE $menuCategoriesTableName("
          "id $idType,"
          "categoryName $stringType,"
          "categoryId $stringType"
          ")");

  Future<void> createOrdersTable(sql.Database database) async =>
      await database.execute("CREATE TABLE $ordersTableName("
          "id $idType,"
          "productCategoryId $stringType, "
          "orderProductId $stringType, "
          "name $stringType, "
          "image $stringType, "
          "price $stringType, "
          "weight $stringType, "
          "quantity $intType "
          ")");
}
