import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_finder/infrastructure/model/wolt_response.dart';
import 'package:meal_finder/infrastructure/item/item_repository.dart';
import 'package:meal_finder/infrastructure/services/api/wolt_remote_service.dart';
import 'package:meal_finder/utils/werror.dart';
import 'package:mocktail/mocktail.dart';

class MockWoltRemoteService extends Mock implements WoltRemoteService {}

void main() {
  group('ItemRepository', () {
    late ItemRepository repository;
    late MockWoltRemoteService mockWoltRemoteService;

    setUp(() {
      mockWoltRemoteService = MockWoltRemoteService();
      repository = ItemRepository(
        woltRemoteService: mockWoltRemoteService,
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

      final result = await repository.getItems(lat: 1.0, lon: 1.0);

      expect(result.isRight, true);
      expect(result.right, isA<List<Item>>());
    });

    test('getNearbyRestaurants returns WError when service call fails', () async {
      when(() => mockWoltRemoteService.getRestaurants(1.0, 1.0)).thenAnswer((_) async => const Left(WError("Error")));

      final result = await repository.getItems(lat: 1.0, lon: 1.0);

      expect(result.isLeft, true);
      expect(result.left, isA<WError>());
    });
  });
}
