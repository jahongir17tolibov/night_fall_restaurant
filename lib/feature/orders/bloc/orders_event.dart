part of 'orders_bloc.dart';

@immutable
sealed class OrdersEvent {}

class OrdersOnGetProductsEvent extends OrdersEvent {}

class OrdersOnClearProductsEvent extends OrdersEvent {}

class OrdersOnNavigateBackEvent extends OrdersEvent {}

class OrdersOnSendProductsToFireStoreEvent extends OrdersEvent {
  final List<OrderProductsModel> orders;

  OrdersOnSendProductsToFireStoreEvent(this.orders);
}

class OrderIncreaseProductEvent extends OrdersEvent {
  final OrderProductsModel orderProduct;

  OrderIncreaseProductEvent(this.orderProduct);
}

class OrderDecreaseProductEvent extends OrdersEvent {
  final OrderProductsModel orderProduct;

  OrderDecreaseProductEvent(this.orderProduct);
}
