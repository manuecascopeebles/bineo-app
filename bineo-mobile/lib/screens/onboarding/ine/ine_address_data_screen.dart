import 'dart:io';

import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/app_validators.dart';
import 'package:bineo/helpers/form_validator_helper.dart';
import 'package:bineo/models/ine.dart';
import 'package:bineo/models/zip_code.dart';
import 'package:bineo/screens/error_screen.dart';
import 'package:bineo/screens/onboarding/card_customization_screen.dart';
import 'package:bineo/screens/success_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_checkbox.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:bineo/widgets/app_dropdown.dart';
import 'package:bineo/widgets/app_form.dart';
import 'package:bineo/widgets/app_input.dart';
import 'package:bineo/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class INEAddressDataScreen extends StatefulWidget {
  const INEAddressDataScreen({
    super.key,
    required this.ine,
  });

  final INE ine;

  @override
  State<INEAddressDataScreen> createState() => _INEAddressDataScreenState();
}

class _INEAddressDataScreenState extends State<INEAddressDataScreen> {
  late INE ine;
  String otherColony = '';
  bool hasConfirmedData = false;
  bool postalCodeHasFocus = false;
  late String fullPostalCode;
  final TextEditingController postalCodeController = TextEditingController();
  FocusNode postalCodeFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    ine = widget.ine;
    fullPostalCode = widget.ine.address.postalCode;
    postalCodeFocus.addListener(() {
      onChangePostalCodeFocus(postalCodeFocus.hasFocus);
    });
  }

  void onChangePostalCodeFocus(bool hasFocus) {
    OnboardingBloc bloc = BlocProvider.of<OnboardingBloc>(context);

    if (!hasFocus) {
      if (ine.address.postalCode.length < 5) {
        setState(() {
          ine.address.postalCode = fullPostalCode;
          postalCodeController.text = fullPostalCode;
        });
      } else {
        bloc.add(ReloadColoniesEvent(ine.address.postalCode));
      }
    }
  }

  Future<void> validateAddressData() async {
    INE ineCopy = ine.copy();
    INE ocrIne = BlocProvider.of<OnboardingBloc>(context).state.ine!;

    if (otherColony.isNotEmpty) {
      ineCopy.address.colony = otherColony;
    }

    bool isFormValid = await validateIne(ocrIne, ineCopy);

    if (isFormValid) {
      BlocProvider.of<OnboardingBloc>(context).add(
        ValidateAddressDataEvent(ineCopy),
      );
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
          style: NativeDialogPlusActionStyle.cancel,
        ),
      ],
    );
  }

  Future<bool> validateIne(INE ocrIne, INE formIne) async {
    bool streetExists = formIne.address.street?.isNotEmpty ?? false;
    bool extNoExists = formIne.address.exteriorNumber?.isNotEmpty ?? false;

    bool isValid = await FormValidatorHelper.levenshtein(
          "${(ocrIne.address.street ?? '')} ${(ocrIne.address.exteriorNumber ?? '')} ${(ocrIne.address.interiorNumber ?? '')}",
          "${(formIne.address.street ?? '')} ${(formIne.address.exteriorNumber ?? '')} ${(formIne.address.interiorNumber ?? '')}",
          0.5,
        ) &&
        streetExists &&
        extNoExists;

    if (!isValid) {
      showIneInvalidDialog(
        AppStrings.checkAddress,
        AppStrings.checkAddressErrorMessage,
        AppStrings.address,
      );

      return false;
    }
    isValid = await FormValidatorHelper.levenshtein(
        ocrIne.address.postalCode, formIne.address.postalCode, 0.5);

    if (!isValid) {
      showIneInvalidDialog(
        AppStrings.checkPostalCode,
        AppStrings.checkPostalCodeErrorMessage,
        AppStrings.postalCode.toLowerCase(),
      );

      return false;
    }

    return isValid;
  }

  Widget renderTitle() {
    return Text(
      AppStrings.isYourAddressAccurate,
      style: AppStyles.heading2TextStyle,
    );
  }

  Widget renderSubtitle() {
    return Text(
      ine.address.hasCapturedAddressData
          ? AppStrings.dataHasToMatchINE
          : AppStrings.addMissingAddress,
      style: AppStyles.body2MediumEmphasisTextStyle,
    );
  }

  Widget renderCardImage() {
    return Images.getImage(
      image: Images.ineAddressData,
      width: 192,
    );
  }

  Widget renderCardImageSubtitle() {
    return Text(
      AppStrings.canChooseMailingAddressLater,
      style: AppStyles.body2HighEmphasisTextStyle,
    );
  }

  Widget renderStreetInput() {
    return AppInput(
      type: AppInputType.text,
      title: AppStrings.street,
      subtitle: AppStrings.streetExcludeAddressNumbers,
      textCapitalization: TextCapitalization.words,
      initialValue: ine.address.street ?? '',
      validator: AppValidators.requiredInput,
      onChanged: (street) {
        setState(
          () => ine.address.street = street,
        );
      },
    );
  }

  Widget renderExteriorNumberInput() {
    return AppInput(
      type: AppInputType.text,
      title: AppStrings.exteriorNumber,
      textCapitalization: TextCapitalization.words,
      initialValue: ine.address.exteriorNumber ?? '',
      validator: AppValidators.requiredInput,
      onChanged: (exteriorNumber) {
        setState(
          () => ine.address.exteriorNumber = exteriorNumber,
        );
      },
    );
  }

  Widget renderInteriorNumberInput() {
    return AppInput(
      type: AppInputType.text,
      title: AppStrings.optionalInteriorNumber,
      textCapitalization: TextCapitalization.words,
      initialValue: '',
      onChanged: (interiorNumber) {
        setState(
          () => ine.address.interiorNumber = interiorNumber,
        );
      },
    );
  }

  Widget renderAddressNumbersSubtitle() {
    return Text(
      AppStrings.addressNumbersSubtitle,
      style: AppStyles.overline1TextStyle,
    );
  }

  Widget renderPostalCodeInput() {
    return AppInput(
      maxLength: 5,
      controller: postalCodeController,
      type: AppInputType.numeric,
      title: AppStrings.postalCode,
      initialValue: ine.address.postalCode,
      validator: AppValidators.requiredInput,
      focusNode: postalCodeFocus,
      onChanged: (postalCode) {
        setState(
          () => ine.address.postalCode = postalCode,
        );
      },
    );
  }

  Widget renderColonyDropdown(OnboardingState state) {
    List<String> colonies = [...state.zipCode?.neighborhoods ?? []];

    colonies.add(AppStrings.other);

    String value =
        ine.address.colony.isNotEmpty ? ine.address.colony : colonies.first;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: AppDropdown<String>(
            title: AppStrings.colony,
            isLoading: state.isReloadingColonies,
            value: value,
            items: colonies,
            onChanged: (colony) {
              if (colony != null) {
                setState(() {
                  if (ine.address.colony != colony) {
                    otherColony = '';
                  }
                  ine.address.colony = colony;
                });
              }
            },
          ),
        ),
        if (value == AppStrings.other)
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: AppInput(
              type: AppInputType.text,
              title: AppStrings.enterYourColony,
              textCapitalization: TextCapitalization.words,
              onChanged: (text) {
                setState(() => otherColony = text);
              },
            ),
          ),
      ],
    );
  }

  Widget renderMunicipalityInput() {
    return AppInput(
      type: AppInputType.text,
      title: AppStrings.municipality,
      initialValue: ine.address.municipality,
      validator: AppValidators.requiredInput,
      isEnabled: false,
    );
  }

  Widget renderStateInput() {
    return AppInput(
      type: AppInputType.text,
      title: AppStrings.state,
      initialValue: ine.address.state?.name ?? '',
      validator: AppValidators.requiredInput,
      isEnabled: false,
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

  AppButton renderSubmitButton(OnboardingState state) {
    return AppButton(
      title: AppStrings.continueString,
      onTap: validateAddressData,
      enabled: ine.address.hasAddressData &&
          hasConfirmedData &&
          !state.hasErrorReloadingColonies &&
          (ine.address.colony == AppStrings.other
              ? otherColony.isNotEmpty
              : true),
      isLoading: state.isValidatingAddressData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Platform.isAndroid,
      child: MultiBlocListener(
        listeners: [
          _PersonalDataNotVerifiedListener(),
          _BlackListedListener(),
          _PersonalDataErrorListener(),
          _INEAddressDataValidatedListener(),
          _ZipCodeReloadedListener(
            onReloadZipCode: (zipCode) {
              if (zipCode == null) {
                setState(() {
                  ine.address.colony = '';
                  fullPostalCode = postalCodeController.text;
                });
              } else {
                setState(() {
                  fullPostalCode = zipCode.zipcode;
                  postalCodeController.text = zipCode.zipcode;
                  ine.address.colony = zipCode.neighborhoods.length > 0
                      ? zipCode.neighborhoods.first
                      : '';
                });
              }
            },
          ),
        ],
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return AppForm(
              validateOnRender: true,
              hideBackButton: false,
              hasFloatingButton: false,
              submitButton: renderSubmitButton(state),
              children: [
                renderTitle(),
                renderSubtitle(),
                renderCardImage(),
                renderCardImageSubtitle(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: renderStreetInput(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: (constraints.maxWidth - 20) * 0.5,
                            child: renderExteriorNumberInput(),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: (constraints.maxWidth - 20) * 0.5,
                            child: renderInteriorNumberInput(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 6, bottom: 20),
                  child: renderAddressNumbersSubtitle(),
                ),
                renderPostalCodeInput(),
                renderColonyDropdown(state),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: renderMunicipalityInput(),
                ),
                renderStateInput(),
                Container(
                  margin: const EdgeInsets.only(
                    top: 40,
                    bottom: 20,
                  ),
                  child: renderConfirmCheckbox(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PersonalDataNotVerifiedListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  _PersonalDataNotVerifiedListener()
      : super(
          listenWhen: (previous, current) {
            return !previous.isReviewingPersonalData &&
                current.isReviewingPersonalData;
          },
          listener: (context, state) {
            ErrorScreen.show(
              context,
              errorText: AppStrings.ineOnboardUnderReviewError,
              shouldExitApp: true,
            );
          },
        );
}

class _BlackListedListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  _BlackListedListener()
      : super(
          listenWhen: (previous, current) {
            return !previous.isblackListed && current.isblackListed;
          },
          listener: (context, state) {
            ErrorScreen.show(
              context,
              errorText: AppStrings.ineOnboardBlackListedError,
              shouldExitApp: true,
            );
          },
        );
}

class _PersonalDataErrorListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  _PersonalDataErrorListener()
      : super(
          listenWhen: (previous, current) {
            return !previous.hasPersonalDataError &&
                current.hasPersonalDataError;
          },
          listener: (context, state) {
            AppDialog.showMessage(
              AppStrings.somethingWentWrong,
              AppStrings.pleaseTryAgain,
              [
                NativeDialogPlusAction(
                  text: AppStrings.okay,
                  onPressed: () {},
                )
              ],
            );
          },
        );
}

class _INEAddressDataValidatedListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  _INEAddressDataValidatedListener()
      : super(
          listenWhen: (previous, current) {
            return !previous.ineAddressDataValidated &&
                current.ineAddressDataValidated;
          },
          listener: (context, state) {
            if (state.ineAddressDataValidated &&
                !state.hasPersonalDataError &&
                !state.isblackListed &&
                !state.isReviewingPersonalData) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (routeContext) => SuccessScreen(
                    showCloseButton: false,
                    title: '${AppStrings.ineFinishedTitle}${state.username}!',
                    description: AppStrings.ineFinishedDescription,
                    onClose: () {
                      Navigator.of(routeContext).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => CardCustomizationScreen(),
                        ),
                      );
                    },
                  ),
                ),
                (route) => false,
              );
            }
          },
        );
}

class _ZipCodeReloadedListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  _ZipCodeReloadedListener({
    required void Function(ZipCode?) onReloadZipCode,
  }) : super(
          listenWhen: (previous, current) {
            return previous.isReloadingColonies && !current.isReloadingColonies;
          },
          listener: (context, state) {
            onReloadZipCode(state.zipCode);
          },
        );
}
