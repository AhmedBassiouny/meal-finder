import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_finder/application/restaurants/restaurant_list_bloc.dart';
import 'package:meal_finder/infrastructure/geo_location/geo_location_repository.dart';
import 'package:meal_finder/infrastructure/restaurants/restaurants_repository.dart';
import 'package:meal_finder/presentation/restaurants/restaurant_list_widget.dart';
import 'package:meal_finder/presentation/widgets/error_screen.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RestaurantListBloc>(
      create: (context) => RestaurantListBloc(
        restaurantsRepository: context.read<RestaurantsRepository>(),
        geoLocationRepository: context.read<GeoLocationRepository>(),
      ),
      child: const _RestaurantListView(),
    );
  }
}

class _RestaurantListView extends StatelessWidget {
  const _RestaurantListView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFEFEFEFF),
      child: BlocBuilder<RestaurantListBloc, RestaurantListState>(
        builder: (context, state) => state.when(
          initial: () => const LoadingWidget(),
          loading: () => const LoadingWidget(),
          success: (restaurants) => RestaurantListWidget(restaurants: restaurants),
          failure: (e) => ErrorScreen(
            errorMessage: e,
            onRetry: () => context.read<RestaurantListBloc>().add(const RestaurantListEvent.refresh()),
          ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 80.0),
              child: Image.asset(
                "assets/images/wolt_loading.gif",
                height: 225.0,
                width: 225.0,
              ),
            ),
            const Text(
              "Searching for Nearby Restaurants",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
