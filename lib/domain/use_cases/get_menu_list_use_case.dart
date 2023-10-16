import 'package:flutter/cupertino.dart';

import '../../data/remote/fire_store_result.dart';
import '../../data/remote/model/get_menu_list_response.dart';
import '../repository/repository.dart';

@immutable
class GetMenuListUseCase {
  final Repository repository;

  const GetMenuListUseCase({required this.repository});

  Future<FireStoreResult<List<GetMenuListResponse>>> call() async =>
      repository.getMenuListFromFireStore();
}
