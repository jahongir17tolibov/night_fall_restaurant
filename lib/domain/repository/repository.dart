import '../../data/remote/fire_store_result.dart';
import '../../data/remote/model/get_menu_list_response.dart';

abstract class Repository {
  Future<FireStoreResult<List<GetMenuListResponse>>> getMenuListFromFireStore();
}
