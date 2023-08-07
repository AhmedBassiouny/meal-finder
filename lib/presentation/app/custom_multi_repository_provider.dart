import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_finder/application/restaurants/restaurant_provider.dart';
import 'package:meal_finder/infrastructure/favorite/favorite_repository.dart';
import 'package:meal_finder/infrastructure/geo_location/geo_location_repository.dart';
import 'package:meal_finder/infrastructure/item/item_repository.dart';
import 'package:meal_finder/infrastructure/services/api/wolt_remote_service.dart';
import 'package:meal_finder/infrastructure/services/local_location_service/local_location_service.dart';
import 'package:meal_finder/infrastructure/services/storage/local_storage.dart';
import 'package:provider/single_child_widget.dart';

class CustomMultiRepositoryProvider extends MultiRepositoryProvider {
  CustomMultiRepositoryProvider({
    required Widget child,
  }) : super(key: null, child: child, providers: _getRepositories());

  static List<SingleChildWidget> _getRepositories() {
    final woltRemoteService = WoltRemoteService();
    final localeStorage = LocaleStorage();
    final localLocationProvider = LocalLocationService();
    final itemRepository = ItemRepository(woltRemoteService: woltRemoteService);
    final favoriteRepository = FavoriteRepository(localeStorage: localeStorage);
    final restaurantProvider =
        RestaurantProvider(itemRepository: itemRepository, favoriteRepository: favoriteRepository);
    final geoLocationRepository = GeoLocationRepository(localLocationProvider: localLocationProvider);

    return [
      RepositoryProvider(create: (_) => woltRemoteService),
      RepositoryProvider(create: (_) => localeStorage),
      RepositoryProvider(create: (_) => itemRepository),
      RepositoryProvider(create: (_) => favoriteRepository),
      RepositoryProvider(create: (_) => restaurantProvider),
      RepositoryProvider(create: (_) => geoLocationRepository),
    ];
  }
}
