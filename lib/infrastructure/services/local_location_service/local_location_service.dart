import 'dart:async';

import 'package:meal_finder/infrastructure/model/location.dart';

class LocalLocationService {
  int _currentListIndex = 0;

  LocalLocationService();

  Stream<Location> getLiveLocation() {
    final controller = StreamController<Location>();

    // Send the initial event immediately upon subscription
    controller.add(_CONSTANTS.mockLocations[0]);

    Timer.periodic(
      const Duration(seconds: _CONSTANTS.refreshInterval),
      (_) {
        if (_currentListIndex >= _CONSTANTS.mockLocations.length) {
          _currentListIndex = 0;
        }
        controller.add(_CONSTANTS.mockLocations[_currentListIndex++]);
      },
    );

    return controller.stream;
  }

  Location getCurrentLocation() {
    final index = _currentListIndex - 1 > -1 ? _currentListIndex - 1 : 0;
    return _CONSTANTS.mockLocations[index];
  }
}

class _CONSTANTS {
  static const int refreshInterval = 10;

  static const mockLocations = [
    Location(lat: 60.170187, lon: 24.930599, address: "Jaakonkatu 5, Helsinki"),
    Location(lat: 60.169418, lon: 24.931618, address: "Jaakonkatu 3, Helsinki"),
    Location(lat: 60.169818, lon: 24.932906, address: "Urho Kekkosen katu 1, Helsinki"),
    Location(lat: 60.170005, lon: 24.935105, address: "Narinken 2, 00100 Helsingfors"),
    Location(lat: 60.169108, lon: 24.936210, address: "Simonkatu, Helsinki"),
    Location(lat: 60.168355, lon: 24.934869, address: "Annankatu 32, Helsinki"),
    Location(lat: 60.167560, lon: 24.932562, address: "Fredrikinkatu, Helsinki"),
    Location(lat: 60.168254, lon: 24.931532, address: "Urho Kekkosen katu 8, Helsinki"),
    Location(lat: 60.169012, lon: 24.930341, address: "Fredrikinkatu 46, Helsinki"),
    Location(lat: 60.170085, lon: 24.929569, address: "Eteläinen Rautatiekatu 8, Helsinki"),
  ];
}
