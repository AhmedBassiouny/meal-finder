import 'package:freezed_annotation/freezed_annotation.dart';

part 'werror.freezed.dart';

@freezed
class WError with _$WError {
  const factory WError(String message) = _WError;
}
