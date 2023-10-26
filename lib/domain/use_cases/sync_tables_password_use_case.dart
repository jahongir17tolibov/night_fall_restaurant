import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/domain/repository/main_repository/repository.dart';

@immutable
class SyncTablesPasswordUseCase {
  final Repository repository;

  const SyncTablesPasswordUseCase(this.repository);

  Future<void> call() async => await repository.syncTablesPassword();
}
