import 'package:bineo/blocs/auth_bloc/auth_bloc.dart';
import 'package:bineo/blocs/auth_bloc/auth_event.dart';
import 'package:bineo/blocs/auth_bloc/auth_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/app_validators.dart';
import 'package:bineo/screens/register_device/verify_identity_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:bineo/widgets/app_form.dart';
import 'package:bineo/widgets/app_input.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterDeviceSignInScreen extends StatefulWidget {
  RegisterDeviceSignInScreen({super.key});

  @override
  State<RegisterDeviceSignInScreen> createState() =>
      _RegisterDeviceSignInScreenState();
}

class _RegisterDeviceSignInScreenState
    extends State<RegisterDeviceSignInScreen> {
  FocusNode passwordInput = FocusNode();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void continueSignIn() {
    final phoneNumber =
        BlocProvider.of<AuthBloc>(context).state.session!.user.phoneNumber;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => VerifyIdentityScreen(
          phoneNumber: phoneNumber,
        ),
      ),
    );
  }

  Widget renderLogo() {
    return SVGs.getSVG(
      svg: SVGs.logo,
    );
  }

  void showSignInError(BuildContext context) {
    AppDialog.showMessage(
      AppStrings.signInError,
      AppStrings.signInErrorDescription,
      [
        NativeDialogPlusAction(
          text: AppStrings.okay,
          onPressed: () {},
        )
      ],
    );
  }

  void signIn() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInEvent(
          email: emailController.text,
          password: passwordController.text,
        ),
      );
    }
  }

  void forgotPassword() {
    // TODO implement
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        SessionListener(listener: (context, state) => continueSignIn()),
        SignInErrorListener(listener: (context, state) {
          showSignInError(context);
        }),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return AppForm(
            hideBackButton: false,
            submitButton: AppButton(
              isLoading: state.isSigningIn,
              title: AppStrings.enter,
              onTap: signIn,
            ),
            formKey: formKey,
            children: [
              renderLogo(),
              SizedBox(height: 40),
              Center(
                child: Text(
                  AppStrings.welcomeText,
                  style: AppStyles.body1TextStyle,
                ),
              ),
              SizedBox(height: 40),
              AppInput(
                type: AppInputType.email,
                controller: emailController,
                title: AppStrings.user,
                validator: AppValidators.emailInput,
                onSubmitted: (_) {
                  passwordInput.requestFocus();
                },
              ),
              SizedBox(height: 24),
              AppInput(
                type: AppInputType.password,
                controller: passwordController,
                title: AppStrings.password,
                focusNode: passwordInput,
                validator: AppValidators.requiredInput,
                onSubmitted: (_) {
                  signIn();
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: AppButton(
                  title: AppStrings.forgotPassword,
                  style: AppButtonStyle.secondaryDark,
                  onTap: forgotPassword,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class SessionListener extends BlocListener<AuthBloc, AuthState> {
  SessionListener({required super.listener, super.child})
      : super(
          listenWhen: (previous, current) {
            return previous.isSigningIn &&
                !current.isSigningIn &&
                current.session != null;
          },
        );
}

class SignInErrorListener extends BlocListener<AuthBloc, AuthState> {
  SignInErrorListener({required super.listener, super.child})
      : super(
          listenWhen: (previous, current) {
            return !previous.hasSignInError && current.hasSignInError;
          },
        );
}
