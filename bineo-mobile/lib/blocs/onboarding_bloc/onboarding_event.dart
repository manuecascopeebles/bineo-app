import 'package:bineo/models/address.dart';
import 'package:bineo/models/ine.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
}

class RequestInitialPermissionsEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];

  const RequestInitialPermissionsEvent();
}

class SubmitPersonalDetailsEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [username];

  final String username;
  final String email;

  const SubmitPersonalDetailsEvent({
    required this.username,
    required this.email,
  });
}

class VerifyLocationEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];

  const VerifyLocationEvent();
}

class SendOTPCodeEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [phoneNumber];

  final String phoneNumber;

  const SendOTPCodeEvent(this.phoneNumber);
}

class VerifyOTPCodeEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [code, phoneNumber];

  final String code;
  final String phoneNumber;

  const VerifyOTPCodeEvent(this.code, this.phoneNumber);
}

class RequestNotificationsPermissionEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];

  const RequestNotificationsPermissionEvent();
}

class LoadContractPdfEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];

  const LoadContractPdfEvent();
}

class ValidatePersonalDataEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [ine];

  final INE ine;

  const ValidatePersonalDataEvent(this.ine);
}

class ValidateAddressDataEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [ine];

  final INE ine;

  const ValidateAddressDataEvent(this.ine);
}

class AcceptContractEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];

  const AcceptContractEvent();
}

class CreatePasswordEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [password];

  final String password;

  const CreatePasswordEvent(this.password);
}

class LoadIneDataFromIncodeEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [ine];

  final INE ine;

  const LoadIneDataFromIncodeEvent(this.ine);
}

class ReloadColoniesEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [postalCode, fromChangeAddress];

  final String postalCode;
  final bool fromChangeAddress;

  const ReloadColoniesEvent(this.postalCode, {this.fromChangeAddress = false});
}

class ClearNewZipCodeEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];

  const ClearNewZipCodeEvent();
}

class SubmitChangedAddressEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [address];

  final Address address;

  const SubmitChangedAddressEvent(this.address);
}

class INEScanEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [isScanning];

  final bool isScanning;

  const INEScanEvent(this.isScanning);
}

class ValidateAliasEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [alias];

  final String alias;

  const ValidateAliasEvent(this.alias);
}

class ValidateSeonEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];

  const ValidateSeonEvent();
}

class LoadFlowEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];

  const LoadFlowEvent();
}

class SaveAliasEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];

  const SaveAliasEvent();
}
