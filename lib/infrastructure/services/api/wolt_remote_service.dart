import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meal_finder/infrastructure/model/wolt_response.dart';
import 'package:meal_finder/utils/logs_reporter.dart';
import 'package:meal_finder/utils/werror.dart';

part 'wolt_remote_service.freezed.dart';

class WoltRemoteService {
  final Dio _dio;

  WoltRemoteService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 30),
              ),
            );

  Future<Either<WError, WoltResponse>> getRestaurants(
    double lat,
    double lon,
  ) async {
    const endPoint = "/v1/pages/restaurants";

    return _doHttpRequest(
      _HttpRequest.get(path: endPoint, query: {
        "lat": lat.toString(),
        "lon": lon.toString(),
      }),
    ).mapRight((json) => WoltResponse.fromJson(json));
  }

  Future<Either<WError, dynamic>> _doHttpRequest(_HttpRequest request) async {
    try {
      final Response response = await request.map(
        get: (r) async => _dio.get(
          "${_CONSTANTS.baseUrl}${request.path}",
          queryParameters: request.query,
        ),
      );
      return Right(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      LogsReporter.report(message: "An unexpected error occurred.", error: e);
      return const Left(WError("An unexpected error occurred."));
    }
  }

  Left<WError, dynamic> _handleError(DioException e) {
    final message = e.message ?? e.error.toString();
    LogsReporter.report(message: message, error: e);
    return Left(WError(message));
  }
}

class _CONSTANTS {
  static const baseUrl = "https://restaurant-api.wolt.com";
}

@freezed
class _HttpRequest with _$_HttpRequest {
  const factory _HttpRequest.get({
    required String path,
    Map<String, String>? query,
  }) = _Get;
}
