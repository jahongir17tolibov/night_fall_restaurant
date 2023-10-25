import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/local/entities/tables_password_dto.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_result.dart';
import 'package:night_fall_restaurant/domain/repository/repository.dart';

import '../../data/remote/model/change_table_model_response.dart';

@immutable
class TablesPasswordUseCase {
  final Repository repository;

  const TablesPasswordUseCase({required this.repository});

  Future<FireStoreResult<List<TablesPasswordDto>>> call() async =>
      await repository.getTablesPasswordsFromDb();
}
