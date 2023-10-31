part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeLoadingState extends HomeState {
  HomeLoadingState() : super();
}

class HomeSuccessState extends HomeState {
  final List<MenuProductsListDto> response;
  final List<MenuCategoriesDto> menuCategories;

  HomeSuccessState({required this.response, required this.menuCategories});
}

class HomeErrorState extends HomeState {
  final String error;

  HomeErrorState({required this.error});
}

sealed class HomeActionState extends HomeState {}

class HomeNavigateBackActionState extends HomeActionState {}

class HomeNavigateToOrdersScreenState extends HomeActionState {}

class HomeListenInsertToOrderActionState extends HomeActionState {
  final String message;

  HomeListenInsertToOrderActionState(this.message);
}

class HomeListenDeleteFromOrderActionState extends HomeActionState {
  final String message;

  HomeListenDeleteFromOrderActionState(this.message);
}
