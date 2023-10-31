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

class TablesOnChangeTextFieldEvent extends TablesEvent {
  final BuildContext context;

  TablesOnChangeTextFieldEvent(this.context);
}

class TablesOnNavigateToHomeScreenEvent extends TablesEvent {}

class TablesOnShowNumberPickerEvent extends TablesEvent {}

class TablesOnShowChangeTableDialogEvent extends TablesEvent {}

class TablesOnCheckAndSubmitEvent extends TablesEvent {}
