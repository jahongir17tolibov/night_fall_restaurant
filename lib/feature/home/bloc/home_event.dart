part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeOnGetMenuListEvent extends HomeEvent {}

class HomeOnAddToCartEvent extends HomeEvent {}

class HomeOnNavigateToCartScreenEvent extends HomeEvent {}

class HomeOnGetThemeEvent extends HomeEvent {}

class HomeOnChangeThemeEvent extends HomeEvent {
  final bool isDark;

  HomeOnChangeThemeEvent(this.isDark);
}
