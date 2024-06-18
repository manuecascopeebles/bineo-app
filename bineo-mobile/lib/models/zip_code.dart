class ZipCode {
  String zipcode;
  CountryState state;
  String borough;
  String boroughId;
  List<String> neighborhoods;

  ZipCode({
    required this.zipcode,
    required this.state,
    required this.borough,
    required this.boroughId,
    required this.neighborhoods,
  });

  // Factory constructor to create a ZipCode instance from JSON
  factory ZipCode.fromMap(Map<String, dynamic> map) {
    return ZipCode(
      zipcode: map['zipcode'] ?? '',
      state: CountryState.fromMap(map),
      borough: map['borough'] ?? '',
      boroughId: map['borough_id'] ?? '',
      neighborhoods: [], // Initialize as an empty list or you can modify based on your requirement
    );
  }
}

class CountryState {
  String name;
  String id;
  String isoCode;

  CountryState({
    required this.name,
    required this.id,
    required this.isoCode,
  });

  factory CountryState.fromMap(Map<String, dynamic> map) {
    return CountryState(
      name: map['state'] ?? '',
      id: map['state_id'] ?? '',
      isoCode: map['state_iso'] ?? '',
    );
  }
}
