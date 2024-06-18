import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/screens/onboarding/change_address_screen.dart';
import 'package:bineo/screens/onboarding/contract_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmAddressModal {
  static BuildContext? _dialogContext;
  static void dismiss() {
    if (_dialogContext != null) {
      Navigator.of(_dialogContext!, rootNavigator: true).pop();
      _dialogContext = null;
    }
  }

  static show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppStyles.surfaceColor,
      builder: (_) {
        _dialogContext = context;
        return const MyConfirmAddressModal();
      },
    );
  }
}

class MyConfirmAddressModal extends StatefulWidget {
  const MyConfirmAddressModal({Key? key}) : super(key: key);
  @override
  State<MyConfirmAddressModal> createState() => _MyConfirmAddressModalState();
}

class _MyConfirmAddressModalState extends State<MyConfirmAddressModal> {
  @override
  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (previous, current) =>
          previous.isSavingAlias &&
          !current.isSavingAlias &&
          !current.savingAliasError,
      listener: (context, state) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => ContractScreen(),
          ),
          (route) => false,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 18, left: 24, right: 24),
        child: Wrap(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(bottom: 24),
              child: InkWell(
                onTap: () => ConfirmAddressModal.dismiss(),
                child: SVGs.getSVG(svg: SVGs.close),
              ),
            ),
            Text(
              AppStrings.cardCustomizationModalTitle,
              style: AppStyles.heading2TextStyle,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 20),
              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  final ine = state.ine;
                  return Text(
                    ine?.address.fullAddress ?? '',
                    style: AppStyles.body3TextStyle,
                  );
                },
              ),
            ),
            AppButton(
              title: AppStrings.cardCustomizationModalChangeAddressButton,
              style: AppButtonStyle.secondaryDark,
              onTap: () {
                BlocProvider.of<OnboardingBloc>(context)
                    .add(ClearNewZipCodeEvent());
                ConfirmAddressModal.dismiss();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChangeAddressScreen(),
                  ),
                );
              },
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 20),
                child: BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                  return AppButton(
                    title: AppStrings.yes,
                    isLoading: state.isSavingAlias,
                    onTap: () {
                      BlocProvider.of<OnboardingBloc>(context)
                          .add(SaveAliasEvent());
                    },
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
