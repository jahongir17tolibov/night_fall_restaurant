import 'package:night_fall_restaurant/data/remote/model/change_table_model_response.dart';
import '../model/get_menu_list_response.dart';

abstract class FireStoreService {
  Future<GetMenuListResponse> getMenuList();

  Future<List<ChangeTableModelResponse>> getTablePasswords();
}
