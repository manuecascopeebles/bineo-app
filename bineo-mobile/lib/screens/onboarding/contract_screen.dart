import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/screens/onboarding/IPAB_screen.dart';
import 'package:bineo/widgets/app_activity_indicator.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_checkbox.dart';
import 'package:bineo/widgets/app_loader.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  bool isAcknowledged = false;

  @override
  void initState() {
    BlocProvider.of<OnboardingBloc>(context).add(LoadContractPdfEvent());
    super.initState();
  }

  void onAcceptContract() {
    if (isAcknowledged) {
      BlocProvider.of<OnboardingBloc>(context).add(
        AcceptContractEvent(),
      );
    }
  }

  Widget renderContractSubtitle(String email) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: AppStrings.wellSendContractByEmail,
            style: AppStyles.body2HighEmphasisTextStyle.copyWith(
              color: AppStyles.textMediumEmphasisColor,
            ),
          ),
          TextSpan(
            text: email,
            style: AppStyles.body2HighEmphasisTextStyle,
          ),
        ],
      ),
    );
  }

  Widget renderSubmitButton({required bool isEnabled}) {
    return AppButton(
      enabled: isAcknowledged && isEnabled,
      title: AppStrings.continueString,
      onTap: onAcceptContract,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [AcceptingContractListener()],
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return AppScaffold(
            isScrollable: false,
            hideBackButton: true,
            submitButton: renderSubmitButton(
              isEnabled: state.contractPdf != null,
            ),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    AppStrings.acceptContractTerms,
                    style: AppStyles.heading2TextStyle,
                  ),
                ),
                Expanded(
                  child: state.contractPdf == null
                      ? Center(
                          child: AppActivityIndicator(
                            size: 35,
                          ),
                        )
                      : SfPdfViewer.file(state.contractPdf!),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: renderContractSubtitle(state.email),
                ),
                AppCheckbox(
                  value: isAcknowledged,
                  text: AppStrings.iHaveAcknowledgedContract,
                  onChanged: (v) {
                    setState(() {
                      isAcknowledged = v;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AcceptingContractListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  AcceptingContractListener({super.child})
      : super(
          listenWhen: (previous, current) {
            return previous.acceptingContract != current.acceptingContract;
          },
          listener: (context, state) {
            if (state.acceptingContract) {
              AppLoader.show(
                context,
                loadingTime: Duration(seconds: 5),
                loadingTasks: [AppStrings.youAreAboutToHaveYourAccount],
              );
            } else if (state.isContractAccepted) {
              AppLoader.hide();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const IPABScreen(),
              ));
            }
          },
        );
}
