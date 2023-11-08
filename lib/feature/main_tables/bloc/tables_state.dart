part of 'tables_bloc.dart';

@immutable
sealed class TablesState {}

class TablesLoadingState extends TablesState {
  TablesLoadingState() : super();
}

class TablesSuccessState extends TablesState {
  final List<TablePasswordsEntity> tablePasswords;
  final String tableNumber;

  TablesSuccessState({
    required this.tablePasswords,
    required this.tableNumber,
  }) : super();
}

class TablesErrorState extends TablesState {
  final String error;

  TablesErrorState({required this.error}) : super();
}

@immutable
sealed class TablesActionState extends TablesState {}

class TablesNavigateToHomeScreenActionState extends TablesActionState {}

class TablesShowChangeTableDialogActionState extends TablesActionState {}

class TablesValidPasswordState extends TablesActionState {
  final String isValid;

  TablesValidPasswordState(this.isValid) : super();
}

class TablesInValidPasswordState extends TablesActionState {
  final String message;

  TablesInValidPasswordState(this.message) : super();
}

class TablesCheckAndSubmitActionState extends TablesActionState {}
