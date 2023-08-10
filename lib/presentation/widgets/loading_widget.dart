import 'package:flutter/material.dart';
import 'package:meal_finder/utils/strings.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 80.0),
              child: Image.asset(
                "assets/images/wolt_loading.gif",
                height: 225.0,
                width: 225.0,
              ),
            ),
            const Text(
              Strings.loadingPageMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
