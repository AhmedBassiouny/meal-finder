// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wolt_response.freezed.dart';

part 'wolt_response.g.dart';

@freezed
class WoltResponse with _$WoltResponse {
  const factory WoltResponse({
    required List<Section> sections,
  }) = _WoltResponse;

  factory WoltResponse.fromJson(Map<String, dynamic> json) =>
      _$WoltResponseFromJson(json);
}

@freezed
class Section with _$Section {
  const factory Section({
    required List<Item> items,
    required String name,
    required String title,
  }) = _Section;

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);
}

@freezed
class Item with _$Item {
  const factory Item({
    String? contentID,
    required Image image,
    Venue? venue,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) =>
      _$ItemFromJson(json);
}

@freezed
class Image with _$Image {
  const factory Image({
    required String url,
  }) = _Image;

  factory Image.fromJson(Map<String, dynamic> json) =>
      _$ImageFromJson(json);
}

@freezed
class Venue with _$Venue {
  const factory Venue({
    required String id,
    required String name,
    @JsonKey(name: 'short_description')
    String? shortDescription,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) =>
      _$VenueFromJson(json);
}