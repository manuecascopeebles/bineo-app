import 'package:bineo/models/address.dart';
import 'package:bineo/models/ine.dart';
import 'package:xml/xml.dart' as xml;

String getContractRequest(
    INE ine, String stateIsoCode, String phoneNumber, String email) {
  final now = DateTime.now();
  final formattedDate =
      "${now.day} de ${_monthInSpanish(now.month)} de ${now.year}";

  final builder = xml.XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('PAYLOAD', nest: () {
    builder.element('PRODUCT', nest: 'EPC_TA_N2');
    builder.element('LETTER_TYPE', nest: 'SAVINGS_ACCOUNT');

    String lastName = ine.firstSurname;
    if (ine.secondSurname != null && ine.secondSurname!.isNotEmpty) {
      lastName += ' ' + ine.secondSurname!;
    }

    String houseNumber = ine.address.exteriorNumber ?? '';
    if (ine.secondSurname != null && ine.secondSurname!.isNotEmpty) {
      houseNumber += ' ' + ine.address.exteriorNumber!;
    }

    builder.element('CUSTOMER_NAME_LAST', nest: lastName);
    builder.element('CUSTOMER_NAME_FIRST', nest: ine.name);
    builder.element('CUSTOMER_RFC', nest: ine.rfc);
    builder.element('CUSTOMER_COUNTRY', nest: 'MX');
    builder.element('CUSTOMER_CITY', nest: ine.address.municipality);
    builder.element('CUSTOMER_POSTCODE', nest: ine.address.postalCode);
    builder.element('CUSTOMER_STREET', nest: ine.address.street);
    builder.element('CUSTOMER_HOUSENO', nest: houseNumber);
    builder.element('CUSTOMER_REGION', nest: ine.address.colony);
    builder.element('CUSTOMER_DISTRICT', nest: stateIsoCode);

    builder.element('PHONE_NUMBER', nest: phoneNumber);
    builder.element('EMAIL', nest: email);

    builder.element('CATCHMENT_COVERSHEET', nest: () {
      builder.element('PRODUCT_NAME', nest: 'Cuenta de Ahorro bineo');
      builder.element('OPERATION_TYPE', nest: 'Pasiva');
      builder.element('INTEREST_RATE', nest: '');
      builder.element('GAT', nest: 'No Aplica');
      builder.element('FEE', nest: 'No Aplica');
    });

    builder.element('CONTRACT', nest: () {
      builder.element('DATE', nest: formattedDate);
    });
  });

  final document = builder.buildDocument();
  return document.toXmlString(pretty: true, indent: '  ');
}

String _monthInSpanish(int month) {
  const months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];
  return months[month - 1];
}

Map<String, String> stateMap = {
  "AS": "AGUASCALIENTES",
  "BC": "BAJA CALIFORNIA",
  "BS": "BAJA CALIFORNIA SUR",
  "CC": "CAMPECHE",
  "CS": "CHIAPAS",
  "CH": "CHIHUAHUA",
  "DF": "CIUDAD DE MEXICO",
  "CL": "COAHUILA",
  "CM": "COLIMA",
  "DG": "DURANGO",
  "GT": "GUANAJUATO",
  "GR": "GUERRERO",
  "HG": "HIDALGO",
  "JC": "JALISCO",
  "MC": "MEXICO",
  "MN": "MICHOACAN",
  "MS": "MORELOS",
  "NT": "NAYARIT",
  "NL": "NUEVO LEON",
  "OC": "OAXACA",
  "PL": "PUEBLA",
  "QT": "QUERETARO",
  "QR": "QUINTANA ROO",
  "SP": "SAN LUIS POTOSI",
  "SL": "SINALOA",
  "SR": "SONORA",
  "TC": "TABASCO",
  "TS": "TAMAULIPAS",
  "TL": "TLAXCALA",
  "VZ": "VERACRUZ",
  "YN": "YUCATAN",
  "ZS": "ZACATECAS"
};

String getCompleteState(String idState) {
  return stateMap[idState] ?? "";
}

getCoreRequest(
    String applcationId,
    String externalId,
    INE ine,
    String email,
    String username,
    String phoneNumber,
    String cardName,
    Address cardAddress,
    double latitude,
    double longitude) {
  final edEmbosserName =
      '${ine.firstSurname}${ine.secondSurname != null && ine.secondSurname!.isNotEmpty ? ' ${ine.secondSurname}' : ''}/${ine.name}';
  final edEmbosserName2 =
      '${ine.name} ${ine.firstSurname}${ine.secondSurname != null && ine.secondSurname!.isNotEmpty ? ' ${ine.secondSurname}' : ''}';

  final now = DateTime.now();
  return {
    "Request": {
      "RequestHeader": {
        "EXT_ID": externalId,
        "CreateCustomer": "true",
        "CreateBeneficiary": "false",
        "CreateCurrentAcc": "true",
        "CreateLoanAcc": "false",
        "CreateLoanDisb": "false",
        "ActivateCustomer": "true",
        "CreateCard": "true",
        "Customer": [
          {
            "Title": ine.isMale ? '0001' : '0002',
            "FirstName": ine.name,
            "LastName": ine.firstSurname,
            "LastName2": ine.secondSurname,
            "BirthPlaceName": getCompleteState(ine.curp?.birthEntity ?? ''),
            "BirthDate": ine.birthDate!.toIso8601String(),
            "Nationality": "MX",
            "SocialSecurityNumber": ine.curp?.value,
            "VoterID": ine.voterId,
            "TaxNumber": ine.rfc,
            "isAccountHolder": "true",
            "isCorrespondenceRecipient": "true",
            "isAuthorizedDrawer": "true",
            "isMainLoanPartner": "false",
            "AddressCountry": "MX",
            "AddressRegion": ine.address.state?.isoCode ?? '',
            "AddressCity": ine.address.municipality,
            "AddressPostalCode": ine.address.postalCode,
            "AddressDistrictName": ine.address.colony,
            "AddressStreet": ine.address.street,
            "AddressHouseID": ine.address.exteriorNumber,
            "AddressRoomID": ine.address.interiorNumber ?? '',
            "EmailAddress": email,
            "MobileNumber": phoneNumber,
            "NatPersCommAct": "",
            "NegativeListStatus": "",
            "AcqChannel": "01",
            "CustSegment": "03",
            "ExtUUIDProspection": applcationId,
            "Geolocation":
                "${latitude.toStringAsFixed(6)},${longitude.toStringAsFixed(6)}"
          }
        ],
        "CurrentACC": [
          {
            "ActionCode": "01",
            "ManagerID": "50000000",
            "ProductID": "EPC_TA_N2",
            "Purpose": "Cuenta bineo ligera",
            "StartDate":
                '${now.year}${now.month < 10 ? '0' : ''}${now.month}${now.day < 10 ? '0' : ''}${now.day}',
            "Currency": "MXN",
            "ConditionGroupSettlementCode": ""
          }
        ],
        "CardInfo": [
          {
            "accountCreate": "Y",
            "baseAccount": "",
            "baseBillingCycle": 31,
            "baseCreditLimit": 0,
            "logo": 150,
            "EmbosserData": [
              {
                "edAdministrationBranch": 1,
                "edCardCreate": "Y",
                "edDigitalCardIndicator": 1,
                "edEmbosserName": cardName,
                "edAuthorizationInternetAmount": 0
              },
              {
                "edAdministrationBranch": 1,
                "edCardCreate": "Y",
                "edDigitalCardIndicator": 0,
                "edCardTechnology": "1",
                "edEmbosserName": edEmbosserName,
                "edEmbosserName2": edEmbosserName2,
                "edUser2": username,
                "edAuthorizationAtmCashAmount": "800000",
                "edAuthorizationRetailAmount": "5000000",
                "edAuthorizationInternetAmount": 1,
                "edAddress1":
                    '${cardAddress.street} ${cardAddress.exteriorNumber} ${cardAddress.interiorNumber ?? ''}',
                "edAddress2": "",
                "edCity": cardAddress.municipality,
                "edState": cardAddress.state?.id,
                "edPostalCode": cardAddress.postalCode
              }
            ]
          }
        ]
      }
    }
  };
}
