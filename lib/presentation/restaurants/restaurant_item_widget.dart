import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_finder/application/model/restaurant.dart';
import 'package:meal_finder/application/restaurants/restaurant_list_bloc.dart';
import 'package:meal_finder/presentation/widgets/heart_fav_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meal_finder/theme/app_theme.dart';

class RestaurantItemWidget extends StatelessWidget {
  final Restaurant _restaurant;

  const RestaurantItemWidget(restaurant, {super.key}) : _restaurant = restaurant;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: appTheme.wColors.N100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.5,
      child: Column(
        children: [
          Ink.image(
            image: CachedNetworkImageProvider(_restaurant.imageUrl),
            height: 180,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        _restaurant.name,
                        style: appTheme.wTextTheme.headlineSmall,
                        maxLines: 1,
                      ),
                      if (_restaurant.shortDescription != null)
                        Text(
                          _restaurant.shortDescription!,
                          style: appTheme.wTextTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                HeartFavWidget(
                  key: Key(_restaurant.id),
                  isSelected: _restaurant.fav,
                  onSelected: () => context.read<RestaurantListBloc>().add(
                        RestaurantListEvent.favIconPressed(
                          restaurantId: _restaurant.id,
                          fav: true,
                        ),
                      ),
                  onDeselected: () => context.read<RestaurantListBloc>().add(
                        RestaurantListEvent.favIconPressed(
                          restaurantId: _restaurant.id,
                          fav: false,
                        ),
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
