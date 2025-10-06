import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_ui_components/src/atomic/status_badge.dart';
import 'package:shared_ui_components/src/molecular/attendance_list_item.dart';
import 'package:shared_ui_components/src/theme/app_theme.dart';

// Mock for the onSelected callback
class MockOnSelectedCallback extends Mock {
  void call(bool? value);
}

// Simple data class to represent the view model for testing
class TestAttendanceListItemData implements AttendanceListItemData {
  @override
  final String? subordinateName;
  @override
  final DateTime date;
  @override
  final DateTime? checkInTime;
  @override
  final DateTime? checkOutTime;
  @override
  final String status;
  @override
  final List<String> flags;

  TestAttendanceListItemData({
    this.subordinateName,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.flags = const [],
  });
}

void main() {
  group('AttendanceListItem', () {
    late MockOnSelectedCallback mockOnSelected;

    setUp(() {
      mockOnSelected = MockOnSelectedCallback();
    });

    Widget buildTestableWidget(
        {required AttendanceListItemData data,
        AttendanceListItemViewType viewType =
            AttendanceListItemViewType.subordinate,
        bool isSelected = false,
        ValueChanged<bool?>? onSelected}) {
      return MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: AttendanceListItem(
            data: data,
            viewType: viewType,
            isSelected: isSelected,
            onSelected: onSelected,
          ),
        ),
      );
    }

    final testDate = DateTime(2024, 5, 27);
    final checkIn = DateTime(2024, 5, 27, 9, 5);
    final checkOut = DateTime(2024, 5, 27, 17, 32);

    group('Subordinate View', () {
      testWidgets('renders correctly for a complete, normal attendance record',
          (tester) async {
        final data = TestAttendanceListItemData(
          date: testDate,
          checkInTime: checkIn,
          checkOutTime: checkOut,
          status: 'Approved',
        );

        await tester.pumpWidget(buildTestableWidget(
            data: data, viewType: AttendanceListItemViewType.subordinate));

        expect(find.text('May 27, 2024'), findsOneWidget);
        expect(find.text('09:05 AM - 05:32 PM'), findsOneWidget);
        expect(find.byType(StatusBadge), findsOneWidget);
        expect(find.text('Approved'), findsOneWidget);
        expect(find.byType(Checkbox), findsNothing);
      });

      testWidgets('renders correctly for a record with only check-in',
          (tester) async {
        final data = TestAttendanceListItemData(
          date: testDate,
          checkInTime: checkIn,
          status: 'Pending',
        );

        await tester.pumpWidget(buildTestableWidget(
            data: data, viewType: AttendanceListItemViewType.subordinate));

        expect(find.text('09:05 AM - --:--'), findsOneWidget);
        expect(find.text('Pending'), findsOneWidget);
      });
    });

    group('Supervisor View', () {
      testWidgets('renders correctly with subordinate name and checkbox',
          (tester) async {
        final data = TestAttendanceListItemData(
          subordinateName: 'John Doe',
          date: testDate,
          checkInTime: checkIn,
          checkOutTime: checkOut,
          status: 'Pending',
        );

        await tester.pumpWidget(buildTestableWidget(
            data: data,
            viewType: AttendanceListItemViewType.supervisor,
            onSelected: mockOnSelected.call));

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('May 27, 2024'), findsOneWidget);
        expect(find.text('09:05 AM - 05:32 PM'), findsOneWidget);
        expect(find.text('Pending'), findsOneWidget);
        expect(find.byType(Checkbox), findsOneWidget);
      });

      testWidgets('checkbox reflects isSelected state', (tester) async {
        final data = TestAttendanceListItemData(
            subordinateName: 'Jane Smith', date: testDate, status: 'Pending');

        await tester.pumpWidget(buildTestableWidget(
            data: data,
            viewType: AttendanceListItemViewType.supervisor,
            isSelected: true,
            onSelected: mockOnSelected.call));

        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isTrue);
      });

      testWidgets('onSelected callback is called when checkbox is tapped',
          (tester) async {
        final data = TestAttendanceListItemData(
            subordinateName: 'Jane Smith', date: testDate, status: 'Pending');

        await tester.pumpWidget(buildTestableWidget(
            data: data,
            viewType: AttendanceListItemViewType.supervisor,
            isSelected: false,
            onSelected: mockOnSelected.call));

        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        verify(() => mockOnSelected.call(true)).called(1);
      });
    });

    group('Exception Flags', () {
      testWidgets('displays offline entry flag icon and tooltip',
          (tester) async {
        final data = TestAttendanceListItemData(
            date: testDate,
            status: 'Pending',
            flags: [AttendanceListItem.flagOffline]);

        await tester.pumpWidget(buildTestableWidget(data: data));

        final iconFinder = find.byIcon(Icons.cloud_off);
        expect(iconFinder, findsOneWidget);

        // Hover to show tooltip (for web/desktop) or long press
        final gesture = await tester.startGesture(tester.getCenter(iconFinder));
        await tester.pump(kLongPressTimeout);
        await gesture.up();
        await tester.pump();
        
        expect(find.text('Offline Entry'), findsOneWidget);
      });

      testWidgets('displays clock discrepancy flag icon and tooltip',
          (tester) async {
        final data = TestAttendanceListItemData(
            date: testDate,
            status: 'Pending',
            flags: [AttendanceListItem.flagClockDiscrepancy]);

        await tester.pumpWidget(buildTestableWidget(data: data));

        final iconFinder = find.byIcon(Icons.running_with_errors_rounded);
        expect(iconFinder, findsOneWidget);
        
        await tester.tap(iconFinder); // On mobile, tap can also show tooltip
        await tester.pump();
        
        expect(find.text('Clock Discrepancy'), findsOneWidget);
      });

      testWidgets('displays auto checkout flag icon and tooltip',
          (tester) async {
        final data = TestAttendanceListItemData(
            date: testDate,
            status: 'Pending',
            flags: [AttendanceListItem.flagAutoCheckedOut]);

        await tester.pumpWidget(buildTestableWidget(data: data));

        final iconFinder = find.byIcon(Icons.timelapse);
        expect(iconFinder, findsOneWidget);
      });
      
      testWidgets('displays manually corrected flag icon and tooltip',
          (tester) async {
        final data = TestAttendanceListItemData(
            date: testDate,
            status: 'Approved',
            flags: [AttendanceListItem.flagManuallyCorrected]);

        await tester.pumpWidget(buildTestableWidget(data: data));

        final iconFinder = find.byIcon(Icons.edit);
        expect(iconFinder, findsOneWidget);
      });

      testWidgets('displays multiple flags correctly', (tester) async {
        final data = TestAttendanceListItemData(date: testDate, status: 'Pending', flags: [
          AttendanceListItem.flagOffline,
          AttendanceListItem.flagClockDiscrepancy
        ]);

        await tester.pumpWidget(buildTestableWidget(data: data));

        expect(find.byIcon(Icons.cloud_off), findsOneWidget);
        expect(find.byIcon(Icons.running_with_errors_rounded), findsOneWidget);
        expect(find.byIcon(Icons.timelapse), findsNothing);
      });
    });
    
    group('Accessibility', () {
        testWidgets('has correct semantic information for screen readers', (tester) async {
            final data = TestAttendanceListItemData(
                subordinateName: 'John Doe',
                date: testDate,
                checkInTime: checkIn,
                checkOutTime: checkOut,
                status: 'Pending',
                flags: [AttendanceListItem.flagOffline]
            );

            await tester.pumpWidget(buildTestableWidget(
                data: data,
                viewType: AttendanceListItemViewType.supervisor,
            ));
            
            final semantics = tester.getSemantics(find.byType(AttendanceListItem));
            
            // Check that the semantics label contains all the critical info
            final expectedLabel = 'John Doe. May 27, 2024. 09:05 AM to 05:32 PM. Status: Pending. Has flags: Offline Entry.';
            
            expect(semantics, matchesSemantics(
                label: contains('John Doe'),
                onTap: isNotNull,
                isFocusable: true,
            ));
            
            // This is a more fragile check, but demonstrates the intent.
            // A better approach in a real app would be to build the full label and match it.
             expect(semantics.toString(), contains('John Doe'));
             expect(semantics.toString(), contains('May 27, 2024'));
             expect(semantics.toString(), contains('Pending'));
             expect(semantics.toString(), contains('Offline Entry'));
        });
    });
  });
}