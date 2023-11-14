part of 'tables_bloc.dart';

@immutable
sealed class TablesEvent {}

class TablesOnGetPasswordsEvent extends TablesEvent {}

class TablesOnPasswordSubmitEvent extends TablesEvent {
  final String tableNumber;
  final String password;

  TablesOnPasswordSubmitEvent({
    required this.tableNumber,
    required this.password,
  });
}

class TablesOnChangeTableNumberEvent extends TablesEvent {
  final List<TablePasswordsEntity> tablePasswords;
  final String tableNumber;
  final int selectedItem;

  TablesOnChangeTableNumberEvent({
    required this.tablePasswords,
    required this.tableNumber,
    required this.selectedItem,
  });
}

class TablesOnNavigateToHomeScreenEvent extends TablesEvent {}

class TablesOnShowChangeTableDialogEvent extends TablesEvent {
  final List<int> tableNumbers;
  final List<TablePasswordsEntity> tablePasswords;
  final String currentTableNumber;

  TablesOnShowChangeTableDialogEvent({
    required this.tableNumbers,
    required this.tablePasswords,
    required this.currentTableNumber,
  });
}

class TablesOnCheckAndSubmitEvent extends TablesEvent {}
