import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:night_fall_restaurant/core/result/result_handle.dart';
import 'package:night_fall_restaurant/data/remote/model/send_to_firebase_models/order_products_for_post_model.dart';
import 'package:night_fall_restaurant/data/remote/model/send_to_firebase_models/send_orders_model.dart';
import 'package:night_fall_restaurant/data/shared/shared_preferences.dart';
import 'package:night_fall_restaurant/domain/model/order_products_model.dart';
import 'package:night_fall_restaurant/domain/repository/orders_repository/orders_repository.dart';
import 'package:night_fall_restaurant/utils/helpers.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository repository;
  final AppSharedPreferences sharedPreferences;

  OrdersBloc({
    required this.repository,
    required this.sharedPreferences,
  }) : super(OrdersLoadingState()) {
    on<OrdersOnGetProductsEvent>(_getOrderProductsEvent);

    on<OrdersOnClearProductsEvent>(_clearAllOrdersEvent);

    on<OrdersOnNavigateBackEvent>(_navigateBackEvent);

    on<OrdersOnSendProductsToFireStoreEvent>(_sendOrdersEvent);
  }

  int _pricesCount = 0;

  int get pricesCount => _pricesCount;

  final DateTime _currentDateTime = DateTime.now();

  Future<void> _getOrderProductsEvent(
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

  Future<void> _clearAllOrdersEvent(
    OrdersOnClearProductsEvent event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      await repository.clearAllProductsFromOrdersDb();
      emit(OrdersLoadingState());
      await fetchOrdersData(emit);
    } catch (e) {
      emit(OrdersErrorState(e.toString()));
    }
  }

  Future<void> fetchOrdersData(Emitter<OrdersState> emit) async {
    final orders = await repository.getProductsFromOrdersDb();
    switch (orders) {
      case SUCCESS():
        {
          if (orders.data.isNotEmpty) {
            for (var order in orders.data) {
              final cleanedPrice =
                  order.price.replaceAll("so`m", '').replaceAll(' ', '');
              final parsedPrice = int.parse(cleanedPrice);
              _pricesCount += parsedPrice;
            }

            final ordersModel = orders.data
                .map((data) => OrderProductsModel.fromOrdersEntity(data));

            emit(OrdersSuccessState(ordersList: ordersModel.toList()));
          } else {
            emit(OrdersIsEmptyState());
          }
        }
      case FAILURE():
        emit(OrdersErrorState(orders.exception.toString()));
    }
  }

  Future<void> _sendOrdersEvent(
    OrdersOnSendProductsToFireStoreEvent event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final int tableNumber = await sharedPreferences.getTableNumber();
      final hasConnection = await InternetConnectionChecker().hasConnection;
      final String formattedDateTime = _getCurrentDateTime();
      final String encryptedId = _getCurrentEncryptedDateTime(tableNumber);

      if (hasConnection) {
        final mappingOrderProducts = event.orders
            .map((order) => OrderProductsForPostModel.fromOrderProductsModel(
                  orderUniqueId: encryptedId,
                  orderProductsModel: order,
                ));

        final SendOrdersModel sendOrders = SendOrdersModel(
          orderId: encryptedId,
          tableNumber: tableNumber.toString(),
          sendTime: formattedDateTime,
          totalPrice: "${_pricesCount}so`m",
          orderProducts: mappingOrderProducts.toList(),
        );

        await repository.sendOrdersToFireStore(sendOrders);
        emit(OrdersOnShowSnackMessageActionState(
          'orders from the table $tableNumber were sent successfully',
        ));
      } else {
        emit(OrdersOnShowSnackMessageActionState("Check internet connection"));
      }
    } catch (e) {
      emit(OrdersOnShowSnackMessageActionState(e.toString()));
    }
  }

  /// action events
  Future<void> _navigateBackEvent(
    OrdersOnNavigateBackEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (event.isButton) {
      emit(OrdersListenOnBackNavigateState());
    }
    _pricesCount = 0;
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
