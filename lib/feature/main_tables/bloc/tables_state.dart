part of 'tables_bloc.dart';

@immutable
sealed class TablesState {}

class TablesLoadingState extends TablesState {
  TablesLoadingState() : super();
}

class TablesSuccessState extends TablesState {
  final List<ChangeTableModel> tablePasswords;

  TablesSuccessState({required this.tablePasswords}) : super();
}

class TablesErrorState extends TablesState {
  final String error;

  TablesErrorState({required this.error}) : super();
}
