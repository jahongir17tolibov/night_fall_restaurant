import 'package:flutter/cupertino.dart';

import '../../data/local/entities/menu_products_list_dto.dart';
import '../repository/main_repository/repository.dart';

@immutable
class GetSingleProductUseCase {
  final Repository repository;

  const GetSingleProductUseCase({required this.repository});

  Future<MenuProductsListDto> call(int id) async =>
      await repository.getSingleProductFromDb(id);
}
