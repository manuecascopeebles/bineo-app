import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class InitializeHomeBlocEvent extends HomeEvent {
  @override
  List<Object?> get props => [];

  const InitializeHomeBlocEvent();
}

class RefreshBalanceEvent extends HomeEvent {
  @override
  List<Object?> get props => [];

  const RefreshBalanceEvent();
}
