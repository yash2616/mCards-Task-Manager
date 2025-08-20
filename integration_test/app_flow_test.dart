import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:task/main.dart' as app;
import 'package:get_it/get_it.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    GetIt.I.reset();
  });

  testWidgets('Create task and mark complete', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Enter title
    await tester.enterText(find.byType(TextFormField).first, 'Integration Task');

    // Save
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // Verify task appears
    expect(find.text('Integration Task'), findsOneWidget);

    // Complete task
    await tester.tap(find.text('Integration Task'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('Add three tasks, search, filter, delete', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    Future<void> addTask(String title) async {
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, title);
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();
    }

    await addTask('Task A');
    await addTask('Task B');
    await addTask('Task C');

    expect(find.text('Task A'), findsOneWidget);
    expect(find.text('Task B'), findsOneWidget);
    expect(find.text('Task C'), findsOneWidget);

    // Search for Task B
    await tester.enterText(find.byType(TextField), 'Task B');
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    final taskBTile = find.descendant(
        of: find.byType(ListTile), matching: find.text('Task B'));
    expect(taskBTile, findsOneWidget);
    final taskATile = find.descendant(
        of: find.byType(ListTile), matching: find.text('Task A'));
    expect(taskATile, findsNothing);

    // Clear search
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    // Open priority filter and select Low (assumes default heuristic low)
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Low').last);
    await tester.pumpAndSettle();

    // All three tasks should still be visible as their default priority is low
    expect(find.text('Task A'), findsOneWidget);

    // Clear filters via clear-filter icon
    await tester.tap(find.byIcon(Icons.filter_alt_off));
    await tester.pumpAndSettle();

    // Delete Task A by swipe left
    await tester.drag(find.text('Task A'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Task A'), findsNothing);
  });
}
