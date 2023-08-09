part of 'restaurant_list_bloc.dart';

@freezed
class RestaurantListEvent with _$RestaurantListEvent {
  const factory RestaurantListEvent.started() = _Started;

  const factory RestaurantListEvent.refresh() = _Refresh;

  const factory RestaurantListEvent.favIconPressed({
    required String restaurantId,
    required bool fav,
  }) = _FavIconPressed;

  const factory RestaurantListEvent.locationChanged({
    required Location location,
  }) = _LocationChanged;
}
