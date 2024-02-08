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

class OrdersShowSnackMessageActionState extends OrdersActionState {
  final String message;

  OrdersShowSnackMessageActionState(this.message);
}

class OrdersShowSuccessfullySentActionState extends OrdersActionState {
  final String lottiePath;
  final String statusText;

  OrdersShowSuccessfullySentActionState(this.lottiePath, this.statusText);
}
