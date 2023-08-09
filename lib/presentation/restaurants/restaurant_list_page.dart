import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_finder/application/restaurants/restaurant_list_bloc.dart';
import 'package:meal_finder/presentation/restaurants/restaurant_list_widget.dart';
import 'package:meal_finder/presentation/widgets/error_screen.dart';
import 'package:meal_finder/presentation/widgets/loading_widget.dart';
import 'package:meal_finder/theme/app_theme.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RestaurantListView();
  }
}

class _RestaurantListView extends StatelessWidget {
  const _RestaurantListView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.wColors.N100,
      child: BlocBuilder<RestaurantListBloc, RestaurantListState>(
        buildWhen: (_, state) => !state.isProcessingLocationChange,
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: state.whenOrNull(
              initial: () => const LoadingWidget(),
              loading: () => const LoadingWidget(),
              success: (restaurants) {
                return RestaurantListWidget(restaurants: restaurants);
              },
              failure: (e) => ErrorScreen(errorMessage: e, onRetry: () => _onRetryTappedAction(context)),
            ),
          );
        },
      ),
    );
  }

  void _onRetryTappedAction(BuildContext context) =>
      context.read<RestaurantListBloc>().add(const RestaurantListEvent.refresh());
}
