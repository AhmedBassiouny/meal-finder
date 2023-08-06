part of 'restaurant_list_bloc.dart';

@freezed
class RestaurantListState with _$RestaurantListState {
  const factory RestaurantListState.initial() = _Initial;

  const factory RestaurantListState.loading() = _Loading;

  const factory RestaurantListState.success({
    required List<Restaurant> restaurants,
  }) = _Success;

  const factory RestaurantListState.failure({
    required String errorMessage,
  }) = _Failure;
}
