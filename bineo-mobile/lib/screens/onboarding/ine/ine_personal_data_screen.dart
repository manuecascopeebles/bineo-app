import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_router.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/app_validators.dart';
import 'package:bineo/common/consts.dart';
import 'package:bineo/common/countries_list.dart';
import 'package:bineo/helpers/form_validator_helper.dart';
import 'package:bineo/models/curp.dart';
import 'package:bineo/models/ine.dart';
import 'package:bineo/screens/error_screen.dart';
import 'package:bineo/screens/onboarding/ine/ine_address_data_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_checkbox.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:bineo/widgets/app_dropdown.dart';
import 'package:bineo/widgets/app_form.dart';
import 'package:bineo/widgets/app_input.dart';
import 'package:bineo/widgets/app_switch.dart';
import 'package:bineo/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class INEPersonalDataScreen extends StatefulWidget {
  const INEPersonalDataScreen({
    super.key,
    required this.ine,
  });

  final INE ine;

  @override
  State<INEPersonalDataScreen> createState() => _INEPersonalDataScreenState();
}

class _INEPersonalDataScreenState extends State<INEPersonalDataScreen> {
  late INE ine;
  bool hasConfirmedData = false;
  late bool hasSecondSurname;
  TextEditingController secondSurnameController = TextEditingController();

  @override
  void initState() {
    ine = widget.ine;
    hasSecondSurname = ine.hasCapturedSecondSurname;

    super.initState();
  }

  void openHelp() async {
    if (await canLaunchUrl(Uri.parse(HELP_URL))) {
      await launchUrl(Uri.parse(HELP_URL),
          mode: LaunchMode.externalNonBrowserApplication);
    }
  }

  void showIneInvalidDialog(String title, String message, String buttonText) {
    AppDialog.showMessage(
      title,
      message,
      [
        NativeDialogPlusAction(
          text: '${AppStrings.check} $buttonText',
          onPressed: () {},
        ),
        NativeDialogPlusAction(
          text: AppStrings.scanINEAgain,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        NativeDialogPlusAction(
          text: AppStrings.help,
          onPressed: openHelp,
          style: NativeDialogPlusActionStyle.cancel,
        ),
      ],
    );
  }

  Future<bool> validateIne(INE ocrIne, INE formIne) async {
    bool isValid = await FormValidatorHelper.levenshtein(
      ocrIne.name,
      formIne.name,
      0.5,
    );

    if (!isValid) {
      showIneInvalidDialog(
        AppStrings.checkName,
        AppStrings.checkNameErrorMessage,
        AppStrings.name,
      );

      return false;
    }
    isValid = await FormValidatorHelper.levenshtein(
        ocrIne.firstSurname, formIne.firstSurname, 0.5);
    if (!isValid) {
      showIneInvalidDialog(
        AppStrings.checkSurname,
        AppStrings.checkSurnameErrorMessage,
        AppStrings.surname.toLowerCase(),
      );

      return false;
    }
    if (ocrIne.secondSurname == null || ocrIne.secondSurname!.isEmpty)
      return true;
    isValid = await FormValidatorHelper.levenshtein(
        ocrIne.secondSurname!, formIne.secondSurname!, 0.5);

    if (!isValid) {
      showIneInvalidDialog(
        AppStrings.checkSecondSurname,
        AppStrings.checkSecondSurnameErrorMessage,
        AppStrings.secondSurname.toLowerCase(),
      );

      return false;
    }

    return isValid;
  }

  void validatePersonalData() async {
    INE ocrIne = BlocProvider.of<OnboardingBloc>(context).state.ine!;
    bool isFormValid = await validateIne(ocrIne, ine);

    if (isFormValid) {
      BlocProvider.of<OnboardingBloc>(context).add(
        ValidatePersonalDataEvent(ine),
      );
    }
  }

  Widget renderTitle() {
    return Text(
      AppStrings.isYourDataAccurate,
      style: AppStyles.heading2TextStyle,
    );
  }

  Widget renderSubtitle() {
    return Text(
      AppStrings.dataHasToMatchINE,
      style: AppStyles.body2MediumEmphasisTextStyle,
    );
  }

  Widget renderCardImage() {
    return Images.getImage(
      image: Images.inePersonalData,
      width: 192,
    );
  }

  Widget renderNameInput() {
    return AppInput(
      type: AppInputType.text,
      title: AppStrings.nameS,
      textCapitalization: TextCapitalization.words,
      initialValue: ine.name,
      validator: AppValidators.requiredInput,
      onChanged: (name) {
        setState(
          () => ine.name = name,
        );
      },
    );
  }

  Widget renderFirstSurnameInput() {
    return AppInput(
      type: AppInputType.text,
      title: AppStrings.firstSurname,
      textCapitalization: TextCapitalization.words,
      initialValue: ine.firstSurname,
      validator: AppValidators.requiredInput,
      onChanged: (firstSurname) {
        setState(
          () => ine.firstSurname = firstSurname,
        );
      },
    );
  }

  Widget renderSecondSurnameInput() {
    return Column(
      children: [
        AppInput(
          type: AppInputType.text,
          title: AppStrings.secondSurname,
          textCapitalization: TextCapitalization.words,
          controller: secondSurnameController,
          initialValue: ine.secondSurname ?? '',
          placeholder: !hasSecondSurname ? AppStrings.noSecondSurname : null,
          isEnabled: hasSecondSurname,
          validator: AppValidators.requiredInput,
          onChanged: (secondSurname) {
            setState(
              () => ine.secondSurname = secondSurname,
            );
          },
        ),
        if (!ine.hasCapturedSecondSurname)
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: AppSwitch(
              value: hasSecondSurname,
              text: AppStrings.hasSecondSurname,
              onChanged: (bool) {
                setState(() {
                  hasSecondSurname = bool;
                  if (!bool) {
                    ine.secondSurname = null;
                    secondSurnameController.text = '';
                  }
                });
              },
            ),
          ),
      ],
    );
  }

  Widget renderCurpInput() {
    return AppInput(
      type: AppInputType.text,
      textCapitalization: TextCapitalization.characters,
      title: AppStrings.curp,
      initialValue: ine.curp?.value ?? '',
      validator: AppValidators.curpInput,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-ZÑ0-9]')),
      ],
      onChanged: (curp) {
        setState(
          () => ine.curp = Curp(curp),
        );
      },
    );
  }

  Widget renderBirthCountryDropdown() {
    if (!ine.isForeigner) {
      return Container();
    }

    List<String> countriesList = CountriesList.countriesList;

    if (widget.ine.birthCountry != null &&
        widget.ine.birthCountry!.isNotEmpty &&
        !countriesList.contains(widget.ine.birthCountry)) {
      countriesList.add(widget.ine.birthCountry!);
      countriesList.sort((a, b) => a.compareTo(b));
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: AppDropdown<String>(
        title: AppStrings.birthCountry,
        value: ine.birthCountry ?? CountriesList.mexico,
        items: countriesList,
        onChanged: (country) {
          if (country != null) {
            setState(() => ine.birthCountry = country);
          }
        },
      ),
    );
  }

  Widget renderRfcInput() {
    return AppInput(
      type: AppInputType.text,
      title: AppStrings.rfc,
      initialValue: ine.rfc,
      validator: AppValidators.requiredInput,
      onChanged: (rfc) {
        setState(
          () => ine.rfc = rfc,
        );
      },
    );
  }

  Widget renderConfirmCheckbox() {
    return Column(
      children: [
        AppCheckbox(
          value: hasConfirmedData,
          text: AppStrings.dataIsCorrect,
          onChanged: (bool) {
            setState(() {
              hasConfirmedData = bool;
            });
          },
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          child: Text(
            AppStrings.makeSureDataIsCorrect,
            style: AppStyles.overline1TextStyle,
          ),
        ),
      ],
    );
  }

  AppButton renderSubmitButton({
    bool isLoading = false,
  }) {
    return AppButton(
      title: AppStrings.continueString,
      onTap: validatePersonalData,
      enabled: ine.hasPersonalData && hasConfirmedData,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _CURPRegisteredListener(),
        _RenapoInvalidListener(),
        _INEPersonalDataValidatedListener(ine: ine),
      ],
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return AppForm(
            validateOnRender: true,
            hideBackButton: false,
            hasFloatingButton: false,
            submitButton: renderSubmitButton(
              isLoading: state.isValidatingPersonalData,
            ),
            children: [
              renderTitle(),
              renderSubtitle(),
              renderCardImage(),
              renderNameInput(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: renderFirstSurnameInput(),
              ),
              renderSecondSurnameInput(),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: renderCurpInput(),
              ),
              renderBirthCountryDropdown(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: renderRfcInput(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: renderConfirmCheckbox(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CURPRegisteredListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  _CURPRegisteredListener()
      : super(
          listenWhen: (previous, current) {
            return previous.isCurpValid && !current.isCurpValid;
          },
          listener: (context, state) {
            AppDialog.showMessage(
              AppStrings.curpRegistered,
              AppStrings.curpRegisteredDescription,
              [
                NativeDialogPlusAction(
                  text: AppStrings.login,
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                      AppRouter.initialRoute,
                    );
                  },
                )
              ],
            );
          },
        );
}

class _RenapoInvalidListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  _RenapoInvalidListener()
      : super(
          listenWhen: (previous, current) {
            return previous.isValidatingPersonalData &&
                !current.isValidatingPersonalData &&
                !current.isRenapoValid;
          },
          listener: (context, state) {
            ErrorScreen.show(
              context,
              shouldExitApp: true,
              errorText: AppStrings.renapoInvalidError,
            );
          },
        );
}

class _INEPersonalDataValidatedListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  _INEPersonalDataValidatedListener({
    required INE ine,
  }) : super(
          listenWhen: (previous, current) {
            return !previous.inePersonalDataValidated &&
                current.inePersonalDataValidated;
          },
          listener: (context, state) {
            if (state.inePersonalDataValidated &&
                state.isCurpValid &&
                state.isRenapoValid) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => INEAddressDataScreen(
                    ine: state.ine!.copy(),
                  ),
                ),
              );
            }
          },
        );
}
