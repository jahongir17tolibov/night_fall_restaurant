import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../../utils/constants.dart';

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
      await createMenuProductsTable(db); // menu products list data
      await createTablePasswordsTable(db); // tables with passwords data
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
}
