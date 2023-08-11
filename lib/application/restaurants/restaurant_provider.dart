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
    var count = 0;
    return items.where((item) {
      if (item.venue != null && count < 15) {
        count++;
        return true;
      }
      return false;
    }).map((item) {
      final fav = idSet.contains(item.venue?.id);
      return item.toRestaurant(fav: fav)!;
    }).toList();
  }
}

extension on Item {
  Restaurant? toRestaurant({required bool fav}) {
    if (venue == null) {
      return null;
    } else {
      return Restaurant(
        id: venue!.id,
        name: venue!.name,
        imageUrl: image.url,
        shortDescription: venue!.shortDescription,
        fav: fav,
      );
    }
  }
}
