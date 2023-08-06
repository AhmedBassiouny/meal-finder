import 'package:meal_finder/infrastructure/model/location.dart';
import 'package:meal_finder/infrastructure/services/local_location_service/local_location_service.dart';

class GeoLocationRepository {
  GeoLocationRepository({
    required LocalLocationService localLocationProvider,
  }) : _localLocationProvider = localLocationProvider;

  final LocalLocationService _localLocationProvider;

  Stream<Location> getLiveLocation() =>
      _localLocationProvider.getLiveLocation();

  Location getCurrentLocation() =>
      _localLocationProvider.getCurrentLocation();
}
