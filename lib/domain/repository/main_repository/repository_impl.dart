import 'package:night_fall_restaurant/core/result/result_handle.dart';
import 'package:night_fall_restaurant/data/local/db/dao/menu_products_dao.dart';
import 'package:night_fall_restaurant/data/local/db/dao/tables_password_dao.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_categories_entity.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_entity.dart';
import 'package:night_fall_restaurant/data/local/entities/table_passwords_entity.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_service.dart';
import 'package:night_fall_restaurant/domain/repository/main_repository/repository.dart';

class RepositoryImpl extends Repository {
  final FireStoreService fireStoreService;
  final MenuProductsDao menuListDao;
  final TablesPasswordDao tablesDao;

  RepositoryImpl({
    required this.fireStoreService,
    required this.menuListDao,
    required this.tablesDao,
  });

    static final Exception _ifEmptyDataException = Exception(
      "Database is empty or check internet connection",
    );

  @override
  Future<void> syncMenuProductsList() async {
    final menuProductsFromFireStore = await fireStoreService.getMenuList();
    final cachedMenuProductsList = await menuListDao.getCachedMenuList();
    final cachedMenuCategories = await menuListDao.getCachedMenuCategories();

    /// mapping fireStoreData to Database table
    try {
      final mappingMenuProductsList = menuProductsFromFireStore.menu_products
          .map((data) => MenuProductsEntity.fromMenuProductsListResponse(
                menuList: data,
              ))
        ..forEach((products) async {
          if (cachedMenuProductsList.isEmpty) {
            await menuListDao.insertMenuProductsList(products);
          } else {
            await menuListDao.updateMenuProductsList(products);
          }
        });

      final mappingMenuCategories = menuProductsFromFireStore.menu_categories
          .map((category) => MenuCategoriesEntity.fromMenuProductsListResponse(
                categories: category,
              ))
        ..forEach((categories) async {
          if (cachedMenuCategories.isEmpty) {
            await menuListDao.insertMenuCategories(categories);
          } else {
            await menuListDao.updateMenuCategoriesList(categories);
          }
        });

      if (cachedMenuProductsList.isNotEmpty &&
          cachedMenuCategories.isNotEmpty) {
        if (cachedMenuProductsList.length !=
            menuProductsFromFireStore.menu_products.length) {
          await _operationMenuProducts(mappingMenuProductsList);
          await _operationMenuCategories(mappingMenuCategories);
        }
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> syncTablesPassword() async {
    final tablesPasswordFromFireStore =
        await fireStoreService.getTablePasswords();

    final cachedTablesPassword = await tablesDao.getCachedTablesPassword();

    final mappingTablesPassword = tablesPasswordFromFireStore.map((data) =>
        TablePasswordsEntity.fromTablesPasswordResponse(tablesResponse: data))
      ..forEach((data) async {
        if (cachedTablesPassword.isEmpty) {
          await tablesDao.insertTablesPassword(data);
        } else {
          await tablesDao.updateTablePasswords(data);
        }
      });

    if (cachedTablesPassword.isNotEmpty) {
      if (cachedTablesPassword.length != tablesPasswordFromFireStore.length) {
        await _operationTablePasswords(mappingTablesPassword);
      }
    }
  }

  @override
  Future<Result<List<MenuProductsEntity>>> getMenuListFromDb() async {
    try {
      final cachedMenuProducts = await menuListDao.getCachedMenuList();
      if (cachedMenuProducts.isNotEmpty) {
        return SUCCESS(data: cachedMenuProducts);
      } else {
        return FAILURE(exception: _ifEmptyDataException);
      }
    } on Exception catch (e) {
      return FAILURE(exception: e);
    }
  }

  @override
  Future<Result<List<TablePasswordsEntity>>> getTablesPasswordsFromDb() async {
    try {
      final cachedTablesPassword = await tablesDao.getCachedTablesPassword();
      if (cachedTablesPassword.isNotEmpty) {
        return SUCCESS(data: cachedTablesPassword);
      } else {
        return FAILURE(exception: _ifEmptyDataException);
      }
    } on Exception catch (e) {
      return FAILURE(exception: e);
    }
  }

  @override
  Future<List<MenuCategoriesEntity>> getMenuCategoriesFromDb() async {
    try {
      final cachedCategories = await menuListDao.getCachedMenuCategories();
      if (cachedCategories.isNotEmpty) {
        return cachedCategories;
      } else {
        throw Exception('categories List is empty');
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _operationMenuProducts(
    Iterable<MenuProductsEntity> mappingMenuProductsList,
  ) async {
    await menuListDao.clearMenuProducts();
    for (var products in mappingMenuProductsList) {
      await menuListDao.insertMenuProductsList(products);
    }
  }

  Future<void> _operationMenuCategories(
    Iterable<MenuCategoriesEntity> mappingMenuCategories,
  ) async {
    await menuListDao.clearMenuCategories();
    for (var categories in mappingMenuCategories) {
      await menuListDao.insertMenuCategories(categories);
    }
  }

  Future<void> _operationTablePasswords(
    Iterable<TablePasswordsEntity> mappingTablesPassword,
  ) async {
    await tablesDao.clearAllTablePasswords();
    for (var it in mappingTablesPassword) {
      await tablesDao.insertTablesPassword(it);
    }
  }
}
