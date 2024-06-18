import 'package:bineo/apis/bineo_api.dart';
import 'package:bineo/services/interfaces/igeo_location_service.dart';
import 'package:bineo/services/interfaces/iseon_service.dart';

class GeoLocationService extends IGeoLocationService {
  final ISeonService _seonService;
  GeoLocationService(this._seonService);

  @override
  Future<bool> validate(double latitude, double longitude) async {
    final isValid = await BineoAPI.instance
        .validateLocation(latitude, longitude, _seonService.transactionId);
    return isValid;
  }
}
