part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeOnGetMenuListEvent extends HomeEvent {}

class HomeOnAddToCartEvent extends HomeEvent {}

class HomeOnNavigateToCartScreenEvent extends HomeEvent {}

class HomeOnRefreshEvent extends HomeEvent {}

/// keyin...
class HomeOnGetThemeEvent extends HomeEvent {}

class HomeOnChangeThemeEvent extends HomeEvent {
  final bool isDark;

  HomeOnChangeThemeEvent(this.isDark);
}
