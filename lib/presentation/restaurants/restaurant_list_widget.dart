import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_finder/application/model/restaurant.dart';
import 'package:meal_finder/application/restaurants/appbar/sliver_app_bar_cubit.dart';
import 'package:meal_finder/presentation/restaurants/restaurant_item_widget.dart';
import 'package:meal_finder/theme/app_theme.dart';
import 'package:meal_finder/utils/strings.dart';

class RestaurantListWidget extends StatefulWidget {
  const RestaurantListWidget({
    super.key,
    required this.restaurants,
  });

  final List<Restaurant> restaurants;

  @override
  State<RestaurantListWidget> createState() => _RestaurantListWidgetState();
}

class _RestaurantListWidgetState extends State<RestaurantListWidget> {
  late ScrollController _scrollController;
  late double? _expandedHeight;
  final double _maxAppBarHeight = 75;

  final double collapseThreshold = 80.0;
  final double expandThreshold = 10.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListen);
    _expandedHeight = _maxAppBarHeight;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListen);
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListen() {
    final offset = _scrollController.offset;

    if (offset > collapseThreshold && _expandedHeight != null) {
      setState(() {
        _expandedHeight = null;
      });
    } else if (offset < expandThreshold && (_expandedHeight == null || _expandedHeight != _maxAppBarHeight - offset)) {
      setState(() {
        _expandedHeight = _maxAppBarHeight - offset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          backgroundColor: appTheme.wColors.N100,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          floating: true,
          toolbarHeight: 70,
          centerTitle: false,
          expandedHeight: _expandedHeight,
          title: const _SliverAppBarTitle(),
          flexibleSpace: _expandedHeight != null ? _SliverAppBarFlexibleSpace(statusBarHeight: statusBarHeight) : null,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(title: RestaurantItemWidget(widget.restaurants[index])),
            childCount: widget.restaurants.length,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarTitle extends StatelessWidget {
  const _SliverAppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Container(
        color: appTheme.wColors.N100,
        child: const Text(Strings.sliverAppBarTitle),
      ),
    );
  }
}

class _SliverAppBarFlexibleSpace extends StatelessWidget {
  const _SliverAppBarFlexibleSpace({
    required this.statusBarHeight,
  });

  final double statusBarHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50 + statusBarHeight, left: 18),
      child: Container(
        color: appTheme.wColors.N100,
        child: BlocBuilder<SliverAppBarCubit, SliverAppBarState>(
          builder: (context, state) {
            final address =
                state.when(initial: () => Strings.sliverAppBarFlexibleSpacePlaceHolder, success: (address) => address);
            return Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 2.0),
                  child: Icon(Icons.my_location, color: Colors.blueAccent),
                ),
                Text(
                  address,
                  style: appTheme.wTextTheme.bodyMedium?.copyWith(color: Colors.blueAccent),
                  maxLines: 1,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
