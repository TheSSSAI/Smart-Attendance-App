import 'package:flutter/material.dart';

/// A utility function to show a platform-adaptive date picker dialog.
///
/// It uses the application's theme to ensure consistent styling.
///
/// [context]: The build context from which to launch the dialog.
/// [initialDate]: The date initially selected when the picker is shown.
/// [firstDate]: The earliest allowable date.
/// [lastDate]: The latest allowable date.
///
/// Returns a [Future] that resolves to the selected [DateTime] or `null` if the
/// user cancels the dialog.
Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    // The builder property is used to wrap the dialog in our app's theme.
    // This is crucial for styling pickers on platforms like Android.
    builder: (context, child) {
      // In a real app, you might have separate light/dark theme data.
      // Here we just use the ambient theme.
      return Theme(
        data: Theme.of(context),
        child: child!,
      );
    },
  );
}

/// A utility function to show a platform-adaptive time picker dialog.
///
/// It uses the application's theme to ensure consistent styling.
///
/// [context]: The build context from which to launch the dialog.
/// [initialTime]: The time initially selected when the picker is shown.
///
/// Returns a [Future] that resolves to the selected [TimeOfDay] or `null` if
/// the user cancels the dialog.
Future<TimeOfDay?> showAppTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context),
        child: child!,
      );
    },
  );
}

/// A utility function to show a two-step date and time picker flow.
///
/// First, it shows a date picker. If a date is selected, it then shows a time
/// picker. Finally, it combines the results into a single [DateTime] object.
///
/// [context]: The build context from which to launch the dialogs.
/// [initialDate]: The initial date and time for the pickers.
/// [firstDate]: The earliest allowable date.
/// [lastDate]: The latest allowable date.
///
/// Returns a [Future] that resolves to the selected [DateTime] or `null` if
/// the user cancels at any point in the flow.
Future<DateTime?> showAppDateTimePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  // Step 1: Show the date picker.
  final DateTime? selectedDate = await showAppDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  // If the user cancels the date picker, abort the flow.
  if (selectedDate == null) {
    return null;
  }

  // Ensure context is still valid before showing the next dialog.
  if (!context.mounted) {
    return null;
  }

  // Step 2: Show the time picker.
  final TimeOfDay? selectedTime = await showAppTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );

  // If the user cancels the time picker, abort the flow.
  if (selectedTime == null) {
    return null;
  }

  // Step 3: Combine the selected date and time into a single DateTime object.
  return DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );
}