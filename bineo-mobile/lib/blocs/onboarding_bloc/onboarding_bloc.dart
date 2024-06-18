import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:bineo/apis/romvo/romvo_api.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/models/curp.dart';
import 'package:bineo/models/ine.dart';
import 'package:bineo/models/zip_code.dart';
import 'package:bineo/services/core/injector.dart';
import 'package:bineo/services/interfaces/igeo_location_service.dart';
import 'package:bineo/common/permission_handler.dart';
import 'package:bineo/services/interfaces/ionboarding_service.dart';
import 'package:bineo/services/interfaces/iseon_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final _geoLocationService = Injector.resolve<IGeoLocationService>();
  final _seonService = Injector.resolve<ISeonService>();
  final _onboardingService = Injector.resolve<IOnboardingService>();

  OnboardingBloc() : super(OnboardingState()) {
    on<ValidateSeonEvent>((event, emit) async {
      try {
        final applicationId = const Uuid().v1();
        final isValid = await _seonService.validate(applicationId);
        emit(state.copyWith(
            seonValidationFinished: true,
            seonIsValid: isValid,
            applicationId: applicationId));

        print('SEON validation ${isValid ? 'SUCCESS!' : 'FAILED'}');
      } catch (error) {
        emit(state.copyWith(seonValidationFinished: true, seonIsValid: false));
        print('SEON validation FAILED with Error: $error');
      }
    });

    on<RequestInitialPermissionsEvent>((event, emit) async {
      // Request location permissions. If they are not granted, the user can't
      // continue using the app
      bool hasLocationPermission =
          await PermissionHandler.requestLocationPermission();

      if (!hasLocationPermission) {
        emit(state.copyWith(
          hasLocationPermission: false,
          locationPermissionDenied: true,
        ));
        return;
      }

      emit(state.copyWith(hasLocationPermission: true));

      // If this is an IOS device, request tracking permissions
      Future.delayed(const Duration(seconds: 1), () {
        AppTrackingTransparency.requestTrackingAuthorization();
      });
    });

    on<SubmitPersonalDetailsEvent>((event, emit) {
      emit(state.copyWith(
        username: event.username,
        email: event.email,
      ));
    });

    on<SendOTPCodeEvent>((event, emit) async {
      emit(state.copyWith(isSendingOTPCode: true));
      try {
        await _onboardingService.sendOTPCode(
          event.phoneNumber,
        );
        emit(state.copyWith(
            isSendingOTPCode: false,
            OTPCodeSent: true,
            hasErrorSendingOTPCode: false,
            phoneNumber: event.phoneNumber));
      } catch (e) {
        emit(state.copyWith(
          isSendingOTPCode: false,
          hasErrorSendingOTPCode: true,
        ));
      }
    });

    on<VerifyOTPCodeEvent>((event, emit) async {
      emit(state.copyWith(
          isVerifyingOTPCode: true,
          otpValidationError: false,
          otpIsInvalid: false,
          emailAlreadyExists: false));
      try {
        final isValid = await _onboardingService.verifyOTPCode(
          event.code,
          event.phoneNumber,
        );
        if (!isValid) {
          emit(state.copyWith(
            otpIsInvalid: true,
            isVerifyingOTPCode: false,
          ));
          return;
        }

        RomvoAPI.instance.initialize(state.email, state.phoneNumber);
        final flow = await _onboardingService.getOnBoarding(state.username);

        //valido email y seon unicamente si no se creo el user en el CORE de bineo.
        bool seonValid = true;
        if (flow.customerId.isEmpty) {
          final emailValid = await _onboardingService.validateEmail(
            state.email,
          );
          if (!emailValid) {
            emit(state.copyWith(
                emailAlreadyExists: true, isVerifyingOTPCode: false));
            return;
          }

          seonValid = await _seonService.validateEmailAndPhone(
              state.email, state.phoneNumber);

          print('SEON validation ${seonValid ? 'SUCCESS!' : 'FAILED'}');
        }

        emit(state.copyWith(
            seonIsInvalid: !seonValid,
            isVerifyingOTPCode: false,
            onBoardingFlow: flow));
      } catch (e) {
        emit(state.copyWith(
            isVerifyingOTPCode: false, otpValidationError: true));
      }
    });

    on<VerifyLocationEvent>((event, emit) async {
      bool hasLocation = false;

      emit(state.copyWith(isVerifyingLocation: true, locationVerified: false));

      try {
        Position location = await Geolocator.getCurrentPosition();
        hasLocation = true;

        bool isLocationValid = await _geoLocationService.validate(
          location.latitude,
          location.longitude,
        );

        emit(state.copyWith(
          isVerifyingLocation: false,
          locationVerified: true,
          isNotAllowedLocation: !isLocationValid,
        ));
      } catch (_) {
        emit(state.copyWith(
          isVerifyingLocation: false,
          hasErrorGettingLocation: !hasLocation,
          hasErrorCheckingAllowedLocations: hasLocation,
        ));
      }
    });

    on<RequestNotificationsPermissionEvent>((event, emit) async {
      try {
        bool hasPermission =
            await PermissionHandler.requestNotificationsPermission();

        emit(state.copyWith(hasNotificationsPermission: hasPermission));
      } catch (error) {
        print('RequestNotificationsPermissionEvent error: $error');
      }
    });

    on<LoadContractPdfEvent>((event, emit) async {
      emit(state.copyWith(isRequestingContractPdf: true));

      try {
        final contractPdf = await _onboardingService.generateContract(
          state.ine!,
          state.zipCode!.state.isoCode,
          state.phoneNumber,
          state.email,
        );
        emit(state.copyWith(contractPdf: contractPdf));
      } catch (error) {
        emit(state.copyWith(isRequestingContractPdf: false));
        print('LoadContractPdfEvent error: $error');
      }
    });

    on<ValidatePersonalDataEvent>((event, emit) async {
      emit(state.copyWith(
        isValidatingPersonalData: true,
        inePersonalDataValidated: false,
        isCurpValid: true,
      ));

      bool curpValid = false;
      bool renapoValid = false;
      bool hasError = false;

      try {
        Curp? curp = event.ine.curp;

        if (curp == null || curp.value.isEmpty) {
          emit(state.copyWith(
            hasPersonalDataError: true,
            isValidatingPersonalData: false,
          ));
          return;
        }

        curpValid = await _onboardingService.validateCurp(
          curp.value,
        );
      } catch (e) {
        print('ValidatePersonalDataEvent curp error: $e');
        hasError = false;
      }

      if (!curpValid) {
        emit(state.copyWith(
          isValidatingPersonalData: false,
          hasPersonalDataError: hasError,
          isCurpValid: curpValid,
        ));
        return;
      }

      try {
        // renapoValid = await _onboardingService.validateRenapo(
        //   event.ine,
        // );
        renapoValid = true;
      } catch (e) {
        print('ValidatePersonalDataEvent renapo error: $e');
        hasError = true;
      }

      emit(state.copyWith(
        ine: event.ine,
        isCurpValid: curpValid,
        isRenapoValid: renapoValid,
        inePersonalDataValidated: true,
        isValidatingPersonalData: false,
        hasPersonalDataError: hasError,
      ));
    });

    on<ValidateAddressDataEvent>((event, emit) async {
      emit(state.copyWith(
        isValidatingAddressData: true,
        hasPersonalDataError: false,
      ));

      try {
        final notInBlackList = await _onboardingService.validateBlackList(
          _seonService.transactionId,
          event.ine,
          state.zipCode!.state.id,
        );

        if (!notInBlackList) {
          emit(state.copyWith(
            isblackListed: true,
            hasPersonalDataError: false,
            ineAddressDataValidated: true,
            isValidatingAddressData: false,
          ));
          return;
        }

        await _onboardingService.saveIne(event.ine, state.applicationId);

        emit(state.copyWith(
          ine: event.ine,
          isblackListed: !notInBlackList,
          hasPersonalDataError: false,
          ineAddressDataValidated: true,
          isValidatingAddressData: false,
        ));
      } catch (e) {
        print('ValidateAddressDataEvent error: $e');
        emit(state.copyWith(
            hasPersonalDataError: true, isValidatingAddressData: false));
      }
    });

    on<ReloadColoniesEvent>((event, emit) async {
      final zipCode = event.fromChangeAddress
          ? state.newZipCode?.zipcode
          : state.zipCode?.zipcode;
      if (event.postalCode == zipCode) return;

      emit(state.copyWith(
        isReloadingColonies: true,
        hasErrorReloadingColonies: false,
      ));

      try {
        ZipCode zipCodeResp = await _onboardingService.getZipCode(
          event.postalCode,
        );

        emit(state.copyWith(
          zipCode: event.fromChangeAddress ? state.zipCode : zipCodeResp,
          newZipCode: event.fromChangeAddress ? zipCodeResp : state.newZipCode,
          isReloadingColonies: false,
        ));
      } catch (_) {
        emit(state
            .copyWith(
              isReloadingColonies: false,
              hasErrorReloadingColonies: true,
            )
            .clearZipCode(fromChangeAddress: event.fromChangeAddress));
      }
    });

    on<AcceptContractEvent>((event, emit) async {
      emit(state.copyWith(acceptingContract: true));
      try {
        final location = await Geolocator.getCurrentPosition();
        final customerId = await _onboardingService.createCore(
            state.applicationId,
            state.ine!,
            state.email,
            state.username,
            state.phoneNumber,
            state.alias,
            state.sendCardAddress ?? state.ine!.address,
            location.latitude,
            location.longitude);
        await _onboardingService.sendContract(customerId, state.email,
            state.contractPdf!, state.applicationId, state.alias);
        await _onboardingService.acceptContract(customerId);
        emit(state.copyWith(
          acceptingContract: false,
          isContractAccepted: true,
        ));
      } catch (e) {
        print('AcceptContractEvent error: $e');
      }
    });

    on<CreatePasswordEvent>((event, emit) async {
      emit(state.copyWith(isCreatingPassword: true, passwordCreated: false));

      try {
        await _onboardingService.savePassword(event.password);

        emit(state.copyWith(
          passwordCreated: true,
          isCreatingPassword: false,
        ));
      } catch (_) {
        emit(state.copyWith(
          isCreatingPassword: false,
          hasErrorCreatingPassword: true,
        ));
      }
    });

    on<LoadIneDataFromIncodeEvent>((event, emit) async {
      emit(state.copyWith(isLoadingINEData: true));

      INE ine = event.ine;

      try {
        String rfc = await _onboardingService.getRFC(event.ine);
        ZipCode zipCode = await _onboardingService.getZipCode(
          event.ine.address.postalCode,
        );

        ine.rfc = rfc;
        ine.address.state = zipCode.state;
        ine.address.colony =
            zipCode.neighborhoods.length > 0 ? zipCode.neighborhoods.first : '';

        emit(state.copyWith(
          ine: ine,
          zipCode: zipCode,
          isLoadingINEData: false,
        ));
      } catch (error) {
        print('LoadIneDataFromIncodeEvent error: $error');
        emit(state.copyWith(isLoadingINEData: false));
      }
    });

    on<ClearNewZipCodeEvent>((event, emit) async {
      emit(state.clearZipCode(fromChangeAddress: true));
    });

    on<SaveAliasEvent>((event, emit) async {
      emit(state.copyWith(savingAliasError: false, isSavingAlias: true));
      try {
        await _onboardingService.saveCCInfo(
          state.alias,
        );
        emit(state.copyWith(isSavingAlias: false));
      } catch (_) {
        emit(state.copyWith(savingAliasError: true, isSavingAlias: false));
      }
    });

    on<SubmitChangedAddressEvent>((event, emit) async {
      emit(state.copyWith(
        submitChangedAddressLoading: true,
        submitChangedAddressError: false,
        submitChangedAddressSuccess: false,
      ));

      try {
        await _onboardingService.saveCCInfo(
          state.alias,
          address: event.address,
        );

        emit(state.copyWith(
          sendCardAddress: event.address,
          submitChangedAddressLoading: false,
          submitChangedAddressSuccess: true,
        ));
      } catch (_) {
        emit(state.copyWith(
          submitChangedAddressLoading: false,
          submitChangedAddressError: true,
        ));
      }
    });

    on<INEScanEvent>((event, emit) async {
      emit(state.copyWith(isScanningINE: event.isScanning));
    });

    on<ValidateAliasEvent>((event, emit) async {
      emit(state.copyWith(
        isValidatingAlias: true,
        hasErrorValidatingAlias: false,
        isAliasValid: true,
      ));

      try {
        final isOk = await _onboardingService.validateAlias(event.alias);
        emit(state.copyWith(
          isAliasValid: isOk,
          isValidatingAlias: false,
          alias: event.alias,
        ));
      } catch (e) {
        emit(state.copyWith(
          isAliasValid: false,
          isValidatingAlias: false,
          hasErrorValidatingAlias: true,
        ));
      }
    });

    on<LoadFlowEvent>((event, emit) async {
      final flow = state.onBoardingFlow!;
      ZipCode? zipCode;
      if (flow.ine != null) {
        zipCode = ZipCode.fromMap({
          'zipcode': flow.ine!.address.postalCode,
          'state': flow.ine!.address.state?.name,
          'state_id': flow.ine!.address.state?.id,
          'state_iso': flow.ine!.address.state?.isoCode,
        });
      }
      emit(state.copyWith(
        applicationId: flow.applicationId,
        alias: flow.cardNickname,
        ine: flow.ine,
        zipCode: zipCode,
        isContractAccepted: flow.contractApproved,
      ));
    });
  }
}
