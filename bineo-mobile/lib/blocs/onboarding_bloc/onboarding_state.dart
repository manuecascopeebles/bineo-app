import 'dart:io';

import 'package:bineo/apis/romvo/romvo_api.dart';
import 'package:bineo/models/address.dart';
import 'package:bineo/models/ine.dart';
import 'package:bineo/models/zip_code.dart';

class OnboardingState {
  bool seonValidationFinished;
  bool seonIsValid;
  String applicationId;
  String username = '';
  String email = '';
  String phoneNumber;
  int? clientNumber;
  bool isblackListed = false;
  bool passwordCreated = false;
  bool isCurpValid = false;
  bool isRenapoValid = false;
  bool locationVerified = false;
  bool isLoadingINEData = false;
  bool acceptingContract = false;
  bool isContractAccepted = false;
  bool isCreatingPassword = false;
  bool isReloadingColonies = false;
  bool isVerifyingLocation = false;
  bool hasPersonalDataError = false;
  bool isNotAllowedLocation = false;
  bool hasLocationPermission = false;
  bool isValidatingAddressData = false;
  bool isReviewingPersonalData = false;
  bool ineAddressDataValidated = false;
  bool hasErrorGettingLocation = false;
  bool isRequestingContractPdf = false;
  bool locationPermissionDenied = false;
  bool inePersonalDataValidated = false;
  bool isValidatingPersonalData = false;
  bool hasErrorCreatingPassword = false;
  bool hasErrorReloadingColonies = false;
  bool hasNotificationsPermission = false;
  bool hasErrorCheckingAllowedLocations = false;
  bool submitChangedAddressLoading = false;
  bool submitChangedAddressError = false;
  bool submitChangedAddressSuccess = false;
  INE? ine;
  ZipCode? zipCode;
  ZipCode? newZipCode;
  File? contractPdf;
  bool isScanningINE;

  // Card customization screen
  bool isValidatingAlias = false;
  bool isSavingAlias = false;
  bool savingAliasError = false;
  bool isAliasValid = true;
  bool hasErrorValidatingAlias = false;
  String alias = '';
  Address? sendCardAddress;

  // OTP
  bool OTPCodeSent = false;
  bool otpIsInvalid = false;
  bool seonIsInvalid = false;
  bool isSendingOTPCode = false;
  bool otpValidationError = false;
  bool isVerifyingOTPCode = false;
  bool emailAlreadyExists = false;
  bool hasErrorSendingOTPCode = false;

  OnBoardingFlow? onBoardingFlow;

  OnboardingState({
    this.seonValidationFinished = false,
    this.seonIsValid = false,
    this.applicationId = '',
    this.username = '',
    this.email = '',
    this.phoneNumber = '',
    this.clientNumber,
    this.isblackListed = false,
    this.passwordCreated = false,
    this.isCurpValid = false,
    this.isRenapoValid = false,
    this.locationVerified = false,
    this.isLoadingINEData = false,
    this.acceptingContract = false,
    this.isContractAccepted = false,
    this.isCreatingPassword = false,
    this.isReloadingColonies = false,
    this.isVerifyingLocation = false,
    this.hasPersonalDataError = false,
    this.isNotAllowedLocation = false,
    this.hasLocationPermission = false,
    this.isValidatingAddressData = false,
    this.isReviewingPersonalData = false,
    this.ineAddressDataValidated = false,
    this.hasErrorGettingLocation = false,
    this.isRequestingContractPdf = false,
    this.locationPermissionDenied = false,
    this.inePersonalDataValidated = false,
    this.isValidatingPersonalData = false,
    this.hasErrorCreatingPassword = false,
    this.hasErrorReloadingColonies = false,
    this.hasNotificationsPermission = false,
    this.hasErrorCheckingAllowedLocations = false,
    this.submitChangedAddressLoading = false,
    this.submitChangedAddressError = false,
    this.submitChangedAddressSuccess = false,
    this.ine,
    this.zipCode,
    this.newZipCode,
    this.contractPdf,
    this.isScanningINE = false,
    this.alias = '',
    this.sendCardAddress,
    this.isValidatingAlias = false,
    this.isAliasValid = false,
    this.isSavingAlias = false,
    this.savingAliasError = false,
    this.hasErrorValidatingAlias = false,
    this.OTPCodeSent = false,
    this.otpIsInvalid = false,
    this.seonIsInvalid = false,
    this.isSendingOTPCode = false,
    this.otpValidationError = false,
    this.isVerifyingOTPCode = false,
    this.emailAlreadyExists = false,
    this.hasErrorSendingOTPCode = false,
    this.onBoardingFlow = null,
  });

  OnboardingState clearZipCode({
    required bool fromChangeAddress,
  }) {
    if (fromChangeAddress) {
      this.newZipCode = null;
    } else {
      this.zipCode = null;
    }

    return copyWith();
  }

  OnboardingState updateSubmitStatus(bool loading, bool error, bool success) {
    return copyWith(
      submitChangedAddressLoading: loading,
      submitChangedAddressError: error,
      submitChangedAddressSuccess: success,
    );
  }

  OnboardingState copyWith({
    bool? seonValidationFinished,
    bool? seonIsValid,
    String? applicationId,
    String? username,
    String? email,
    String? phoneNumber,
    int? clientNumber,
    bool? isblackListed,
    bool? passwordCreated,
    bool? isCurpValid,
    bool? isRenapoValid,
    bool? locationVerified,
    bool? isLoadingINEData,
    bool? acceptingContract,
    bool? isContractAccepted,
    bool? isCreatingPassword,
    bool? isReloadingColonies,
    bool? isVerifyingLocation,
    bool? hasPersonalDataError,
    bool? isNotAllowedLocation,
    bool? hasLocationPermission,
    bool? isValidatingAddressData,
    bool? isReviewingPersonalData,
    bool? ineAddressDataValidated,
    bool? hasErrorGettingLocation,
    bool? isRequestingContractPdf,
    bool? locationPermissionDenied,
    bool? inePersonalDataValidated,
    bool? isValidatingPersonalData,
    bool? hasErrorCreatingPassword,
    bool? hasErrorReloadingColonies,
    bool? hasNotificationsPermission,
    bool? hasErrorCheckingAllowedLocations,
    bool? submitChangedAddressLoading,
    bool? submitChangedAddressError,
    bool? submitChangedAddressSuccess,
    INE? ine,
    ZipCode? zipCode,
    ZipCode? newZipCode,
    File? contractPdf,
    bool? isScanningINE,
    String? alias,
    Address? sendCardAddress,
    bool? isValidatingAlias,
    bool? isAliasValid,
    bool? isSavingAlias,
    bool? savingAliasError,
    bool? hasErrorValidatingAlias,
    bool? OTPCodeSent,
    bool? otpIsInvalid,
    bool? seonIsInvalid,
    bool? isSendingOTPCode,
    bool? isVerifyingOTPCode,
    bool? emailAlreadyExists,
    bool? otpValidationError,
    bool? hasErrorSendingOTPCode,
    OnBoardingFlow? onBoardingFlow,
  }) {
    return OnboardingState(
      seonValidationFinished:
          seonValidationFinished ?? this.seonValidationFinished,
      seonIsValid: seonIsValid ?? this.seonIsValid,
      applicationId: applicationId ?? this.applicationId,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      clientNumber: clientNumber ?? this.clientNumber,
      isblackListed: isblackListed ?? this.isblackListed,
      passwordCreated: passwordCreated ?? this.passwordCreated,
      isCurpValid: isCurpValid ?? this.isCurpValid,
      isRenapoValid: isRenapoValid ?? this.isRenapoValid,
      locationVerified: locationVerified ?? this.locationVerified,
      isLoadingINEData: isLoadingINEData ?? this.isLoadingINEData,
      acceptingContract: acceptingContract ?? this.acceptingContract,
      isContractAccepted: isContractAccepted ?? this.isContractAccepted,
      isCreatingPassword: isCreatingPassword ?? this.isCreatingPassword,
      isReloadingColonies: isReloadingColonies ?? this.isReloadingColonies,
      isVerifyingLocation: isVerifyingLocation ?? this.isVerifyingLocation,
      hasPersonalDataError: hasPersonalDataError ?? this.hasPersonalDataError,
      isNotAllowedLocation: isNotAllowedLocation ?? this.isNotAllowedLocation,
      hasLocationPermission:
          hasLocationPermission ?? this.hasLocationPermission,
      isValidatingAddressData:
          isValidatingAddressData ?? this.isValidatingAddressData,
      isReviewingPersonalData:
          isReviewingPersonalData ?? this.isReviewingPersonalData,
      ineAddressDataValidated:
          ineAddressDataValidated ?? this.ineAddressDataValidated,
      hasErrorGettingLocation:
          hasErrorGettingLocation ?? this.hasErrorGettingLocation,
      isRequestingContractPdf:
          isRequestingContractPdf ?? this.isRequestingContractPdf,
      locationPermissionDenied: locationPermissionDenied ?? false,
      inePersonalDataValidated:
          inePersonalDataValidated ?? this.inePersonalDataValidated,
      isValidatingPersonalData:
          isValidatingPersonalData ?? this.isValidatingPersonalData,
      hasErrorCreatingPassword:
          hasErrorCreatingPassword ?? this.hasErrorCreatingPassword,
      hasErrorReloadingColonies:
          hasErrorReloadingColonies ?? this.hasErrorReloadingColonies,
      hasNotificationsPermission:
          hasNotificationsPermission ?? this.hasNotificationsPermission,
      hasErrorCheckingAllowedLocations: hasErrorCheckingAllowedLocations ??
          this.hasErrorCheckingAllowedLocations,
      submitChangedAddressLoading:
          submitChangedAddressLoading ?? this.submitChangedAddressLoading,
      submitChangedAddressError:
          submitChangedAddressError ?? this.submitChangedAddressError,
      submitChangedAddressSuccess:
          submitChangedAddressSuccess ?? this.submitChangedAddressSuccess,
      ine: ine ?? this.ine,
      zipCode: zipCode ?? this.zipCode,
      newZipCode: newZipCode ?? this.newZipCode,
      contractPdf: contractPdf ?? this.contractPdf,
      isScanningINE: isScanningINE ?? this.isScanningINE,
      alias: alias ?? this.alias,
      sendCardAddress: sendCardAddress ?? this.sendCardAddress,
      isValidatingAlias: isValidatingAlias ?? this.isValidatingAlias,
      isSavingAlias: isSavingAlias ?? this.isSavingAlias,
      savingAliasError: savingAliasError ?? this.savingAliasError,
      isAliasValid: isAliasValid ?? this.isAliasValid,
      hasErrorValidatingAlias:
          hasErrorValidatingAlias ?? this.hasErrorValidatingAlias,
      OTPCodeSent: OTPCodeSent ?? false,
      otpIsInvalid: otpIsInvalid ?? this.otpIsInvalid,
      seonIsInvalid: seonIsInvalid ?? this.seonIsInvalid,
      isSendingOTPCode: isSendingOTPCode ?? this.isSendingOTPCode,
      isVerifyingOTPCode: isVerifyingOTPCode ?? this.isVerifyingOTPCode,
      emailAlreadyExists: emailAlreadyExists ?? this.emailAlreadyExists,
      otpValidationError: otpValidationError ?? this.otpValidationError,
      hasErrorSendingOTPCode: hasErrorSendingOTPCode ?? false,
      onBoardingFlow: onBoardingFlow ?? this.onBoardingFlow,
    );
  }
}
