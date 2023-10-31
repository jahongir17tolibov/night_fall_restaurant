import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/local/entities/tables_password_dto.dart';
import 'package:night_fall_restaurant/core/result/result_handle.dart';
import 'package:night_fall_restaurant/domain/repository/main_repository/repository.dart';

import '../../data/remote/model/change_table_model_response.dart';

@immutable
class TablesPasswordUseCase {
  final Repository repository;

  const TablesPasswordUseCase({required this.repository});

  Future<Result<List<TablesPasswordDto>>> call() async =>
      await repository.getTablesPasswordsFromDb();
}
