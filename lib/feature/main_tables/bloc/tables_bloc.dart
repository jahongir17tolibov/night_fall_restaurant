import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:night_fall_restaurant/data/local/entities/tables_password_dto.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_result.dart';
import 'package:night_fall_restaurant/domain/use_cases/sync_tables_password_use_case.dart';

import '../../../data/shared/shared_preferences.dart';
import '../../../domain/use_cases/tables_password_use_case.dart';
import '../../../utils/ui_components/show_snack_bar.dart';

part 'tables_event.dart';

part 'tables_state.dart';

class TablesBloc extends Bloc<TablesEvent, TablesState> {
  final SyncTablesPasswordUseCase syncTablesPasswordUseCase;
  final TablesPasswordUseCase tablesPasswordUseCase;
  final AppSharedPreferences sharedPreferences;

  TablesBloc({
    required this.tablesPasswordUseCase,
    required this.syncTablesPasswordUseCase,
    required this.sharedPreferences,
  }) : super(TablesLoadingState()) {
    on<TablesOnGetPasswordsEvent>(getTablesPassword);

    on<TablesOnPasswordSubmitEvent>(getPasswordSubmit);

    on<TablesOnChangeTextFieldEvent>(onChangeTextField);
  }

  TextEditingController controller = TextEditingController();

  Future<void> onChangeTextField(
    TablesOnChangeTextFieldEvent event,
    Emitter<TablesState> emit,
  ) async {
    if (controller.text.length > 12) {
      showSnackBar(
        'the length of the password should not be less than 10 characters',
        event.context,
      );
    }
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

  Future<void> getPasswordSubmit(
    TablesOnPasswordSubmitEvent event,
    Emitter<TablesState> emit,
  ) async {
    final tablesData = await tablesPasswordUseCase.call();
    switch (tablesData) {
      case SUCCESS():
        {
          final isValid = checkPasswords(
            tablesData.data,
            event.tableNumber,
            event.password,
          );
          final getNewTablesNumber = await sharedPreferences.getTableNumber();
          if (isValid) {
            emit(TablesValidPasswordState(
              'Valid password and $getNewTablesNumber',
            ));
            // get new value from sharedPrefs
            emit(TablesSuccessState(
              tablePasswords: tablesData.data,
              tableNumber: getNewTablesNumber.toString(),
            ));
          } else {
            emit(TablesInValidPasswordState(
              "Invalid table number or password",
            ));
            // get old value from sharedPrefs
            emit(TablesSuccessState(
              tablePasswords: tablesData.data,
              tableNumber: getNewTablesNumber.toString(),
            ));
          }
        }
        break;

      case FAILURE():
        emit(TablesErrorState(error: tablesData.exception.toString()));
        break;
    }
  }

  bool checkPasswords(
    List<TablesPasswordDto> tablesData,
    String tableNumber,
    String tablePassword,
  ) {
    for (var it in tablesData) {
      if (it.tableNumber.toString().contains(tableNumber) &&
          it.tablePassword.contains(tablePassword)) {
        sharedPreferences.setTableNumber(it.tableNumber);
        return true;
      }
    }
    return false;
  }
}
