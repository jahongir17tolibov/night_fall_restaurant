import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/local/db/dao/tables_password_dao.dart';
import 'package:night_fall_restaurant/data/local/entities/table_passwords_entity.dart';

@immutable
class GetTablesPasswordForCheckingUseCase {
  final TablesPasswordDao dao;

  const GetTablesPasswordForCheckingUseCase(this.dao);

  Future<List<TablePasswordsEntity>> call() async =>
      await dao.getCachedTablesPassword();
}
