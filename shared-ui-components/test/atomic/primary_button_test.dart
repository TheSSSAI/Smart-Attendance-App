import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_ui_components/src/atomic/loading_spinner.dart';
import 'package:shared_ui_components/src/atomic/primary_button.dart';
import 'package:shared_ui_components/src/theme/app_theme.dart';

// Mock VoidCallback using mocktail
class MockOnPressedFunction extends Mock {
  void call();
}

void main() {
  group('PrimaryButton', () {
    late MockOnPressedFunction mockOnPressed;

    setUp(() {
      mockOnPressed = MockOnPressedFunction();
    });

    Widget buildTestableWidget({
      required VoidCallback? onPressed,
      required String label,
      bool isLoading = false,
    }) {
      return MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: PrimaryButton(
            onPressed: onPressed,
            label: label,
            isLoading: isLoading,
          ),
        ),
      );
    }

    testWidgets('renders correctly with label and is enabled by default',
        (WidgetTester tester) async {
      const buttonLabel = 'Submit';
      await tester.pumpWidget(buildTestableWidget(
        onPressed: mockOnPressed.call,
        label: buttonLabel,
      ));

      // Verify the button and its label are found
      final buttonFinder = find.byType(ElevatedButton);
      final labelFinder = find.text(buttonLabel);

      expect(buttonFinder, findsOneWidget);
      expect(labelFinder, findsOneWidget);

      // Verify it's not in loading state
      expect(find.byType(LoadingSpinner), findsNothing);

      // Verify the button is enabled
      final ElevatedButton button = tester.widget(buttonFinder);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('calls onPressed callback when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(
        onPressed: mockOnPressed.call,
        label: 'Tap Me',
      ));

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      // Verify that the mocked callback was called exactly once
      verify(() => mockOnPressed.call()).called(1);
    });

    testWidgets('is disabled when onPressed is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(
        onPressed: null,
        label: 'Disabled',
      ));

      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      // Verify the button is disabled
      final ElevatedButton button = tester.widget(buttonFinder);
      expect(button.onPressed, isNull);

      // Attempt to tap and verify callback is not called
      await tester.tap(buttonFinder);
      await tester.pump();
      verifyNever(() => mockOnPressed.call());
    });

    testWidgets('shows loading spinner and is disabled when isLoading is true',
        (WidgetTester tester) async {
      const buttonLabel = 'Loading...';
      await tester.pumpWidget(buildTestableWidget(
        onPressed: mockOnPressed.call,
        label: buttonLabel,
        isLoading: true,
      ));

      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      // Verify the loading spinner is present and the label is not
      expect(find.byType(LoadingSpinner), findsOneWidget);
      expect(find.text(buttonLabel), findsNothing);

      // Verify the button is disabled
      final ElevatedButton button = tester.widget(buttonFinder);
      expect(button.onPressed, isNull);

      // Attempt to tap and verify callback is not called
      await tester.tap(buttonFinder);
      await tester.pump();
      verifyNever(() => mockOnPressed.call());
    });

    testWidgets('has a minimum touch target size of 48x48',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(
        onPressed: mockOnPressed.call,
        label: 'Test',
      ));

      final buttonSize = tester.getSize(find.byType(PrimaryButton));
      expect(buttonSize.width, greaterThanOrEqualTo(48.0));
      expect(buttonSize.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('text style matches the theme', (WidgetTester tester) async {
      const buttonLabel = 'Themed Text';
      await tester.pumpWidget(buildTestableWidget(
        onPressed: mockOnPressed.call,
        label: buttonLabel,
      ));

      final textWidget = tester.widget<Text>(find.text(buttonLabel));
      final theme = AppTheme.lightTheme();
      final expectedStyle =
          theme.elevatedButtonTheme.style?.textStyle?.resolve({});

      expect(textWidget.style?.color, expectedStyle?.color);
      expect(textWidget.style?.fontSize, expectedStyle?.fontSize);
      expect(textWidget.style?.fontWeight, expectedStyle?.fontWeight);
    });
  });
}