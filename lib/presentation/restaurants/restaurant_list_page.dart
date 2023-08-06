import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_finder/application/restaurants/restaurant_list_bloc.dart';
import 'package:meal_finder/application/restaurants/restaurant_provider.dart';
import 'package:meal_finder/infrastructure/favorite/favorite_repository.dart';
import 'package:meal_finder/infrastructure/geo_location/geo_location_repository.dart';
import 'package:meal_finder/presentation/restaurants/restaurant_list_widget.dart';
import 'package:meal_finder/presentation/widgets/error_screen.dart';
import 'package:meal_finder/presentation/widgets/loading_widget.dart';
import 'package:meal_finder/theme/app_theme.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RestaurantListBloc>(
      create: (context) => RestaurantListBloc(
        restaurantProvider: context.read<RestaurantProvider>(),
        geoLocationRepository: context.read<GeoLocationRepository>(),
        favoriteRepository: context.read<FavoriteRepository>(),
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
      color: appTheme.wColors.N100,
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
