import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_finder/application/model/restaurant.dart';
import 'package:meal_finder/infrastructure/geo_location/geo_location_repository.dart';
import 'package:meal_finder/infrastructure/restaurants/restaurants_repository.dart';

part 'restaurant_list_event.dart';

part 'restaurant_list_state.dart';

part 'restaurant_list_bloc.freezed.dart';

class RestaurantListBloc extends Bloc<RestaurantListEvent, RestaurantListState> {
  RestaurantListBloc({
    required RestaurantsRepository restaurantsRepository,
    required GeoLocationRepository geoLocationRepository,
  })  : _restaurantsRepository = restaurantsRepository,
        _geoLocationRepository = geoLocationRepository,
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
      (event, emit) => _restaurantsRepository.setFavRestaurants(
        restaurantId: event.restaurantId,
        fav: event.fav,
      ),
    );

    _geoLocationRepository.getLiveLocation().listen((location) {
      add(RestaurantListEvent.locationChanged(
          lat: location.lat,
          lon: location.lon,
        ));
    });
  }

  final RestaurantsRepository _restaurantsRepository;
  final GeoLocationRepository _geoLocationRepository;

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
  }) async {
    await _restaurantsRepository.getNearbyRestaurants(lat: lat, lon: lon).fold(
          (error) => emit(
            RestaurantListState.failure(errorMessage: error.message),
          ),
          (result) => emit(RestaurantListState.success(restaurants: result)),
        );
  }
}
