part of 'sliver_app_bar_cubit.dart';

@freezed
class SliverAppBarState with _$SliverAppBarState {
  const factory SliverAppBarState.initial() = _Initial;

  const factory SliverAppBarState.success({required String address}) = _Success;
}
