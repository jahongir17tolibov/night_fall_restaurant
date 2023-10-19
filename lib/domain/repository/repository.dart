import 'package:night_fall_restaurant/data/remote/model/change_table_model.dart';

import '../../data/remote/fire_store_services/fire_store_result.dart';
import '../../data/remote/model/get_menu_list_response.dart';

abstract class Repository {
  Future<FireStoreResult<List<GetMenuListResponse>>> getMenuListFromFireStore();

  Future<FireStoreResult<List<ChangeTableModel>>>
      getTablesPasswordsFromFireStore();
}
