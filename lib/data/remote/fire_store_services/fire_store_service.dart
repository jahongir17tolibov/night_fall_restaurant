import 'package:night_fall_restaurant/data/remote/model/change_table_model.dart';
import '../model/get_menu_list_response.dart';

abstract class FireStoreService {
  Future<List<GetMenuListResponse>> getMenuList();

  Future<List<ChangeTableModel>> getTablePasswords();
}
