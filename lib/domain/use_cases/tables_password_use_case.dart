import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/core/result/result_handle.dart';
import 'package:night_fall_restaurant/data/local/entities/table_passwords_entity.dart';
import 'package:night_fall_restaurant/domain/repository/main_repository/repository.dart';

@immutable
class TablesPasswordUseCase {
  final Repository repository;

  const TablesPasswordUseCase(this.repository);

  Future<Result<List<TablePasswordsEntity>>> call() async =>
      await repository.getTablesPasswordsFromDb();
}
