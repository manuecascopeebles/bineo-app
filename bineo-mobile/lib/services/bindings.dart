import 'package:bineo/services/auth_service.dart';
import 'package:bineo/services/core/injector.dart';
import 'package:bineo/services/interfaces/iauth_service.dart';
import 'package:bineo/services/interfaces/ionboarding_service.dart';
import 'package:bineo/services/interfaces/iseon_service.dart';
import 'package:bineo/services/interfaces/igeo_location_service.dart';
import 'package:bineo/services/geo_location/geo_location_service.dart';
import 'package:bineo/services/onboarding/onboarding_service.dart';
import 'package:bineo/services/seon/seon_service.dart';

class Bindings {
  static void register() {
    Injector.register<IAuthService>(() => AuthService());

    final seonService = Injector.register<ISeonService>(() => SeonService());
    Injector.register<IGeoLocationService>(
        () => GeoLocationService(seonService));
    Injector.register<IOnboardingService>(() => OnboardingService());
  }
}
