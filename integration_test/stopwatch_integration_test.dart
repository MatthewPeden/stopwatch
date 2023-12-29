import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stopwatch/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('StopwatchPage Integration Tests', () {
    testWidgets('Stopwatch Full Test', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: StopwatchApp()));

      // Verify that the initial states are correct
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(BottomAppBar), findsOneWidget);
      expect(find.text('00:00.00'), findsOneWidget);
      expect(find.text('Start'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);

      // Start stopwatch
      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();

      // Verify that the stopwatch updates
      await Future.delayed(const Duration(seconds: 1, milliseconds: 450));
      await tester.pumpAndSettle();
      final String stopwatchTime = (tester.widget(find.byType(Text).at(0)) as Text).data!;
      expect(stopwatchTime, isNot(equals('00:00.00')));

      // Find stop and lap buttons
      expect(find.text('Stop'), findsOneWidget);
      expect(find.text('Lap'), findsOneWidget);

      // Add a Lap
      await tester.tap(find.text('Lap'));
      await tester.pumpAndSettle();

      // Find total laps and 1 ListTile
      expect(find.text('Total Laps: 1'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);

      await Future.delayed(const Duration(seconds: 2, milliseconds: 150));
      await tester.pumpAndSettle();

      // Add 9 more laps
      for (int i=0; i<9; i++) {
        await tester.tap(find.text('Lap'));
        await tester.pumpAndSettle();

        await Future.delayed(const Duration(seconds: 1, milliseconds: 650));
        await tester.pumpAndSettle();
      }

      // Find total ListTiles (should be 10)
      int foundLaps = 0;
      for (int lap = 10; lap >= 1; lap--) {
        String lapText = 'Lap $lap';

        await tester.dragUntilVisible(
          find.text(lapText),
          find.byType(ListView),
          const Offset(0, -250),
        );

        await tester.pumpAndSettle();

        if (tester.any(find.text(lapText))) {
          foundLaps++;
        }
      }
      expect(foundLaps, 10);

      // Find total laps
      expect(find.text('Total Laps: 10'), findsOneWidget);

      await Future.delayed(const Duration(seconds: 1, milliseconds: 380));
      await tester.pumpAndSettle();

      // Stop stopwatch
      await tester.tap(find.text('Stop'));
      await tester.pumpAndSettle();

      // Verify that the stopwatch has stopped
      final String stoppedTime = (tester.widget(find.byType(Text).at(0)) as Text).data!;
      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect((tester.widget(find.byType(Text).at(0)) as Text).data, equals(stoppedTime));

      await Future.delayed(const Duration(seconds: 3, milliseconds: 120));
      await tester.pumpAndSettle();

      // Reset stopwatch
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      // Verify that the stopwatch and laps were reset
      expect(find.text('00:00.00'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });
  });
}