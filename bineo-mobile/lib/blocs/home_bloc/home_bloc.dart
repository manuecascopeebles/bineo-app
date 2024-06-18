import 'dart:developer';

import 'package:bineo/apis/fionner/fionner_api.dart';
import 'package:bineo/blocs/home_bloc/home_event.dart';
import 'package:bineo/blocs/home_bloc/home_state.dart';
import 'package:bineo/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FionnerAPI _fionner = FionnerAPI.instance;
  User user;

  HomeBloc(this.user) : super(HomeState(user: user)) {
    on<InitializeHomeBlocEvent>((event, emit) {
      add(RefreshBalanceEvent());
    });

    on<RefreshBalanceEvent>((event, emit) async {
      emit(state.copyWith(isRefreshingBalance: true));
      try {
        final balance = await _fionner.getBalance(user.customerId);

        emit(state.copyWith(balance: balance, isRefreshingBalance: false));
      } catch (e) {
        log('Error RefreshBalanceEvent: $e');
        emit(state.copyWith(
            hasErrorGettingBalance: true, isRefreshingBalance: false));
      }
    });
  }
}
