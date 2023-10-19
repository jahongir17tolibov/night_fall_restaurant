import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_result.dart';
import 'package:night_fall_restaurant/domain/repository/repository.dart';

import '../../data/remote/model/change_table_model.dart';

@immutable
class ChangeTableUseCase {
  final Repository repository;

  const ChangeTableUseCase({required this.repository});

  Future<FireStoreResult<List<ChangeTableModel>>> call() =>
      repository.getTablesPasswordsFromFireStore();
}
