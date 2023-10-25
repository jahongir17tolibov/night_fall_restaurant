part of 'tables_bloc.dart';

// enum TablesStatus { success, loading, validPassword }
//
// enum TablesError { error, inValidPassword }
//
// @immutable
// class TablesState {
//   final TablesStatus status;
//   final TablesError? error;
//
//   const TablesState._({this.status = TablesStatus.loading, this.error});
// }

@immutable
sealed class TablesState {}

class TablesLoadingState extends TablesState {
  TablesLoadingState() : super();
}

class TablesSuccessState extends TablesState {
  final List<TablesPasswordDto> tablePasswords;
  final String tableNumber;

  TablesSuccessState({
    required this.tablePasswords,
    required this.tableNumber,
  }) : super();
}

class TablesValidPasswordState extends TablesState {
  final String isValid;

  TablesValidPasswordState(this.isValid) : super();
}

class TablesInValidPasswordState extends TablesState {
  final String message;

  TablesInValidPasswordState(this.message) : super();
}

class TablesErrorState extends TablesState {
  final String error;

  TablesErrorState({required this.error}) : super();
}
