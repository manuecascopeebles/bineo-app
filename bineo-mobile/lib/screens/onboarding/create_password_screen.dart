import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/app_validators.dart';
import 'package:bineo/common/password.dart';
import 'package:bineo/screens/error_screen.dart';
import 'package:bineo/screens/onboarding/congratulations_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_form.dart';
import 'package:bineo/widgets/app_input.dart';
import 'package:bineo/widgets/onboarding/password_strength_indicator.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  late Password password;
  String confirmationPassword = '';

  FocusNode confirmationPasswordNode = FocusNode();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    OnboardingBloc bloc = BlocProvider.of<OnboardingBloc>(context);

    password = Password(
      '',
      name: bloc.state.username,
      clientNumber: bloc.state.clientNumber ?? 0,
    );
  }

  void submitPassword() {
    BlocProvider.of<OnboardingBloc>(context).add(
      CreatePasswordEvent(password.password),
    );
  }

  Widget renderTitle() {
    return Text(
      AppStrings.bulletproofYourAppAccess,
      style: AppStyles.heading2TextStyle,
    );
  }

  Widget renderSubtitle() {
    return Text(
      AppStrings.createYourPassword,
      style: AppStyles.body2MediumEmphasisTextStyle,
    );
  }

  Widget renderRuleState({
    required bool isFulfilled,
  }) {
    return SVGs.getSVG(
      svg: SVGs.success,
      color: isFulfilled
          ? AppStyles.successColor
          : AppStyles.textMediumEmphasisColor,
    );
  }

  Widget renderRule({
    required String text,
    required bool isFulfilled,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        renderRuleState(
          isFulfilled: isFulfilled && password.password.isNotEmpty,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15),
            child: Text(
              text,
              style: AppStyles.body2MediumEmphasisTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget renderRules() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Text(
            AppStrings.considerTheFollowing,
            style: AppStyles.body2HighEmphasisTextStyle,
          ),
        ),
        renderRule(
          text: AppStrings.include8To12Characters,
          isFulfilled: password.hasValidLength,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: renderRule(
            text: AppStrings.includeNumberAndSymbol,
            isFulfilled: password.hasNumber && password.hasSymbol,
          ),
        ),
        renderRule(
          text: AppStrings.useUpperAndLowerCase,
          isFulfilled:
              password.hasUppercaseLetter && password.hasLowercaseLetter,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: renderRule(
            text: AppStrings.dontIncludeConsecutiveCaracters,
            isFulfilled: !password.has3ConsecutiveEqualCharacters &&
                !password.has3ConsecutiveNumbers &&
                !password.has3ConsecutiveLowercaseLetters &&
                !password.has3ConsecutiveUppercaseLetters,
          ),
        ),
        renderRule(
          text: AppStrings.dontUseNameOrBineo,
          isFulfilled: !password.hasBineoString &&
              !password.hasName &&
              !password.hasClientNumber,
        ),
      ],
    );
  }

  Widget renderPasswordInput() {
    return AppInput(
      controller: passwordController,
      maxLength: 12,
      type: AppInputType.password,
      title: AppStrings.writeYourPassword,
      validator: AppValidators.requiredInput,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      onChanged: (text) {
        setState(() {
          password.password = text;
        });
      },
      onSubmitted: (_) {
        confirmationPasswordNode.requestFocus();
      },
    );
  }

  Widget renderStrengthIndicator() {
    return PasswordStrengthIndicator(password: password);
  }

  Widget renderConfirmationInput() {
    return AppInput(
      focusNode: confirmationPasswordNode,
      type: AppInputType.password,
      maxLength: 12,
      title: AppStrings.confirmYourPassword,
      validator: (text) {
        return AppValidators.confirmationPasswordInput(
          text,
          passwordController.text,
        );
      },
      textCapitalization: TextCapitalization.none,
      onChanged: (text) {
        setState(() {
          confirmationPassword = text;
        });
      },
      onSubmitted: (_) {
        bool isValid = formKey.currentState!.validate();

        if (isValid) {
          submitPassword();
        }
      },
    );
  }

  AppButton renderSubmitButton({
    bool isLoading = false,
  }) {
    return AppButton(
      title: AppStrings.done,
      onTap: submitPassword,
      enabled: password.isValid,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _SubmissionErrorListener(),
        _SubmissionSuccessListener(),
      ],
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return AppForm(
            formKey: formKey,
            hideBackButton: false,
            hasFloatingButton: true,
            submitButton: renderSubmitButton(
              isLoading: state.isCreatingPassword,
            ),
            children: [
              renderTitle(),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 25),
                child: renderSubtitle(),
              ),
              renderRules(),
              Container(
                margin: const EdgeInsets.only(
                  top: 35,
                  bottom: 8,
                ),
                child: renderPasswordInput(),
              ),
              renderStrengthIndicator(),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: renderConfirmationInput(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SubmissionErrorListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  _SubmissionErrorListener()
      : super(
          listenWhen: (previous, current) {
            return !previous.hasErrorCreatingPassword &&
                current.hasErrorCreatingPassword;
          },
          listener: (context, state) {
            if (state.hasErrorCreatingPassword) {
              ErrorScreen.show(
                context,
                errorText: AppStrings.createPasswordError,
                shouldExitApp: false,
              );
            }
          },
        );
}

class _SubmissionSuccessListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  _SubmissionSuccessListener()
      : super(
          listenWhen: (previous, current) {
            return !previous.passwordCreated && current.passwordCreated;
          },
          listener: (context, state) {
            if (state.passwordCreated) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => CongratulationsScreen(),
                ),
                (route) => false,
              );
            }
          },
        );
}
