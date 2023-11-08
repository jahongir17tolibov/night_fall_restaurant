import 'package:night_fall_restaurant/data/local/entities/menu_categories_entity.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_entity.dart';
import 'package:night_fall_restaurant/data/local/entities/orders_entity.dart';
import 'package:night_fall_restaurant/data/local/entities/table_passwords_entity.dart';
import 'package:night_fall_restaurant/utils/constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static AppDatabase getInstance = AppDatabase._init();

  static const String _dataBaseName = 'night_fall.db';
  static const int _databaseVersion = 1;
  Database? _database;

  AppDatabase._init();

  Future<Database> getDatabase() async {
    _database ??= await initializeDatabase(dataBaseName: _dataBaseName);
    return _database!;
  }

  Future<Database> initializeDatabase({required String dataBaseName}) async {
    String databasePath = await getAppDatabasePath();
    return await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: onCreateDatabase,
    );
  }

  Future<String> getAppDatabasePath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, _dataBaseName);
  }

  Future<void> onCreateDatabase(Database db, int version) async {
    await db.execute("""
      CREATE TABLE ${TablePasswordsEntity.TABLE_NAME}(
                      ${TablePasswordsEntity.CM_ID} $idType,
                      ${TablePasswordsEntity.CM_TABLE_NUMBER} $intType,
                      ${TablePasswordsEntity.CM_TABLE_PASSWORD} $stringType
          )""");

    await db.execute("""
      CREATE TABLE ${MenuProductsEntity.TABLE_NAME}(
                      ${MenuProductsEntity.CM_ID} $idType,
                      ${MenuProductsEntity.CM_PRODUCT_NAME} $stringType,
                      ${MenuProductsEntity.CM_IMAGE} $stringType,
                      ${MenuProductsEntity.CM_PRICE} $stringType,
                      ${MenuProductsEntity.CM_WEIGHT} $stringType,
                      ${MenuProductsEntity.CM_PRODUCT_CATEGORY_ID} $stringType
        )""");

    await db.execute("""
      CREATE TABLE ${MenuCategoriesEntity.TABLE_NAME}(
                      ${MenuCategoriesEntity.CM_ID} $idType,
                      ${MenuCategoriesEntity.CM_CATEGORY_NAME} $stringType,
                      ${MenuCategoriesEntity.CM_CATEGORY_ID} $stringType
        )""");

    await db.execute("""
      CREATE TABLE ${OrdersEntity.TABLE_NAME}(
                      ${OrdersEntity.CM_ID} $idType,
                      ${OrdersEntity.CM_PRODUCT_CATEGORY_ID} $stringType, 
                      ${OrdersEntity.CM_ORDER_PRODUCT_ID} $stringType, 
                      ${OrdersEntity.CM_ORDER_NAME} $stringType, 
                      ${OrdersEntity.CM_IMAGE} $stringType, 
                      ${OrdersEntity.CM_PRICE} $stringType, 
                      ${OrdersEntity.CM_WEIGHT} $stringType
        )""");
  }
}
