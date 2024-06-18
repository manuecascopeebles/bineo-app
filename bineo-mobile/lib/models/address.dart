import 'package:bineo/models/zip_code.dart';

class Address {
  String? street;
  CountryState? state;
  String colony = '';
  String? interiorNumber;
  String? exteriorNumber;
  String municipality = '';
  String postalCode;
  late final bool hasCapturedAddressData;

  String get fullAddress {
    String address = '';
    if (street != null && street!.isNotEmpty) {
      address = '${street!} ';
    }
    if (exteriorNumber != null && exteriorNumber!.isNotEmpty) {
      address += '${exteriorNumber}';
    }
    if (interiorNumber != null && interiorNumber!.isNotEmpty) {
      address += ' ${interiorNumber}';
    }
    if (colony.isNotEmpty) {
      address += ', ${colony}';
    }
    address += '\n';
    final hasPostalCode = postalCode.isNotEmpty;
    final hasMunicipality = municipality.isNotEmpty;
    if (hasPostalCode || hasMunicipality) {
      if (hasPostalCode) {
        address += '${postalCode}${hasMunicipality ? ' ' : ''}';
      }
      if (hasMunicipality) {
        address += municipality;
      }
    }
    if (state != null && state!.name.isNotEmpty) {
      address += ', ${state}';
    }

    return address;
  }

  Address({
    this.street,
    this.state,
    this.colony = '',
    this.interiorNumber,
    this.exteriorNumber,
    this.municipality = '',
    this.postalCode = '',
  }) {
    bool hasStreet = street != null && street!.isNotEmpty;
    bool hasExteriorNumber =
        exteriorNumber != null && exteriorNumber!.isNotEmpty;

    hasCapturedAddressData = hasStreet && hasExteriorNumber;
  }

  Address copy() {
    return Address(
        street: street,
        state: state,
        colony: colony,
        interiorNumber: interiorNumber,
        exteriorNumber: exteriorNumber,
        municipality: municipality,
        postalCode: postalCode);
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
        street: map['street'] ?? '',
        exteriorNumber: map['ext_number'] ?? '',
        interiorNumber: map['int_number'] ?? '',
        postalCode: map['zip_code'] ?? '',
        state: map['state'] != null ? CountryState.fromMap(map) : null);
  }

  factory Address.fromIncode(Map<String, dynamic> jsonData) {
    final Map<String, dynamic> ocrData = jsonData['ocrData'];

    // Extracting address data
    final Map<String, dynamic> addressData = ocrData['addressFields'] ?? {};
    String street = addressData['street'] ?? '';
    String colony = addressData['colony'] ?? '';
    String postalCode = addressData['postalCode'] ?? '';
    String city = addressData['city'] ?? '';
    String state = addressData['state'] ?? '';
    String exteriorNumber = ocrData['exteriorNumber'] ?? '';

    return Address(
      street: street,
      state: CountryState.fromMap({'state': state}),
      colony: colony,
      exteriorNumber: exteriorNumber,
      municipality: city,
      postalCode: postalCode,
    );
  }

  bool get hasAddressData {
    bool hasStreet = street != null && street!.isNotEmpty;
    bool hasExteriorNumber =
        exteriorNumber != null && exteriorNumber!.isNotEmpty;
    bool hasPostalCode = postalCode.isNotEmpty;
    bool hasColony = colony.isNotEmpty;
    bool hasMunicipality = municipality.isNotEmpty;
    bool hasState = state?.name.isNotEmpty ?? false;

    return hasStreet &&
        hasExteriorNumber &&
        hasPostalCode &&
        hasColony &&
        hasMunicipality &&
        hasState;
  }
}
