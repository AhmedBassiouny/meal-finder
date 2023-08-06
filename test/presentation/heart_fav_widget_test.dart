import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:meal_finder/presentation/widgets/heart_fav_widget.dart';

void main() {
  testWidgets('HeartFavWidget changes color and size when tapped', (WidgetTester tester) async {
    bool selected = false;
    bool deselected = true;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: HeartFavWidget(
          isSelected: selected,
          onSelected: () => selected = true,
          onDeselected: () => deselected = true,
        ),
      ),
    ));

    // Find the HeartFavWidget
    var heart = find.byType(HeartFavWidget);

    // Verify that the HeartFavWidget is grey before being tapped
    var icon = tester.firstWidget<Icon>(find.byIcon(Icons.favorite));
    expect(icon.color, Colors.grey);

    // Tap on the HeartFavWidget
    await tester.tap(heart);
    await tester.pumpAndSettle();

    // Verify that the HeartFavWidget is now blue after being tapped
    icon = tester.firstWidget<Icon>(find.byIcon(Icons.favorite));
    expect(icon.color, Colors.blueAccent);
    expect(selected, true);

    // Tap on the HeartFavWidget again
    await tester.tap(heart);
    await tester.pumpAndSettle();

    // Verify that the HeartFavWidget is grey again after being tapped a second time
    icon = tester.firstWidget<Icon>(find.byIcon(Icons.favorite));
    expect(icon.color, Colors.grey);
    expect(deselected, true);
  });
}
