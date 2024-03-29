import 'package:night_fall_restaurant/data/local/db/dao/orders_db_dao.dart';
import 'package:night_fall_restaurant/data/local/entities/orders_entity.dart';
import 'package:night_fall_restaurant/data/remote/model/send_to_firebase_models/send_orders_model.dart';
import 'package:night_fall_restaurant/domain/repository/orders_repository/orders_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/result/result_handle.dart';
import '../../use_cases/send_orders_to_fire_store_use_case.dart';

class OrdersRepositoryImpl extends OrdersRepository {
  final OrdersDao dao;
  final SendOrdersToFireStoreUseCase sendOrdersToFireStoreUseCase;

  OrdersRepositoryImpl({
    required this.dao,
    required this.sendOrdersToFireStoreUseCase,
  });

  @override
  Stream<Result<List<OrdersEntity>>> getProductsFromOrdersDb() async* {
    List<OrdersEntity> orderProducts = List.empty();
    final ordersStream = Rx.fromCallable(() => dao.getProductsFromOrders());

    ordersStream.map((orders) => orderProducts = orders);
    try {
      yield SUCCESS(data: orderProducts);
    } on Exception catch (e) {
      yield FAILURE(exception: e);
    }
  }

  @override
  Future<void> clearAllProductsFromOrdersDb() async =>
      await dao.clearAllProductsFromOrders();

  @override
  Future<void> deleteProductFromOrderDb(String orderProductId) async =>
      await dao.deleteProductFromOrders(orderProductId);

  @override
  Future<void> insertProductToOrdersDb(OrdersEntity ordersEntity) async =>
      await dao.insertProductToOrders(ordersEntity);

  @override
  Future<OrdersEntity> getSingleOrderFromDb(int orderId) async =>
      await dao.getSingleOrderProduct(orderId);

  @override
  Future<String?> getSingleOrdersProductId(String orderProductId) async {
    final String? getOrderProductId =
        await dao.getSingleOrderProductId(orderProductId);
    if (getOrderProductId != null) {
      return getOrderProductId;
    } else {
      return null;
    }
  }

  @override
  Future<void> sendOrdersToFireStore(SendOrdersModel sendOrdersModel) async =>
      await sendOrdersToFireStoreUseCase.call(sendOrdersModel);
}
