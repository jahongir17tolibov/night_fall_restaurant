import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:night_fall_restaurant/core/result/result_handle.dart';
import 'package:night_fall_restaurant/data/local/entities/table_passwords_entity.dart';
import 'package:night_fall_restaurant/domain/use_cases/sync_tables_password_use_case.dart';

import '../../../data/shared/shared_preferences.dart';
import '../../../domain/use_cases/get_tables_password_for_checking_use_case.dart';
import '../../../domain/use_cases/tables_password_use_case.dart';

part 'tables_event.dart';

part 'tables_state.dart';

class TablesBloc extends Bloc<TablesEvent, TablesState> {
  final SyncTablesPasswordUseCase syncTablesPasswordUseCase;
  final TablesPasswordUseCase tablesPasswordUseCase;
  final GetTablesPasswordForCheckingUseCase forChecking;
  final AppSharedPreferences sharedPreferences;

  TablesBloc({
    required this.tablesPasswordUseCase,
    required this.syncTablesPasswordUseCase,
    required this.forChecking,
    required this.sharedPreferences,
  }) : super(TablesLoadingState()) {
    on<TablesOnGetPasswordsEvent>(_getTablesPassword);

    on<TablesOnPasswordSubmitEvent>(_passwordSubmitEvent);

    on<TablesOnNavigateToHomeScreenEvent>(_navigateToHomeEvent);

    on<TablesOnShowChangeTableDialogEvent>(_showChangeTableDialogEvent);

    on<TablesOnChangeTableNumberEvent>(_changeTableNumberPickerEvent);
  }

  int _selectedTable = 0;

  int get selectedTable => _selectedTable;

  Future<void> _getTablesPassword(
    TablesOnGetPasswordsEvent event,
    Emitter<TablesState> emit,
  ) async {
    final syncTables = await syncTablesPasswordUseCase.call();
    final hasConnection = await InternetConnectionChecker().hasConnection;
    try {
      emit(TablesLoadingState());
      final fetchedTables = await _fetchTablesPassword(emit);
      if (hasConnection) {
        syncTables;
        fetchedTables;
      } else {
        fetchedTables;
      }
    } catch (e) {
      emit(TablesErrorState(error: e.toString()));
    }
  }

  Future<void> _changeTableNumberPickerEvent(
    TablesOnChangeTableNumberEvent event,
    Emitter<TablesState> emit,
  ) async {
    _selectedItemChanged(event.selectedItem);
    emit(TablesShowChangeTableDialogActionState(
      tableNumbers: event.tableNumbers,
    ));
  }

  Future<void> _showChangeTableDialogEvent(
    TablesOnShowChangeTableDialogEvent event,
    Emitter<TablesState> emit,
  ) async {
    emit(TablesShowChangeTableDialogActionState(
      tableNumbers: event.tableNumbers,
    ));
  }

  Future<void> _navigateToHomeEvent(
    TablesOnNavigateToHomeScreenEvent event,
    Emitter<TablesState> emit,
  ) async {
    emit(TablesNavigateToHomeScreenActionState());
  }

  Future<void> _passwordSubmitEvent(
    TablesOnPasswordSubmitEvent event,
    Emitter<TablesState> emit,
  ) async {
    final tablesData = await forChecking.call();
    final getNewTablesNumber = await sharedPreferences.getTableNumber();

    /// checking password
    final isValid = checkPasswords(
      tablesData,
      event.tableNumber,
      event.password,
    );

    if (isValid) {
      emit(TablesValidPasswordState(
        'Valid password and $getNewTablesNumber',
      ));
    } else {
      emit(TablesInValidPasswordState(
        "Invalid table number or password, try again!",
      ));
    }
  }

  bool checkPasswords(
    List<TablePasswordsEntity> tablesData,
    String tableNumber,
    String tablePassword,
  ) {
    for (var it in tablesData) {
      if (it.tableNumber.toString() == tableNumber &&
          it.tablePassword == tablePassword) {
        sharedPreferences.setTableNumber(it.tableNumber);
        return true;
      }
    }
    return false;
  }

  Future<void> _fetchTablesPassword(Emitter<TablesState> emit) async {
    final tablesData = await tablesPasswordUseCase.call();
    switch (tablesData) {
      case SUCCESS():
        {
          final getTableNumber = await sharedPreferences.getTableNumber();
          _selectedTable = getTableNumber - 1;
          emit(TablesSuccessState(
            tablePasswords: tablesData.data,
            tableNumber: getTableNumber.toString(),
          ));
        }
        break;

      case FAILURE():
        emit(TablesErrorState(error: tablesData.exception.toString()));
        break;
    }
  }

  void _selectedItemChanged(int selectedItem) {
    _selectedTable = selectedItem;
  }
}
