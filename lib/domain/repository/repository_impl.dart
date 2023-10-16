import 'package:night_fall_restaurant/domain/repository/repository.dart';

import '../../data/remote/fire_store_result.dart';
import '../../data/remote/fire_store_service.dart';
import '../../data/remote/model/get_menu_list_response.dart';

class RepositoryImpl extends Repository {
  final FireStoreService fireStoreService;

  RepositoryImpl({required this.fireStoreService});

  @override
  Future<FireStoreResult<List<GetMenuListResponse>>>
      getMenuListFromFireStore() async {
    try {
      List<GetMenuListResponse> menuList = await fireStoreService.getMenuList();
      return SUCCESS(data: menuList);
    } on Exception catch (exception) {
      return FAILURE(exception: exception);
    }
  }
}
