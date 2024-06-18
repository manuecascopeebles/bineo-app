import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_form.dart';
import 'package:bineo/widgets/app_input.dart';
import 'package:bineo/widgets/onboarding/confirm_address_modal.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardCustomizationScreen extends StatefulWidget {
  const CardCustomizationScreen({super.key});

  @override
  State<CardCustomizationScreen> createState() =>
      _CardCustomizationScreenState();
}

class _CardCustomizationScreenState extends State<CardCustomizationScreen> {
  late String initialCardName;
  late String cardName;
  bool inputError = false;

  @override
  void initState() {
    super.initState();
    var name = BlocProvider.of<OnboardingBloc>(context).state.username.trim();
    if (name.length > 15) {
      name = name.substring(0, 15);
    }

    initialCardName = name;

    setState(() {
      cardName = name;
    });
  }

  Widget renderTitle() {
    return Text(
      AppStrings.cardCustomizationTitle,
      style: AppStyles.heading2TextStyle,
    );
  }

  Widget renderText(String text) {
    return Text(
      text,
      style: AppStyles.subtitleTextStyle,
      textAlign: TextAlign.left,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _AliasValidListener(
          onAliasInvalid: () {
            setState(() {
              inputError = true;
            });
          },
        )
      ],
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        buildWhen: (previous, current) =>
            previous.isValidatingAlias != current.isValidatingAlias,
        builder: (context, state) {
          return AppForm(
            hideBackButton: true,
            validateOnRender: true,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            submitButton: AppButton(
              isLoading: state.isValidatingAlias,
              title: AppStrings.continueString,
              style: AppButtonStyle.primary,
              enabled: !inputError,
              onTap: () async {
                BlocProvider.of<OnboardingBloc>(context).add(
                  ValidateAliasEvent(cardName),
                );
              },
            ),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  renderTitle(),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: renderText(
                        AppStrings.cardCustomizationSubtitle(initialCardName)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 33),
                    child: Stack(
                      children: [
                        SVGs.getSVG(svg: SVGs.card),
                        Positioned(
                          width: 80,
                          child: Text(
                            cardName,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: AppStyles.body2HighEmphasisTextStyle
                                .copyWith(fontSize: 13),
                          ),
                          bottom: 22,
                          right: 15,
                        ),
                      ],
                    ),
                  ),
                  AppInput(
                    type: AppInputType.text,
                    subtitle: AppStrings.cardCustomizationInputSubtitle,
                    initialValue: initialCardName,
                    showEmptyTextError: true,
                    validator: (value) {
                      if (inputError) {
                        return AppStrings.aliasError;
                      }
                      return null;
                    },
                    maxLength: 15,
                    onChanged: (text) => setState(() {
                      inputError = false;
                      cardName = text.trim();
                    }),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

class _AliasValidListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  _AliasValidListener({required void Function() onAliasInvalid})
      : super(
          listenWhen: (previous, current) {
            return previous.isValidatingAlias && !current.isValidatingAlias;
          },
          listener: (context, state) {
            if (state.isAliasValid && !state.hasErrorValidatingAlias) {
              ConfirmAddressModal.show(context);
              return;
            } else {
              onAliasInvalid();
            }
          },
        );
}
