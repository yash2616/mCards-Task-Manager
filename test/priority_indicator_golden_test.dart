import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task/features/tasks/domain/enums/priority_level.dart';
import 'package:task/features/tasks/presentation/widgets/priority_indicator.dart';

void main() {
  testWidgets('PriorityIndicator golden', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        home: Column(
          children: const [
            PriorityIndicator(level: PriorityLevel.low),
            PriorityIndicator(level: PriorityLevel.medium),
            PriorityIndicator(level: PriorityLevel.high),
            PriorityIndicator(level: PriorityLevel.critical),
          ],
        ),
      ),
    );

    await expectLater(
      find.byType(Column),
      matchesGoldenFile('goldens/priority_indicator.png'),
    );
  });
}
