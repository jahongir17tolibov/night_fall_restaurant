import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:night_fall_restaurant/core/result/result_handle.dart';
import 'package:night_fall_restaurant/data/local/entities/orders_entity.dart';
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

    on<OrderIncreaseProductEvent>(_increaseProduct);

    on<OrderDecreaseProductEvent>(_decreaseProduct);
  }

  late StreamController _streamController;

  int _calculatePrices = 0;

  int get calculatePrices => _calculatePrices;

  final DateTime _currentDateTime = DateTime.now();

  Stream<void> _getOrderProductsEvent(
    OrdersOnGetProductsEvent event,
    Emitter<OrdersState> emit,
  ) async* {
    _streamController = StreamController<Result<List<OrdersEntity>>>();
    print("listener: ${_streamController.hasListener}");
    print("closed: ${_streamController.isClosed}");
    emit(OrdersLoadingState());
    try {
      _fetchOrdersData(emit);
    } on Exception catch (e) {
      emit(OrdersErrorState(e.toString()));
    }
  }

  Future<void> _increaseProduct(
    OrderIncreaseProductEvent event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final int currentProductAmount = event.orderProduct.quantity;
      if (state is OrdersSuccessState) {
        final currentState = state as OrdersSuccessState;

        final newOrderList = currentState.ordersList.map((product) {
          if (product == event.orderProduct) {
            return OrderProductsModel(
                productCategoryId: product.productCategoryId,
                name: product.name,
                fireId: product.fireId,
                image: product.image,
                price: product.price,
                weight: product.weight,
                quantity: currentProductAmount < 9
                    ? product.quantity + 1
                    : currentProductAmount);
          }
          return product;
        });

        if (currentProductAmount < 9) {
          _pricesCalculation(ordersModel: newOrderList, isIncrease: true);
        }

        emit(OrdersSuccessState(ordersList: newOrderList.toList()));
      }
    } catch (e) {
      emit(OrdersErrorState(e.toString()));
    }
  }

  Future<void> _decreaseProduct(
    OrderDecreaseProductEvent event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final int currentProductAmount = event.orderProduct.quantity;
      if (state is OrdersSuccessState) {
        final currentState = state as OrdersSuccessState;

        final newOrderList = currentState.ordersList.map((product) {
          if (product == event.orderProduct) {
            return OrderProductsModel(
                productCategoryId: product.productCategoryId,
                name: product.name,
                fireId: product.fireId,
                image: product.image,
                price: product.price,
                weight: product.weight,
                quantity: currentProductAmount > 0
                    ? product.quantity - 1
                    : product.quantity);
          }
          return product;
        });

        if (currentProductAmount > 0) {
          _pricesCalculation(ordersModel: newOrderList, isIncrease: false);
        }

        emit(OrdersSuccessState(ordersList: newOrderList.toList()));
      }
    } catch (e) {
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
      await _fetchOrdersData(emit);
    } catch (e) {
      emit(OrdersErrorState(e.toString()));
    }
  }

  Stream<void> _fetchOrdersData(Emitter<OrdersState> emit) async* {
    final ordersDataReactive = repository.getProductsFromOrdersDb();
    _streamController.add(ordersDataReactive);

    _streamController.stream.listen((orders) {
      switch (orders) {
        case SUCCESS():
          {
            if (orders.data.isNotEmpty) {
              final ordersModel = orders.data
                  .map((data) => OrderProductsModel.fromOrdersEntity(data));

              _pricesCalculation(ordersModel: ordersModel, isIncrease: true);

              emit(OrdersSuccessState(ordersList: ordersModel.toList()));
            } else {
              emit(OrdersIsEmptyState());
            }
          }
          break;

        case FAILURE():
          emit(OrdersErrorState(orders.exception.toString()));
          break;
      }
    });
  }

  Future<void> _sendOrdersEvent(
    OrdersOnSendProductsToFireStoreEvent event,
    Emitter<OrdersState> emit,
  ) async {
    const String lottiePath = "assets/anim/waiting_anim.json";
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
          totalPrice: "${_calculatePrices}so`m",
          orderProducts: mappingOrderProducts.toList(),
        );

        await repository.sendOrdersToFireStore(sendOrders);
        emit(OrdersShowSnackMessageActionState(
          'orders from the table $tableNumber were sent successfully',
        ));
        emit(OrdersShowSuccessfullySentActionState(
          lottiePath,
          "Buyurtmangiz qabul qilindi iltimos kutib turing",
        ));
      } else {
        emit(OrdersShowSnackMessageActionState("Check internet connection!!!"));
      }
    } catch (e) {
      emit(OrdersShowSnackMessageActionState(e.toString()));
    }
  }

  /// action events

  Future<void> _navigateBackEvent(
    OrdersOnNavigateBackEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersListenOnBackNavigateState());
    _calculatePrices = 0;
  }

  void _pricesCalculation({
    required Iterable<OrderProductsModel> ordersModel,
    required bool isIncrease,
  }) {
    for (var order in ordersModel) {
      print(order.quantity);
      final cleanedPrice =
          order.price.replaceAll("so`m", '').replaceAll(' ', '');
      final parsedPrice = int.parse(cleanedPrice) * order.quantity;
      isIncrease
          ? _calculatePrices += parsedPrice
          : _calculatePrices -= parsedPrice;
    }
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

  @override
  Future<void> close() {
    _streamController.close();
    return super.close();
  }
}
