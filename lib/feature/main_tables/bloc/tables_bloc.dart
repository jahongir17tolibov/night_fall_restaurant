import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:night_fall_restaurant/data/local/models/tables_password_dto.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_result.dart';
import 'package:night_fall_restaurant/domain/use_cases/sync_tables_password_use_case.dart';

import '../../../data/shared/shared_preferences.dart';
import '../../../domain/use_cases/tables_password_use_case.dart';

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
  }

  Future<void> getTablesPassword(
    TablesOnGetPasswordsEvent event,
    Emitter<TablesState> emit,
  ) async {
    final tablesData = await tablesPasswordUseCase.call();
    final syncTables = await syncTablesPasswordUseCase.call();
    final hasConnection = await InternetConnectionChecker().hasConnection;
    try {
      if (hasConnection) syncTables;
      switch (tablesData) {
        case SUCCESS():
          emit(TablesSuccessState(tablePasswords: tablesData.data));
          break;

        case FAILURE():
          emit(TablesErrorState(error: tablesData.exception.toString()));
          break;
      }
    } catch (e) {
      emit(TablesErrorState(error: e.toString()));
    }
  }
}
