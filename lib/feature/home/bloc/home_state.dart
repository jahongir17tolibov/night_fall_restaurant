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

class ThemeState extends HomeState {
  final ThemeData isDark;

  ThemeState(this.isDark);
}
