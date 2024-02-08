part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeLoadingState extends HomeState {
  HomeLoadingState() : super();
}

class HomeSuccessState extends HomeState {
  final List<MenuProductsEntity> menuProducts;
  final List<MenuCategoriesEntity> menuCategories;

  HomeSuccessState({
    required this.menuProducts,
    required this.menuCategories,
  });
}

class HomeErrorState extends HomeState {
  final String error;

  HomeErrorState({required this.error});
}

@immutable
sealed class HomeActionState extends HomeState {}

class HomeNavigateBackActionState extends HomeActionState {}

class HomeNavigateToOrdersScreenState extends HomeActionState {}

class HomeShowSnackMessageActionState extends HomeActionState {
  final String message;

  HomeShowSnackMessageActionState(this.message);
}
