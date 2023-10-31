import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:night_fall_restaurant/core/result/result_handle.dart';
import 'package:night_fall_restaurant/data/local/entities/tables_password_dto.dart';
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
    on<TablesOnGetPasswordsEvent>(getTablesPassword);

    on<TablesOnPasswordSubmitEvent>(passwordSubmitEvent);

    on<TablesOnNavigateToHomeScreenEvent>(navigateToHomeEvent);

    on<TablesOnShowNumberPickerEvent>(showNumberPickerEvent);

    on<TablesOnShowChangeTableDialogEvent>(showChangeTableDialogEvent);
  }

  Future<void> getTablesPassword(
    TablesOnGetPasswordsEvent event,
    Emitter<TablesState> emit,
  ) async {
    final syncTables = await syncTablesPasswordUseCase.call();
    final hasConnection = await InternetConnectionChecker().hasConnection;
    try {
      emit(TablesLoadingState());
      if (hasConnection) {
        syncTables;
        await fetchTablesPassword(emit);
      } else {
        await fetchTablesPassword(emit);
      }
    } catch (e) {
      emit(TablesErrorState(error: e.toString()));
    }
  }

  Future<void> fetchTablesPassword(Emitter<TablesState> emit) async {
    final tablesData = await tablesPasswordUseCase.call();
    switch (tablesData) {
      case SUCCESS():
        {
          final getTableNumber = await sharedPreferences.getTableNumber();
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

  Future<void> navigateToHomeEvent(
    TablesOnNavigateToHomeScreenEvent event,
    Emitter<TablesState> emit,
  ) async {
    emit(TablesNavigateToHomeScreenActionState());
  }

  Future<void> showNumberPickerEvent(
    TablesOnShowNumberPickerEvent event,
    Emitter<TablesState> emit,
  ) async {
    emit(TablesShowNumberPickerActionState());
  }

  Future<void> showChangeTableDialogEvent(
    TablesOnShowChangeTableDialogEvent event,
    Emitter<TablesState> emit,
  ) async {
    emit(TablesShowChangeTableDialogActionState());
  }

  Future<void> passwordSubmitEvent(
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
    List<TablesPasswordDto> tablesData,
    String tableNumber,
    String tablePassword,
  ) {
    for (var it in tablesData) {
      // print(
      //     '${it.tableNumber} and ${it.tablePassword} and $tablePassword and $tableNumber');
      if (it.tableNumber.toString() == tableNumber &&
          it.tablePassword == tablePassword) {
        sharedPreferences.setTableNumber(it.tableNumber);
        return true;
      }
    }
    return false;
  }
}
