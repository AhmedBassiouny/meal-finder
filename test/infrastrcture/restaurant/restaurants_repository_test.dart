import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_finder/application/model/restaurant.dart';
import 'package:meal_finder/infrastructure/model/wolt_response.dart';
import 'package:meal_finder/infrastructure/restaurants/restaurants_repository.dart';
import 'package:meal_finder/infrastructure/services/api/wolt_remote_service.dart';
import 'package:meal_finder/infrastructure/services/storage/local_storage.dart';
import 'package:meal_finder/utils/werror.dart';
import 'package:mocktail/mocktail.dart';

class MockWoltRemoteService extends Mock implements WoltRemoteService {}

class MockLocaleStorage extends Mock implements LocaleStorage {}

void main() {
  group('RestaurantsRepository', () {
    late RestaurantsRepository repository;
    late MockWoltRemoteService mockWoltRemoteService;
    late MockLocaleStorage mockLocaleStorage;

    setUp(() {
      mockWoltRemoteService = MockWoltRemoteService();
      mockLocaleStorage = MockLocaleStorage();
      repository = RestaurantsRepository(
        woltRemoteService: mockWoltRemoteService,
        localeStorage: mockLocaleStorage,
      );
    });

    test('getNearbyRestaurants returns list of Restaurant', () async {
      when(() => mockWoltRemoteService.getRestaurants(1.0, 1.0))
          .thenAnswer((_) async => const Right(WoltResponse(sections: [
                Section(name: 'restaurants-delivering-venues', title: 'Delivering', items: [
                  Item(
                      contentID: '1',
                      image: Image(blurhash: 'blurhash', url: 'url'),
                      venue: Venue(id: '1', name: 'Restaurant 1', shortDescription: 'Description 1'))
                ])
              ])));
      when(() => mockLocaleStorage.getFavRestaurants()).thenReturn(<String>['1', '2', '3']);

      final result = await repository.getNearbyRestaurants(lat: 1.0, lon: 1.0);

      expect(result.isRight, true);
      expect(result.right, isA<List<Restaurant>>());
    });

    test('getNearbyRestaurants returns WError when service call fails', () async {
      when(() => mockWoltRemoteService.getRestaurants(1.0, 1.0)).thenAnswer((_) async => Left(WError("Error")));

      final result = await repository.getNearbyRestaurants(lat: 1.0, lon: 1.0);

      expect(result.isLeft, true);
      expect(result.left, isA<WError>());
    });
  });
}
