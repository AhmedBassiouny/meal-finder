import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_finder/application/restaurants/restaurant_list_bloc.dart';
import 'package:meal_finder/application/restaurants/restaurant_provider.dart';
import 'package:meal_finder/infrastructure/favorite/favorite_repository.dart';
import 'package:meal_finder/infrastructure/geo_location/geo_location_repository.dart';
import 'package:meal_finder/infrastructure/model/location.dart';
import 'package:meal_finder/utils/werror.dart';
import 'package:mocktail/mocktail.dart';

class MockRestaurantProvider extends Mock implements RestaurantProvider {}

class MockGeoLocationRepository extends Mock implements GeoLocationRepository {}

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  group('RestaurantListBloc', () {
    late MockRestaurantProvider mockRestaurantProvider;
    late MockGeoLocationRepository mockGeoLocationRepository;
    late MockFavoriteRepository mockFavoriteRepository;

    const location = Location(lat: 60.169108, lon: 24.936210, address: "Simonkatu, Helsinki");

    setUp(() {
      mockRestaurantProvider = MockRestaurantProvider();
      mockGeoLocationRepository = MockGeoLocationRepository();
      mockFavoriteRepository = MockFavoriteRepository();
    });

    blocTest<RestaurantListBloc, RestaurantListState>(
      'emits [RestaurantListState.loading(), RestaurantListState.success()] when _Started is added',
      setUp: () {
        StreamController<Location> locationStreamController = StreamController<Location>();
        when(() => mockGeoLocationRepository.getCurrentLocation()).thenAnswer((_) => location);
        when(() => mockRestaurantProvider.getNearbyRestaurants(lat: any(named: 'lat'), lon: any(named: 'lon')))
            .thenAnswer((_) => Future.value(const Right([])));
        when(() => mockGeoLocationRepository.getLiveLocation()).thenAnswer((_) => locationStreamController.stream);
      },
      build: () => RestaurantListBloc(
        restaurantProvider: mockRestaurantProvider,
        geoLocationRepository: mockGeoLocationRepository,
        favoriteRepository: mockFavoriteRepository,
      ),
      act: (bloc) => bloc.add(const RestaurantListEvent.started()),
      expect: () => [const RestaurantListState.success(restaurants: [])],
    );

    blocTest<RestaurantListBloc, RestaurantListState>(
      'emits [RestaurantListState.loading(), RestaurantListState.success()] when _Refresh is added',
      setUp: () {
        StreamController<Location> locationStreamController = StreamController<Location>();
        when(() => mockGeoLocationRepository.getCurrentLocation()).thenAnswer((_) => location);
        when(() => mockRestaurantProvider.getNearbyRestaurants(lat: any(named: 'lat'), lon: any(named: 'lon')))
            .thenAnswer((_) => Future.value(const Right([])));
        when(() => mockGeoLocationRepository.getLiveLocation()).thenAnswer((_) => locationStreamController.stream);
      },
      build: () => RestaurantListBloc(
        restaurantProvider: mockRestaurantProvider,
        geoLocationRepository: mockGeoLocationRepository,
        favoriteRepository: mockFavoriteRepository,
      ),
      act: (bloc) => bloc.add(const RestaurantListEvent.refresh()),
      expect: () => [const RestaurantListState.loading(), const RestaurantListState.success(restaurants: [])],
    );

    blocTest<RestaurantListBloc, RestaurantListState>(
      'emits [RestaurantListState.loading(), RestaurantListState.failure()] when _Refresh is added but fail to get list',
      setUp: () {
        StreamController<Location> locationStreamController = StreamController<Location>();
        when(() => mockGeoLocationRepository.getCurrentLocation()).thenAnswer((_) => location);
        when(() => mockRestaurantProvider.getNearbyRestaurants(lat: any(named: 'lat'), lon: any(named: 'lon')))
            .thenAnswer((_) => Future.value(const Left(WError("error"))));
        when(() => mockGeoLocationRepository.getLiveLocation()).thenAnswer((_) => locationStreamController.stream);
      },
      build: () => RestaurantListBloc(
        restaurantProvider: mockRestaurantProvider,
        geoLocationRepository: mockGeoLocationRepository,
        favoriteRepository: mockFavoriteRepository,
      ),
      act: (bloc) => bloc.add(const RestaurantListEvent.refresh()),
      expect: () => [const RestaurantListState.loading(), const RestaurantListState.failure(errorMessage: "error")],
    );

    blocTest<RestaurantListBloc, RestaurantListState>(
      'emits [RestaurantListState.loading(), RestaurantListState.success()] when _LocationChanged is added',
      setUp: () {
        StreamController<Location> locationStreamController = StreamController<Location>();
        when(() => mockRestaurantProvider.getNearbyRestaurants(lat: any(named: 'lat'), lon: any(named: 'lon')))
            .thenAnswer((_) => Future.value(const Right([])));
        when(() => mockGeoLocationRepository.getLiveLocation()).thenAnswer((_) => locationStreamController.stream);
      },
      build: () => RestaurantListBloc(
        restaurantProvider: mockRestaurantProvider,
        geoLocationRepository: mockGeoLocationRepository,
        favoriteRepository: mockFavoriteRepository,
      ),
      act: (bloc) => bloc.add(const RestaurantListEvent.locationChanged(lat: 0.0, lon: 0.0)),
      expect: () => [const RestaurantListState.loading(), const RestaurantListState.success(restaurants: [])],
    );

    blocTest<RestaurantListBloc, RestaurantListState>(
      'checks if setFavRestaurants() in ItemRepository is called when _FavIconPressed is added',
      setUp: () {
        StreamController<Location> locationStreamController = StreamController<Location>();
        when(() => mockGeoLocationRepository.getLiveLocation()).thenAnswer((_) => locationStreamController.stream);
      },
      build: () => RestaurantListBloc(
        restaurantProvider: mockRestaurantProvider,
        geoLocationRepository: mockGeoLocationRepository,
        favoriteRepository: mockFavoriteRepository,
      ),
      act: (bloc) => bloc.add(const RestaurantListEvent.favIconPressed(restaurantId: '123', fav: true)),
      verify: (_) {
        verify(() => mockFavoriteRepository.setFavRestaurants(restaurantId: '123', fav: true)).called(1);
      },
    );
  });
}
