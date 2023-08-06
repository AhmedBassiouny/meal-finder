import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_finder/infrastructure/geo_location/geo_location_repository.dart';
import 'package:meal_finder/infrastructure/restaurants/restaurants_repository.dart';
import 'package:meal_finder/infrastructure/services/api/wolt_remote_service.dart';
import 'package:meal_finder/infrastructure/services/local_location_service/local_location_service.dart';
import 'package:meal_finder/infrastructure/services/storage/local_storage.dart';
import 'package:meal_finder/presentation/restaurants/restaurant_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final woltRemoteService = WoltRemoteService();
    final localeStorage = LocaleStorage();
    final localLocationProvider = LocalLocationService();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => woltRemoteService),
        RepositoryProvider(create: (_) => localeStorage),
        RepositoryProvider(
          create: (_) => RestaurantsRepository(
            woltRemoteService: woltRemoteService,
            localeStorage: localeStorage,
          ),
        ),
        RepositoryProvider(
          create: (_) => GeoLocationRepository(
            localLocationProvider: localLocationProvider,
          ),
        ),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const Scaffold(body: SafeArea(child: RestaurantListPage())),
    );
  }
}
