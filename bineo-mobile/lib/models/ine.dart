import 'package:bineo/models/address.dart';
import 'package:bineo/models/curp.dart';
import 'package:bineo/models/zip_code.dart';

class INE {
  String name = '';
  String? secondSurname;
  String firstSurname = '';
  String get gender => curp?.gender ?? '';
  bool get isMale => gender == 'H';
  DateTime? get birthDate => curp?.date;
  Curp? curp;
  Address address;
  String voterId;

  // INE personal data:
  String rfc = '';
  String? birthCountry;
  bool get isForeigner => curp?.isForeigner ?? false;
  late final bool hasCapturedSecondSurname;

  INE({
    this.name = '',
    this.secondSurname,
    this.firstSurname = '',
    this.curp,
    this.rfc = '',
    this.birthCountry,
    this.voterId = '',
    required this.address,
  }) {
    hasCapturedSecondSurname =
        secondSurname != null && secondSurname!.isNotEmpty;
  }

  INE copy() {
    return INE(
        name: name,
        secondSurname: secondSurname,
        firstSurname: firstSurname,
        curp: curp,
        rfc: rfc,
        birthCountry: birthCountry,
        address: address,
        voterId: voterId);
  }

  factory INE.fromMap(Map<String, dynamic> map) {
    final List<dynamic> addresses = map['addresses'];
    Map<String, dynamic> address = {};
    if (addresses.isNotEmpty) {
      address = addresses.firstWhere((element) => element['type'] == 1);
    }

    return INE(
      name: map['name'],
      firstSurname: map['surname'],
      secondSurname: map['surname2'],
      curp: Curp(map['curp']),
      rfc: map['rfc'],
      birthCountry: map['birth_country'],
      voterId: map['voter_id'] ?? '',
      address: addresses.isNotEmpty ? Address.fromMap(address) : Address(),
    );
  }

  factory INE.fromIncode(Map<String, dynamic> jsonData) {
    final Map<String, dynamic> ocrData = jsonData['ocrData'];

    // Extracting name data
    final Map<String, dynamic> nameData = ocrData['name'] ?? {};
    String paternalLastName = nameData['paternalLastName'] ?? '';
    String maternalLastName = nameData['maternalLastName'] ?? '';
    String firstName = nameData['firstName'] ?? '';

    // Extracting address data
    final Map<String, dynamic> addressData = ocrData['addressFields'] ?? {};
    String street = addressData['street'] ?? '';
    String colony = addressData['colony'] ?? '';
    String postalCode = addressData['postalCode'] ?? '';
    String city = addressData['city'] ?? '';
    String state = addressData['state'] ?? '';
    String exteriorNumber = ocrData['exteriorNumber'] ?? '';
    String voterId = ocrData['claveDeElector'] ?? '';

    // Extracting other data
    String curpValue = ocrData['curp'] ?? '';
    Curp curp = Curp(curpValue);

    return INE(
      name: firstName,
      firstSurname: paternalLastName,
      secondSurname: maternalLastName,
      curp: curp,
      voterId: voterId,
      address: Address(
        street: street,
        colony: colony,
        postalCode: postalCode,
        municipality: city,
        state: CountryState(id: '', isoCode: '', name: state),
        exteriorNumber: exteriorNumber,
      ),
    );
  }

  bool get hasPersonalData {
    bool hasName = name.isNotEmpty;
    bool hasFirstSurname = firstSurname.isNotEmpty;
    bool secondSurnameCheck = hasCapturedSecondSurname
        ? secondSurname != null && secondSurname!.isNotEmpty
        : true;
    bool hasCurp = curp?.value.isNotEmpty ?? false;
    bool birthCountryCheck =
        isForeigner ? birthCountry != null && birthCountry!.isNotEmpty : true;
    bool hasRfc = rfc.isNotEmpty;

    return hasName &&
        hasFirstSurname &&
        secondSurnameCheck &&
        hasCurp &&
        birthCountryCheck &&
        hasRfc;
  }
}
