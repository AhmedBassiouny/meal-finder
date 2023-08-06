import 'package:either_dart/either.dart';
import 'package:meal_finder/application/model/restaurant.dart';
import 'package:meal_finder/infrastructure/favorite/favorite_repository.dart';
import 'package:meal_finder/infrastructure/item/item_repository.dart';
import 'package:meal_finder/infrastructure/model/wolt_response.dart';
import 'package:meal_finder/utils/werror.dart';

class RestaurantProvider {
  RestaurantProvider({
    required ItemRepository itemRepository,
    required FavoriteRepository favoriteRepository,
  })  : _itemRepository = itemRepository,
        _favoriteRepository = favoriteRepository;

  final ItemRepository _itemRepository;
  final FavoriteRepository _favoriteRepository;

  Future<Either<WError, List<Restaurant>>> getNearbyRestaurants({
    required double lat,
    required double lon,
  }) async {
    return _itemRepository.getItems(lat: lat, lon: lon).mapRight((items) {
      final favRestaurantsIds = _favoriteRepository.getFavRestaurants();
      return _mergeRemoteAndLocalData(favRestaurantsIds, items);
    });
  }

  List<Restaurant> _mergeRemoteAndLocalData(
    List<String> ids,
    List<Item> items,
  ) {
    final idSet = Set.from(ids);
    final results = <Restaurant>[];
    for (final item in items.take(15)) {
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
        shortDescription: venue?.shortDescription,
        fav: fav,
      );
}
