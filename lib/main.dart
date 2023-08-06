import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_finder/application/restaurants/restaurant_provider.dart';
import 'package:meal_finder/infrastructure/favorite/favorite_repository.dart';
import 'package:meal_finder/infrastructure/geo_location/geo_location_repository.dart';
import 'package:meal_finder/infrastructure/item/item_repository.dart';
import 'package:meal_finder/infrastructure/services/api/wolt_remote_service.dart';
import 'package:meal_finder/infrastructure/services/local_location_service/local_location_service.dart';
import 'package:meal_finder/infrastructure/services/storage/local_storage.dart';
import 'package:meal_finder/presentation/restaurants/restaurant_list_page.dart';
import 'package:meal_finder/theme/app_theme.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final woltRemoteService = WoltRemoteService();
    final localeStorage = LocaleStorage();
    final localLocationProvider = LocalLocationService();
    final itemRepository = ItemRepository(woltRemoteService: woltRemoteService);
    final favoriteRepository = FavoriteRepository(localeStorage: localeStorage);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => woltRemoteService),
        RepositoryProvider(create: (_) => localeStorage),
        RepositoryProvider(create: (_) => itemRepository),
        RepositoryProvider(create: (_) => favoriteRepository),
        RepositoryProvider(
            create: (_) => RestaurantProvider(itemRepository: itemRepository, favoriteRepository: favoriteRepository)),
        RepositoryProvider(create: (_) => GeoLocationRepository(localLocationProvider: localLocationProvider)),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Finder',
      theme: appTheme.themeData,
      home: const Scaffold(body: SafeArea(child: RestaurantListPage())),
    );
  }
}
