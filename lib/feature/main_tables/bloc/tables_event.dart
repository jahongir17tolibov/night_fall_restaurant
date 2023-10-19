part of 'tables_bloc.dart';

@immutable
sealed class TablesEvent {}

class TablesOnGetPasswordsEvent extends TablesEvent {}

class TablesOnChangeTableNumber extends TablesEvent {}
