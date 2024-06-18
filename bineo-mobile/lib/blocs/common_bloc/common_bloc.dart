import 'package:bineo/apis/bineo_api.dart';
import 'package:bineo/apis/renapo/renapo_api.dart';
import 'package:bineo/blocs/common_bloc/common_event.dart';
import 'package:bineo/blocs/common_bloc/common_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommonBloc extends Bloc<CommonEvent, CommonState> {
  CommonBloc() : super(CommonState()) {
    on<InitAPIEvent>((event, emit) async {
      try {
        await BineoAPI.instance.initialize();
        await RenapoAPI.instance.initialize();
      } catch (error) {
        print('Init API error: $error');
      }
    });
  }
}
