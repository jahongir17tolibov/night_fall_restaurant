import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:night_fall_restaurant/core/result/result_handle.dart';
import 'package:night_fall_restaurant/data/remote/model/send_to_firebase_models/order_products_for_post_model.dart';
import 'package:night_fall_restaurant/data/remote/model/send_to_firebase_models/send_orders_model.dart';
import 'package:night_fall_restaurant/data/shared/shared_preferences.dart';
import 'package:night_fall_restaurant/utils/helpers.dart';

import '../../../data/local/entities/orders_entity.dart';
import '../../../domain/repository/orders_repository/orders_repository.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository repository;
  final AppSharedPreferences sharedPreferences;

  late StreamSubscription _streamSubscription;

  OrdersBloc({
    required this.repository,
    required this.sharedPreferences,
  }) : super(OrdersLoadingState()) {
    on<OrdersOnGetProductsEvent>(getOrderProductsEvent);

    on<OrdersOnClearProductsEvent>(clearAllOrdersEvent);

    on<OrdersOnNavigateBackEvent>(navigateBackEvent);

    on<OrdersOnSendProductsToFireStoreEvent>(sendOrdersEvent);
  }

  int _pricesCount = 0;
  int get pricesCount => _pricesCount;

  final DateTime _currentDateTime = DateTime.now();

  Future<void> getOrderProductsEvent(
    OrdersOnGetProductsEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoadingState());
    try {
      await fetchOrdersData(emit);
    } on Exception catch (e) {
      emit(OrdersErrorState(e.toString()));
    }
  }

  Future<void> clearAllOrdersEvent(
    OrdersOnClearProductsEvent event,
    Emitter<OrdersState> emit,
  ) async {
    await repository.clearAllProductsFromOrdersDb();
    emit(OrdersLoadingState());
    await fetchOrdersData(emit);
  }

  Future<void> fetchOrdersData(Emitter<OrdersState> emit) async {
    final orders = await repository.getProductsFromOrdersDb();
    switch (orders) {
      case SUCCESS():
        {
          if (orders.data.isNotEmpty) {
            for (var order in orders.data) {
              final cleanedPrice =
                  order.price.replaceAll("so'm", '').replaceAll(' ', '');
              final parsedPrice = int.parse(cleanedPrice);
              _pricesCount += parsedPrice;
            }
            emit(OrdersSuccessState(ordersList: orders.data));
          } else {
            emit(OrdersIsEmptyState());
          }
        }
      case FAILURE():
        emit(OrdersErrorState(orders.exception.toString()));
    }
  }

  Future<void> sendOrdersEvent(
    OrdersOnSendProductsToFireStoreEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final int tableNumber = await sharedPreferences.getTableNumber();
    try {
      final formattedDateTime = _getCurrentDateTime();
      final encryptedId = _getCurrentEncryptedDateTime(tableNumber);
      final mappingOrderProducts = event.orders.map((order) {
        final productModel = OrderProductsForPostModel.fromOrdersEntity(order);
        return productModel;
      });
      final SendOrdersModel sendOrders = SendOrdersModel(
        orderId: encryptedId,
        tableNumber: tableNumber.toString(),
        sendTime: formattedDateTime,
        totalPrice: "${_pricesCount}so'm",
        orderProducts: mappingOrderProducts.toList(),
      );
      await repository.sendOrdersToFireStore(sendOrders);
      emit(OrdersShowSnackBarOnSendOrdersState(
        'orders from the table $tableNumber were sent successfully',
      ));
    } catch (e) {
      emit(OrdersShowSnackBarOnSendOrdersState(e.toString()));
    }
  }

  /// action events
  Future<void> navigateBackEvent(
    OrdersOnNavigateBackEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersListenOnBackNavigateState());
    _pricesCount = 0;
  }

  @override
  Future<void> close() async {
    super.close();
    _streamSubscription.cancel();
  }

  String _getCurrentDateTime() =>
      DateFormat("HH:mm, dd-MM-yyyy").format(_currentDateTime);

  String _getCurrentEncryptedDateTime(int tableNumb) {
    final int milliseconds = _currentDateTime.millisecondsSinceEpoch;
    final int day = _currentDateTime.day;
    final String month = getMonthAbbreviation(_currentDateTime.month);
    final int year = _currentDateTime.year;
    return "no${tableNumb}_$milliseconds$day$month$year";
  }
}
