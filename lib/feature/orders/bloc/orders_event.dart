part of 'orders_bloc.dart';

@immutable
sealed class OrdersEvent {}

class OrdersOnGetProductsEvent extends OrdersEvent {}

class OrdersOnClearProductsEvent extends OrdersEvent {}

class OrdersOnNavigateBackEvent extends OrdersEvent {
  final bool isButton;

  OrdersOnNavigateBackEvent({this.isButton = true});
}

class OrdersOnSendProductsToFireStoreEvent extends OrdersEvent {
  final List<OrderProductsModel> orders;

  OrdersOnSendProductsToFireStoreEvent(this.orders);
}
