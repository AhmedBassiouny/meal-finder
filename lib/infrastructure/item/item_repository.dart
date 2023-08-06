import 'package:either_dart/either.dart';
import 'package:meal_finder/infrastructure/model/wolt_response.dart';
import 'package:meal_finder/infrastructure/services/api/wolt_remote_service.dart';
import 'package:meal_finder/utils/werror.dart';

class ItemRepository {
  ItemRepository({
    required WoltRemoteService woltRemoteService,
  }) : _service = woltRemoteService;

  final WoltRemoteService _service;

  Future<Either<WError, List<Item>>> getItems({
    required double lat,
    required double lon,
  }) async =>
      _fetchAndExtractItemsFromApi(lat: lat, lon: lon);

  Future<Either<WError, List<Item>>> _fetchAndExtractItemsFromApi({
    required double lat,
    required double lon,
  }) async {
    try {
      return _service
          .getRestaurants(lat, lon)
          .mapRight(
            (right) => right.sections.firstWhere(
              (section) => section.name == "restaurants-delivering-venues",
            ),
          )
          .thenRight((section) => Right(section.items));
    } catch (e) {
      return const Left(
          WError("It’s not you, it’s us! We’re working hard to expand and hope to come to your area soon 😌"));
    }
  }
}
