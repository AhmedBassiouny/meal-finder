import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_finder/application/restaurants/restaurant_list_bloc.dart';

part 'sliver_app_bar_state.dart';

part 'sliver_app_bar_cubit.freezed.dart';

class SliverAppBarCubit extends Cubit<SliverAppBarState> {
  SliverAppBarCubit({
    required RestaurantListBloc restaurantListBloc,
  })  : _restaurantListBloc = restaurantListBloc,
        super(const SliverAppBarState.initial()) {
    _restaurantListBloc.stream.listen((state) {
      state.whenOrNull(
        processingLocationChange: (location) => emit(
          SliverAppBarState.success(address: location.address),
        ),
      );
    });
  }

  final RestaurantListBloc _restaurantListBloc;
}
