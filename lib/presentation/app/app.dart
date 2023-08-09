import 'package:flutter/material.dart';
import 'package:meal_finder/presentation/app/custom_multi_bloc_provider.dart';
import 'package:meal_finder/presentation/app/custom_multi_repository_provider.dart';
import 'package:meal_finder/presentation/restaurants/restaurant_list_page.dart';
import 'package:meal_finder/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomMultiRepositoryProvider(
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return CustomMultiBlocProvider(
      context: context,
      child: MaterialApp(
        theme: appTheme.themeData,
        home: const Scaffold(body: SafeArea(child: RestaurantListPage())),
      ),
    );
  }
}