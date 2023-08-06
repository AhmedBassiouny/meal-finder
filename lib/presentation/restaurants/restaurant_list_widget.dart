import 'package:flutter/material.dart';
import 'package:meal_finder/application/model/restaurant.dart';
import 'package:meal_finder/presentation/restaurants/restaurant_item_widget.dart';
import 'package:meal_finder/theme/app_theme.dart';

class RestaurantListWidget extends StatelessWidget {
  const RestaurantListWidget({
    super.key,
    required this.restaurants,
  });

  final List<Restaurant> restaurants;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text("Nearby Restaurants"),
          floating: true,
          flexibleSpace: Container(color: appTheme.wColors.N100),
          expandedHeight: 20,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(title: RestaurantItemWidget(restaurants[index])),
            childCount: restaurants.length,
          ),
        ),
      ],
    );
  }
}
