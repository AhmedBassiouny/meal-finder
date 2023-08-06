import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant.freezed.dart';


@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant({
    required String id,
    required String name,
    required String imageUrl,
    required String blurImage,
    required bool fav,
    String? shortDescription,
  }) = _Restaurant;
}