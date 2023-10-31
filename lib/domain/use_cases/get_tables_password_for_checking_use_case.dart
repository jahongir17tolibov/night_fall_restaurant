import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/local/entities/tables_password_dto.dart';

import '../repository/main_repository/repository.dart';

@immutable
class GetTablesPasswordForCheckingUseCase {
  final Repository repository;

  const GetTablesPasswordForCheckingUseCase(this.repository);

  Future<List<TablesPasswordDto>> call() async =>
      await repository.getTablesPasswordsForChecking();
}
