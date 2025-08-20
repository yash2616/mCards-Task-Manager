import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:task/features/tasks/presentation/widgets/priority_indicator.dart';
import 'package:task/features/tasks/domain/enums/priority_level.dart';

void main() {
  Future<void> _pump(WidgetTester tester, PriorityLevel level) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: PriorityIndicator(level: level)),
        ),
      ),
    );
    // Finish animations
    await tester.pumpAndSettle();
  }

  testWidgets('displays correct label for each priority level', (tester) async {
    final expectations = {
      PriorityLevel.critical: 'Critical',
      PriorityLevel.high: 'High',
      PriorityLevel.medium: 'Med',
      PriorityLevel.low: 'Low',
    };

    for (final entry in expectations.entries) {
      await _pump(tester, entry.key);
      expect(find.text(entry.value), findsOneWidget);
    }
  });

  testWidgets('text color matches expected palette', (tester) async {
    // Map expected colors from widget implementation.
    final expectedColors = {
      PriorityLevel.critical: Colors.redAccent,
      PriorityLevel.high: Colors.orange,
      PriorityLevel.medium: Colors.amber,
      PriorityLevel.low: Colors.green,
    };

    for (final entry in expectedColors.entries) {
      await _pump(tester, entry.key);
      final animatedStyles = tester
          .widgetList<AnimatedDefaultTextStyle>(find.byType(AnimatedDefaultTextStyle))
          .map((e) => e.style.color);
      expect(animatedStyles.contains(entry.value), isTrue);
    }
  });
}
