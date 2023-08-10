import 'package:flutter/material.dart';
import 'package:meal_finder/theme/app_theme.dart';
import 'package:meal_finder/utils/strings.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorScreen({super.key, required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 7,
          child: Image.asset(
            'assets/images/error_banner4.png',
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  Strings.errorScreenMessage,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: appTheme.defaultButtonStyle,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        Strings.errorScreenButtonText,
                        style: appTheme.wTextTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
