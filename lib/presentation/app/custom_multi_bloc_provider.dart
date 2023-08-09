import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_finder/application/restaurants/appbar/sliver_app_bar_cubit.dart';
import 'package:meal_finder/application/restaurants/restaurant_list_bloc.dart';
import 'package:meal_finder/application/restaurants/restaurant_provider.dart';
import 'package:meal_finder/infrastructure/favorite/favorite_repository.dart';
import 'package:meal_finder/infrastructure/geo_location/geo_location_repository.dart';
import 'package:provider/single_child_widget.dart';

class CustomMultiBlocProvider extends MultiBlocProvider {
  CustomMultiBlocProvider({
    required BuildContext context,
    required Widget child,
  }) : super(key: null, child: child, providers: _getBlocs(context: context));

  static List<SingleChildWidget> _getBlocs({required BuildContext context}) {
    final restaurantListBloc = RestaurantListBloc(
      restaurantProvider: context.read<RestaurantProvider>(),
      geoLocationRepository: context.read<GeoLocationRepository>(),
      favoriteRepository: context.read<FavoriteRepository>(),
    );
    final sliverAppBarCubit = SliverAppBarCubit(restaurantListBloc: restaurantListBloc);

    return [
      BlocProvider(create: (_) => restaurantListBloc),
      BlocProvider(create: (_) => sliverAppBarCubit),
    ];
  }
}
