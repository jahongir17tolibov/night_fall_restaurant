part of 'orders_bloc.dart';

@immutable
sealed class OrdersState {}

class OrdersLoadingState extends OrdersState {
  OrdersLoadingState() : super();
}

class OrdersSuccessState extends OrdersState {
  final List<OrderProductsModel> ordersList;

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

class OrdersOnShowSnackMessageActionState extends OrdersActionState {
  final String message;

  OrdersOnShowSnackMessageActionState(this.message);
}

class OrdersAddValueActionState extends OrdersActionState {
  final int value;

  OrdersAddValueActionState(this.value);
}

class OrdersRemoveValueActionState extends OrdersActionState {
  final int value;

  OrdersRemoveValueActionState(this.value);
}
