import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:meal_finder/application/model/restaurant.dart';
import 'package:meal_finder/application/restaurants/restaurant_list_bloc.dart';
import 'package:meal_finder/presentation/widgets/heart_fav_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meal_finder/theme/app_theme.dart';

class RestaurantItemWidget extends StatelessWidget {
  final Restaurant _restaurant;

  const RestaurantItemWidget(this._restaurant, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: appTheme.wColors.N100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0.5,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: _restaurant.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              height: 180,
              placeholder: (_, __) => _blurHashPlaceholder,
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
                    onSelected: () => _onFavTapped(context: context, selected: true),
                    onDeselected: () => _onFavTapped(context: context, selected: false),
                  ),
                ],
              ),
            )
          ],
        ),
      );

  void _onFavTapped({
    required BuildContext context,
    required bool selected,
  }) =>
      context.read<RestaurantListBloc>().add(
            RestaurantListEvent.favIconPressed(
              restaurantId: _restaurant.id,
              fav: selected,
            ),
          );
}

const _blurHashPlaceholder = AspectRatio(
  aspectRatio: 1.6,
  child: BlurHash(hash: "LKN]Rv%2Tw=w]~RBVZRi};RPxuwH"),
);
