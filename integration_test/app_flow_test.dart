import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:task/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Create task and mark complete', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap FAB to add task
    final fab = find.byType(FloatingActionButton);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // Enter title
    await tester.enterText(find.byType(TextFormField).first, 'Integration Task');

    // Save
    await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.save));
    await tester.pumpAndSettle();

    // Verify task appears
    expect(find.text('Integration Task'), findsOneWidget);

    // Toggle complete by tapping tile
    await tester.tap(find.text('Integration Task'));
    await tester.pumpAndSettle(const Duration(milliseconds: 700));

    // Tile opacity should reduce (can't easily assert), but the progress % should update to 100%
    expect(find.text('100%'), findsOneWidget);
  });
}
