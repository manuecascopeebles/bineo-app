import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_validators.dart';
import 'package:bineo/models/address.dart';
import 'package:bineo/models/zip_code.dart';
import 'package:bineo/screens/onboarding/contract_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:bineo/widgets/app_dropdown.dart';
import 'package:bineo/widgets/app_form.dart';
import 'package:bineo/widgets/app_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeAddressScreen extends StatefulWidget {
  const ChangeAddressScreen({super.key});

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  final TextEditingController postalCodeController = TextEditingController();
  String otherColony = '';
  Address address = Address();
  FocusNode postalCodeFocus = FocusNode();

  Widget renderTitle() {
    return Text(
      AppStrings.changeAddressTitle,
      style: AppStyles.heading4TextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget renderText(String text) {
    return Text(text, style: AppStyles.subtitleTextStyle);
  }

  void onChangePostalCodeFocus(bool hasFocus) async {
    OnboardingBloc bloc = BlocProvider.of<OnboardingBloc>(context);
    final postalCodeNotCompleted = address.postalCode.length < 5;

    if (!hasFocus) {
      if (postalCodeNotCompleted) {
        setState(() {
          address.colony = AppStrings.other;
          address.postalCode = '';
          postalCodeController.text = '';
        });
        BlocProvider.of<OnboardingBloc>(context).add(ClearNewZipCodeEvent());
      } else {
        bloc.add(
            ReloadColoniesEvent(address.postalCode, fromChangeAddress: true));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    postalCodeFocus.addListener(() {
      onChangePostalCodeFocus(postalCodeFocus.hasFocus);
    });
  }

  Widget renderPostalCodeInput() {
    return AppInput(
      maxLength: 5,
      controller: postalCodeController,
      type: AppInputType.numeric,
      title: AppStrings.postalCode,
      validator: AppValidators.requiredInput,
      focusNode: postalCodeFocus,
      onChanged: (postalCode) async {
        setState(() {
          address.postalCode = postalCode;
        });
      },
    );
  }

  Widget renderColonyDropdown(OnboardingState state) {
    List<String> colonies = [...state.newZipCode?.neighborhoods ?? []];
    colonies.add(AppStrings.other);

    String value = address.colony.isNotEmpty ? address.colony : colonies.first;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 24),
          child: AppDropdown<String>(
            title: AppStrings.colony,
            isLoading: state.isReloadingColonies,
            value: value,
            items: colonies,
            onChanged: (colony) {
              if (colony != null) {
                setState(() {
                  if (address.colony != colony) {
                    otherColony = '';
                  }
                  address.colony = colony;
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
              onChanged: (text) {
                setState(() => otherColony = text);
              },
            ),
          ),
      ],
    );
  }

  Widget renderMunicipalityInput(OnboardingState state) {
    final postalCodeNotCompleted = address.colony.isEmpty;
    return AppInput(
      type: AppInputType.text,
      title: AppStrings.municipality,
      placeholder:
          !postalCodeNotCompleted ? state.newZipCode?.borough ?? '' : '',
      isEnabled: false,
    );
  }

  Widget renderStateInput(OnboardingState state) {
    final postalCodeNotCompleted = address.colony.isEmpty;
    return AppInput(
      type: AppInputType.text,
      title: AppStrings.state,
      placeholder:
          !postalCodeNotCompleted ? state.newZipCode?.state.name ?? '' : '',
      isEnabled: false,
    );
  }

  AppButton renderSubmitButton(OnboardingState state) {
    return AppButton(
      title: AppStrings.continueString,
      style: AppButtonStyle.primary,
      onTap: () {
        BlocProvider.of<OnboardingBloc>(context)
            .add(SubmitChangedAddressEvent(address));
      },
      enabled: address.hasAddressData &&
          !state.hasErrorReloadingColonies &&
          (address.colony == AppStrings.other ? otherColony.isNotEmpty : true),
      isLoading: state.submitChangedAddressLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _ZipCodeReloadedListener(
          onReloadZipCode: (zipCode) {
            if (zipCode == null) {
              setState(() {
                address.colony = '';
                address.municipality = '';
                address.state = null;
              });
              return;
            }
            setState(() {
              address.colony = zipCode.neighborhoods.length > 0
                  ? zipCode.neighborhoods.first
                  : '';
              address.municipality = zipCode.borough;
              address.state = zipCode.state;
            });
          },
        ),
        _SubmitListener(),
      ],
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return AppForm(
            hideBackButton: false,
            submitButton: renderSubmitButton(state),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 24),
                child: renderTitle(),
              ),
              AppInput(
                title: AppStrings.street,
                type: AppInputType.text,
                validator: AppValidators.requiredInput,
                onChanged: (text) => setState(() => address.street = text),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AppInput(
                      title: AppStrings.exteriorNumber,
                      type: AppInputType.numeric,
                      validator: AppValidators.requiredInput,
                      onChanged: (text) =>
                          setState(() => address.exteriorNumber = text),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: AppInput(
                      title: AppStrings.optionalInteriorNumber,
                      type: AppInputType.numeric,
                      onChanged: (text) =>
                          setState(() => address.interiorNumber = text),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              renderPostalCodeInput(),
              renderColonyDropdown(state),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: renderMunicipalityInput(state),
              ),
              renderStateInput(state),
            ],
          );
        },
      ),
    );
  }
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
            onReloadZipCode(state.newZipCode);
          },
        );
}

class _SubmitListener extends BlocListener<OnboardingBloc, OnboardingState> {
  _SubmitListener()
      : super(
          listenWhen: (previous, current) {
            return !previous.submitChangedAddressSuccess &&
                current.submitChangedAddressSuccess;
          },
          listener: (context, state) {
            if (state.submitChangedAddressError) {
              AppDialog.showMessage(
                'Error',
                '',
                [
                  NativeDialogPlusAction(
                    text: AppStrings.okay,
                    onPressed: () {},
                  )
                ],
              );
              return;
            }
            if (state.submitChangedAddressSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => ContractScreen(),
                ),
                (route) => false,
              );
            }
          },
        );
}
