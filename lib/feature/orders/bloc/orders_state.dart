part of 'orders_bloc.dart';

@immutable
sealed class OrdersState {}

class OrdersLoadingState extends OrdersState {
  OrdersLoadingState() : super();
}

class OrdersSuccessState extends OrdersState {
  final List<OrdersEntity> ordersList;

  OrdersSuccessState({required this.ordersList}) : super();
}

class OrdersIsEmptyState extends OrdersState {
  OrdersIsEmptyState() : super();
}

class OrdersErrorState extends OrdersState {
  final String error;
  OrdersErrorState(this.error) : super();
}

@immutable
sealed class OrdersActionState extends OrdersState {}

class OrdersListenOnBackNavigateState extends OrdersActionState {}

class OrdersShowSnackBarOnSendOrdersState extends OrdersActionState {
  final String message;

  OrdersShowSnackBarOnSendOrdersState(this.message);
}
