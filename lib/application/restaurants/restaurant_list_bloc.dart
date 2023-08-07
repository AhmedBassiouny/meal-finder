import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_finder/application/model/restaurant.dart';
import 'package:meal_finder/application/restaurants/restaurant_provider.dart';
import 'package:meal_finder/infrastructure/favorite/favorite_repository.dart';
import 'package:meal_finder/infrastructure/geo_location/geo_location_repository.dart';
import 'package:meal_finder/infrastructure/model/location.dart';

part 'restaurant_list_event.dart';

part 'restaurant_list_state.dart';

part 'restaurant_list_bloc.freezed.dart';

class RestaurantListBloc extends Bloc<RestaurantListEvent, RestaurantListState> {
  RestaurantListBloc({
    required RestaurantProvider restaurantProvider,
    required GeoLocationRepository geoLocationRepository,
    required FavoriteRepository favoriteRepository,
  })  : _restaurantProvider = restaurantProvider,
        _geoLocationRepository = geoLocationRepository,
        _favoriteRepository = favoriteRepository,
        super(const RestaurantListState.initial()) {
    on<_Started>((_, emit) async => await _fetchData(emit));
    on<_Refresh>((_, emit) async {
      emit(const RestaurantListState.loading());
      await _fetchData(emit);
    });
    on<_LocationChanged>((event, emit) async {
      emit(const RestaurantListState.loading());
      return await _handleLocationChange(
        emit: emit,
        lat: event.lat,
        lon: event.lon,
      );
    });
    on<_FavIconPressed>(
      (event, emit) => _favoriteRepository.setFavRestaurants(
        restaurantId: event.restaurantId,
        fav: event.fav,
      ),
    );

    streamSubscription = _geoLocationRepository.getLiveLocation().listen((location) {
      add(RestaurantListEvent.locationChanged(
        lat: location.lat,
        lon: location.lon,
      ));
    });
  }

  final RestaurantProvider _restaurantProvider;
  final GeoLocationRepository _geoLocationRepository;
  final FavoriteRepository _favoriteRepository;
  StreamSubscription<Location>? streamSubscription;

  Future<void> _fetchData(Emitter<RestaurantListState> emit) async {
    final location = _geoLocationRepository.getCurrentLocation();
    await _handleLocationChange(
      emit: emit,
      lat: location.lat,
      lon: location.lon,
    );
  }

  _handleLocationChange({
    required Emitter<RestaurantListState> emit,
    required double lat,
    required double lon,
  }) async =>
      await _restaurantProvider.getNearbyRestaurants(lat: lat, lon: lon).fold(
            (error) => emit(
              RestaurantListState.failure(errorMessage: error.message),
            ),
            (result) => emit(RestaurantListState.success(restaurants: result)),
          );

  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }
}
