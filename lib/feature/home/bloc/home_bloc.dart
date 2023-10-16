import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/remote/model/get_menu_list_response.dart';
import '../../../domain/use_cases/get_menu_list_use_case.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMenuListUseCase getMenuListUseCase;

  HomeBloc(this.getMenuListUseCase) : super(HomeLoadingState()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
