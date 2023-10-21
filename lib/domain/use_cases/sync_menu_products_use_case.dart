import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/domain/repository/repository.dart';

@immutable
class SyncMenuProductsUseCase {
  final Repository repository;

  const SyncMenuProductsUseCase(this.repository);

  Future<void> call() async => await repository.syncMenuProductsList();
}
