import 'package:either_dart/either.dart';
import 'package:meal_finder/application/model/restaurant.dart';
import 'package:meal_finder/infrastructure/model/wolt_response.dart';
import 'package:meal_finder/infrastructure/services/api/wolt_remote_service.dart';
import 'package:meal_finder/infrastructure/services/storage/local_storage.dart';
import 'package:meal_finder/utils/werror.dart';

class RestaurantsRepository {
  RestaurantsRepository({
    required WoltRemoteService woltRemoteService,
    required LocaleStorage localeStorage,
  })  : _service = woltRemoteService,
        _storage = localeStorage;

  final WoltRemoteService _service;
  final LocaleStorage _storage;

  Future<Either<WError, List<Restaurant>>> getNearbyRestaurants({
    required double lat,
    required double lon,
  }) async {
    return _getRestaurantsFromApi(lat: lat, lon: lon).mapRight((items) {
      final favRestaurantsIds = _getFavRestaurants();
      return _mergeRemoteAndLocalData(favRestaurantsIds, items);
    });
  }

  void setFavRestaurants({required String restaurantId, required bool fav}) => fav
      ? _storage.setRestaurantAsFav(restaurantId: restaurantId)
      : _storage.removeRestaurantAsFav(restaurantId: restaurantId);

  List<String> _getFavRestaurants() {
    return _storage.getFavRestaurants();
  }

  Future<Either<WError, List<Item>>> _getRestaurantsFromApi({
    required double lat,
    required double lon,
  }) async {
    try {
      return _service
          .getRestaurants(lat, lon)
          .mapRight(
            (right) => right.sections.firstWhere(
              (section) => section.name == "restaurants-delivering-venues",
            ),
          )
          .thenRight((section) => Right(section.items));
    } catch (e) {
      return const Left(
          WError("It’s not you, it’s us! We’re working hard to expand and hope to come to your area soon 😌"));
    }
  }

  List<Restaurant> _mergeRemoteAndLocalData(
    List<String> ids,
    List<Item> items,
  ) {
    final idSet = Set.from(ids);
    final results = <Restaurant>[];
    for (final item in items) {
      results.add(item.toRestaurant(fav: idSet.contains(item.venue?.id)));
    }
    return results;
  }
}

extension on Item {
  Restaurant toRestaurant({required bool fav}) => Restaurant(
        id: venue?.id ?? "id",
        name: venue?.name ?? "name",
        imageUrl: image.url,
        blurImage: image.blurhash,
        shortDescription: venue?.shortDescription,
        fav: fav,
      );
}
