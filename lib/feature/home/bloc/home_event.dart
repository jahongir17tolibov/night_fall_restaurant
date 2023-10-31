part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeOnGetMenuListEvent extends HomeEvent {}

class HomeOnRefreshEvent extends HomeEvent {}

class HomeOnInsertOrDeleteOrdersEvent extends HomeEvent {
  final bool state;
  final int productId;

  HomeOnInsertOrDeleteOrdersEvent({
    required this.productId,
    required this.state,
  });
}

class HomeOnNavigateBackEvent extends HomeEvent {}

class HomeOnNavigateToOrdersScreenEvent extends HomeEvent {}

class HomeOnItemsClickEvent extends HomeEvent {
  final int itemIndex;

  HomeOnItemsClickEvent(this.itemIndex);
}

/// keyin...
class HomeOnGetThemeEvent extends HomeEvent {}

class HomeOnChangeThemeEvent extends HomeEvent {
  final bool isDark;

  HomeOnChangeThemeEvent(this.isDark);
}
