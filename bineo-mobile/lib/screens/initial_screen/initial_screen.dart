import 'package:bineo/blocs/auth_bloc/auth_bloc.dart';
import 'package:bineo/blocs/auth_bloc/auth_event.dart';
import 'package:bineo/blocs/auth_bloc/auth_state.dart';
import 'package:bineo/screens/initial_screen/no_session_screen.dart';
import 'package:bineo/screens/sign_in/sign_in_screen.dart';
import 'package:bineo/widgets/app_activity_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(InitializeBlocEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          previous.isLoadingSession != current.isLoadingSession,
      builder: (context, state) {
        if (state.isLoadingSession) {
          return const Scaffold(body: Center(child: AppActivityIndicator()));
        }
        if (state.session != null) {
          return SignInScreen();
        }
        return NoSessionScreen();
      },
    );
  }
}
