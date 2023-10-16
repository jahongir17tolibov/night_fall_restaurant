part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeLoadingState extends HomeState {
  HomeLoadingState() : super();
}

class HomeSuccessState extends HomeState {
  final List<GetMenuListResponse> response;

  HomeSuccessState({required this.response});
}

class HomeErrorState extends HomeState {
  final String exception;

  HomeErrorState({required this.exception});
}
