import 'package:logger/logger.dart';

class LogsReporter {
  static final logger = Logger();

  static Future<void> report({
    String message = "",
    dynamic error,
    StackTrace? stackTrace,
    bool crashlytics = true,
  }) async {
    logger.e(message, error: error, stackTrace: stackTrace);

    // Report to crash services like crashlytics
  }
}
