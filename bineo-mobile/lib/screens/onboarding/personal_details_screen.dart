import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/app_validators.dart';
import 'package:bineo/common/consts.dart';
import 'package:bineo/screens/error_screen.dart';
import 'package:bineo/screens/onboarding/phone_input_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_form.dart';
import 'package:bineo/widgets/app_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalDetailsScreen extends StatefulWidget {
  PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  FocusNode emailInput = FocusNode();
  FocusNode confirmationEmailInput = FocusNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void verifyLocation(BuildContext context) {
    BlocProvider.of<OnboardingBloc>(context).add(
      const VerifyLocationEvent(),
    );
  }

  void continueOnboarding() {
    BlocProvider.of<OnboardingBloc>(context).add(
      SubmitPersonalDetailsEvent(
        username: nameController.text,
        email: emailController.text,
      ),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhoneInputScreen(),
      ),
    );
  }

  GestureRecognizer goToPrivacyNotice() {
    TapGestureRecognizer gestureRecognizer = TapGestureRecognizer();

    gestureRecognizer.onTap = () {
      launchUrl(Uri.parse(PRIVACY_POLICY_URL));
    };

    return gestureRecognizer;
  }

  GestureRecognizer goToTermsAndConditions() {
    TapGestureRecognizer gestureRecognizer = TapGestureRecognizer();

    gestureRecognizer.onTap = () {
      launchUrl(Uri.parse(TERMS_AND_CONDITIONS_URL));
    };

    return gestureRecognizer;
  }

  Widget renderTitle() {
    return Text(
      AppStrings.tellUsAboutYou,
      textAlign: TextAlign.start,
      style: AppStyles.heading2TextStyle,
    );
  }

  Widget renderSubtitle() {
    return Text(
      AppStrings.thisIsToCreateYourProfile,
      textAlign: TextAlign.start,
      style: AppStyles.body2MediumEmphasisTextStyle,
    );
  }

  Widget renderNameInput(BuildContext context) {
    return AppInput(
      controller: nameController,
      type: AppInputType.text,
      title: AppStrings.howDoYouLikeToBeCalled,
      subtitle: AppStrings.weWillCallYouByThisName,
      validator: AppValidators.requiredInput,
      textCapitalization: TextCapitalization.words,
      onSubmitted: (_) {
        emailInput.requestFocus();
      },
    );
  }

  Widget renderEmailInput(BuildContext context) {
    return AppInput(
      focusNode: emailInput,
      controller: emailController,
      type: AppInputType.email,
      title: AppStrings.email,
      subtitle: AppStrings.thisWillBeYourUser,
      validator: AppValidators.emailInput,
      // set state is necessary for next input
      onChanged: (text) => setState(() {}),
      onSubmitted: (text) {
        confirmationEmailInput.requestFocus();
      },
    );
  }

  Widget renderConfirmationEmailInput(
    BuildContext context,
  ) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
      return AppInput(
        focusNode: confirmationEmailInput,
        type: AppInputType.email,
        title: AppStrings.confirmYourEmail,
        validator: (text) {
          return AppValidators.confirmationEmailInput(
            text,
            emailController.text,
          );
        },
        onSubmitted: (_) {
          bool isValid = formKey.currentState!.validate();

          if (isValid) {
            verifyLocation(context);
          }
        },
      );
    });
  }

  Widget renderPrivacyAndTermsText() {
    return Align(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppStrings.toContinueAccept,
              style: AppStyles.body2HighEmphasisTextStyle,
            ),
            TextSpan(
              text: AppStrings.privacyNotice,
              style: AppStyles.body2PrimaryTextStyle,
              recognizer: goToPrivacyNotice(),
            ),
            TextSpan(
              text: AppStrings.andThe,
              style: AppStyles.body2HighEmphasisTextStyle,
            ),
            TextSpan(
              text: AppStrings.termsAndConditions,
              style: AppStyles.body2PrimaryTextStyle,
              recognizer: goToTermsAndConditions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderForm(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return AppForm(
          formKey: formKey,
          hideBackButton: true,
          topWidget: Container(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                renderTitle(),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  child: renderSubtitle(),
                ),
              ],
            ),
          ),
          submitButton: AppButton(
            isLoading: state.isVerifyingLocation,
            topWidget: Container(
              margin: const EdgeInsets.only(bottom: 26),
              child: renderPrivacyAndTermsText(),
            ),
            title: AppStrings.continueString,
            style: AppButtonStyle.primary,
            onTap: () => verifyLocation(context),
          ),
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: renderNameInput(context),
            ),
            renderEmailInput(context),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: renderConfirmationEmailInput(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        ErrorAllowedLocationsListener(),
        NotAllowedLocationListener(),
        LocationVerifiedListener(
            listener: (context, state) => continueOnboarding())
      ],
      child: renderForm(context),
    );
  }
}

class ErrorAllowedLocationsListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  ErrorAllowedLocationsListener({super.child})
      : super(
          listenWhen: (previous, current) {
            return !previous.hasErrorCheckingAllowedLocations &&
                current.hasErrorCheckingAllowedLocations;
          },
          listener: (context, state) {
            ErrorScreen.show(
              context,
              errorText: AppStrings.errorCheckingAllowedLocations,
              shouldExitApp: true,
            );
          },
        );
}

class NotAllowedLocationListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  NotAllowedLocationListener({super.child})
      : super(
          listenWhen: (previous, current) {
            return !previous.locationVerified &&
                current.locationVerified &&
                current.isNotAllowedLocation;
          },
          listener: (context, state) {
            ErrorScreen.show(
              context,
              errorText: AppStrings.locationIsNotAllowed,
              shouldExitApp: true,
            );
          },
        );
}

class LocationVerifiedListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  LocationVerifiedListener({required super.listener, super.child})
      : super(
          listenWhen: (previous, current) {
            return !previous.locationVerified && current.locationVerified;
          },
        );
}
