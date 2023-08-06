import 'package:meal_finder/infrastructure/services/storage/local_storage.dart';

class FavoriteRepository {
  FavoriteRepository({
    required LocaleStorage localeStorage,
  }) :_storage = localeStorage;

  final LocaleStorage _storage;

  void setFavRestaurants({required String restaurantId, required bool fav}) => fav
      ? _storage.setRestaurantAsFav(restaurantId: restaurantId)
      : _storage.removeRestaurantAsFav(restaurantId: restaurantId);

  List<String> getFavRestaurants() {
    return _storage.getFavRestaurants();
  }
}