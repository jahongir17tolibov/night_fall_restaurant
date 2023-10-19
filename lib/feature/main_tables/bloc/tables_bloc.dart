import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_result.dart';
import 'package:night_fall_restaurant/feature/home/bloc/home_bloc.dart';

import '../../../data/remote/model/change_table_model.dart';
import '../../../domain/use_cases/change_table_use_case.dart';

part 'tables_event.dart';

part 'tables_state.dart';

class TablesBloc extends Bloc<TablesEvent, TablesState> {
  final ChangeTableUseCase changeTableUseCase;

  TablesBloc({required this.changeTableUseCase}) : super(TablesLoadingState()) {
    on<TablesOnGetPasswordsEvent>(getTablesPassword);
  }

  Future<void> getTablesPassword(
    TablesOnGetPasswordsEvent event,
    Emitter<TablesState> emit,
  ) async {
    final tables = await changeTableUseCase.call();
    try {
      switch (tables) {
        case SUCCESS():
          emit(TablesSuccessState(tablePasswords: tables.data));
          break;

        case FAILURE():
          emit(TablesErrorState(error: tables.exception.toString()));
      }
    } catch (e) {
      emit(TablesErrorState(error: e.toString()));
    }
  }
}
