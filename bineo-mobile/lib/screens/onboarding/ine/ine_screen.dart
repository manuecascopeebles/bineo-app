import 'dart:convert';

import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/permission_handler.dart';
import 'package:bineo/models/ine.dart';
import 'package:bineo/screens/onboarding/ine/ine_personal_data_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:bineo/widgets/app_loader.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_flutter_wrapper/onboarding_flutter_wrapper.dart';

class INEScreen extends StatefulWidget {
  const INEScreen({super.key});

  @override
  State<INEScreen> createState() => _INEScreenState();
}

class _INEScreenState extends State<INEScreen> {
  void requestCameraPermission() async {
    // here we request camera permission
    final hasCameraPermission =
        await PermissionHandler.requestCameraPermission();

    if (hasCameraPermission) {
      scanINE();
    } else {
      AppDialog.showOpenSettingsDialog(AppStrings.cameraPermissionSettingsTitle,
          AppStrings.cameraPermissionSettingsDescription);
    }
  }

  void scanINE() {
    // final ineData =
    //     '{ "ocrData": { "name": { "fullName": "JORGE YUSSEL HERNANDEZ VILLEGAS", "machineReadableFullName": "JORGE YUSSE HERNANDEZ VILLEGA", "firstName": "JORGE YUSSEL", "givenName": "JORGE YUSSEL", "givenNameMrz": "JORGE YUSSE", "paternalLastName": "HERNANDEZ", "maternalLastName": "VILLEGAS", "lastNameMrz": "HERNANDEZ VILLEGA" }, "address": "C 1503 54 U HAB SAN JUAN DE ARAGON 6A SECC 07918 GUSTAVO A. MADERO, CDMX", "addressFields": { "street": "C 1503 54", "colony": "U HAB SAN JUAN DE ARAGON 6A SECC", "postalCode": "07918", "city": "GUSTAVO A. MADERO", "state": "CDMX", "stateCode": "09" }, "fullAddress": false, "invalidAddress": false, "checkedAddress": "Calle 1503 54, San Juan de Aragón VI Sección, 07918 Gustavo A Madero, CDMX, México", "checkedAddressBean": { "street": "Calle 1503 54", "postalCode": "07918", "city": "Gustavo A Madero", "state": "CDMX", "stateName": "Ciudad de México", "label": "Calle 1503 54, San Juan de Aragón VI Sección, 07918 Gustavo A Madero, CDMX, México", "latitude": 19.46811, "longitude": -99.07075, "zipColonyOptions": [] }, "exteriorNumber": "54", "typeOfId": "VoterIdentification", "documentFrontSubtype": "VOTER_IDENTIFICATION_CARD", "documentBackSubtype": "VOTER_IDENTIFICATION_CARD", "birthDate": 592963200000, "gender": "M", "claveDeElector": "HRVLJR88101615H800", "curp": "HEVJ881016HMCRLR07", "numeroEmisionCredencial": "04", "cic": "231540141", "ocr": "1598077275632", "expireAt": "1988064000000", "expirationDate": 2032, "issueDate": 2022, "registrationDate": 2007, "issuingCountry": "MEX", "birthPlace": "MC", "nationality": "MEX", "nationalityMrz": "MEX", "notExtracted": 0, "notExtractedDetails": [], "mrz1": "IDMEX2315401411<<1598077275632", "mrz2": "8810160H3212312MEX<04<<20922<3", "mrz3": "HERNANDEZ<VILLEGA<<JORGE<YUSSE", "fullNameMrz": "JORGE YUSSE HERNANDEZ VILLEGA", "documentNumberCheckDigit": "1", "dateOfBirthCheckDigit": "0", "expirationDateCheckDigit": "2", "ocrDataConfidence": { "birthDateConfidence": 1, "givenNameConfidence": 1, "firstNameConfidence": 1, "mothersSurnameConfidence": 1, "fathersSurnameConfidence": 1, "addressConfidence": 0.99968743, "countryCodeConfidence": 1, "genderConfidence": 1, "issueDateConfidence": 1, "expirationDateConfidence": 1, "expireAtConfidence": 1, "mrz1Confidence": 1, "mrz2Confidence": 1, "mrz3Confidence": 1, "documentNumberConfidence": 1, "backNumberConfidence": 1, "personalNumberConfidence": 1, "claveDeElectorConfidence": 1, "numeroEmisionCredencialConfidence": 1, "curpConfidence": 0.99, "registrationDateConfidence": 1, "nationalityConfidence": 1, "nationalityMrzConfidence": 1 } } }';
    // INE ine = INE.fromIncode(Map<String, dynamic>.from(jsonDecode(ineData)));
    // BlocProvider.of<OnboardingBloc>(context)
    //     .add(LoadIneDataFromIncodeEvent(ine));
    // return;
    OnboardingSessionConfiguration sessionConfig =
        OnboardingSessionConfiguration(
            configurationId: '660cda33aa3202830331dd64');

    OnboardingFlowConfiguration flowConfig = OnboardingFlowConfiguration();
    flowConfig.addIdScan(idType: IdType.id);

    BlocProvider.of<OnboardingBloc>(context).add(INEScanEvent(true));
    IncodeOnboardingSdk.startOnboarding(
      onUserCancelled: () {
        BlocProvider.of<OnboardingBloc>(context).add(INEScanEvent(false));
      },
      sessionConfig: sessionConfig,
      flowConfig: flowConfig,
      onSuccess: () {
        BlocProvider.of<OnboardingBloc>(context).add(INEScanEvent(false));
      },
      onError: (String error) {
        print('Incode onboarding error: $error');
        showIneScanError();
      },
      onIdFrontCompleted: (IdScanResult result) {
        print('onIdFrontCompleted result: $result');
      },
      onIdBackCompleted: (IdScanResult result) {
        print('onIdBackCompleted result: $result');
      },
      onIdProcessed: (data) => extractData(data),
    );
  }

  void showIneScanError() {
    AppDialog.showMessage(
      AppStrings.ineErrorTitle,
      AppStrings.ineErrorDescription,
      [
        NativeDialogPlusAction(
          text: AppStrings.ineErrorButton,
          onPressed: scanINE,
        ),
      ],
    );
  }

  void extractData(
    String ineData,
  ) {
    try {
      INE ine = INE.fromIncode(Map<String, dynamic>.from(jsonDecode(ineData)));

      BlocProvider.of<OnboardingBloc>(context)
          .add(LoadIneDataFromIncodeEvent(ine));
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideBackButton: true,
      centerBody: true,
      submitButton: BlocBuilder<OnboardingBloc, OnboardingState>(
        buildWhen: (previous, current) =>
            previous.isScanningINE != current.isScanningINE,
        builder: (context, state) {
          return AppButton(
            title: AppStrings.continueString,
            isLoading: state.isScanningINE,
            onTap: () => requestCameraPermission(),
          );
        },
      ),
      body: MultiBlocListener(
        listeners: [LoadingINEListener()],
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SVGs.getSVG(svg: SVGs.ineId),
                    Text(
                      AppStrings.ineIdTitle,
                      textAlign: TextAlign.center,
                      style: AppStyles.heading2TextStyle,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.ineIdDescription,
                      textAlign: TextAlign.center,
                      style: AppStyles.body2MediumEmphasisTextStyle,
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingINEListener extends BlocListener<OnboardingBloc, OnboardingState> {
  LoadingINEListener({super.child})
      : super(
          listenWhen: (previous, current) {
            return previous.isLoadingINEData != current.isLoadingINEData;
          },
          listener: (context, state) {
            if (state.ine == null) {
              AppLoader.show(
                context,
                loadingTime: Duration(seconds: 4),
                loadingTasks: AppStrings.ineLoaderTasks,
              );
            } else if (!state.isLoadingINEData) {
              if (AppLoader.canHide()) AppLoader.hide();
              INE ine = state.ine!.copy();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => INEPersonalDataScreen(ine: ine),
              ));
            }
          },
        );
}
