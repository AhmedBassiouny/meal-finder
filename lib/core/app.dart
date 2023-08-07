import 'package:flutter/material.dart';
import 'package:meal_finder/core/custom_multi_repository_provider.dart';
import 'package:meal_finder/presentation/restaurants/restaurant_list_page.dart';
import 'package:meal_finder/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomMultiRepositoryProvider(
      child: MaterialApp(
        theme: appTheme.themeData,
        home: const Scaffold(body: SafeArea(child: RestaurantListPage())),
      ),
    );
  }
}