import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CommonEvent extends Equatable {
  const CommonEvent();
}

class InitAPIEvent extends CommonEvent {
  @override
  List<Object?> get props => [];

  const InitAPIEvent();
}
