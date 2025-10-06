import 'package:flutter/material.dart';

/// A theme-aware and accessible checkbox component.
///
/// This widget wraps [CheckboxListTile] to provide a larger, more accessible
/// touch target (minimum 48x48) and ensures consistent styling derived from
/// the application's theme.
///
/// It's designed to be used in forms or lists where a user needs to make a
/// binary choice.
class AppCheckbox extends StatelessWidget {
  /// The text label to display next to the checkbox.
  final String label;

  /// Whether this checkbox is currently checked.
  final bool value;

  /// A callback that is called when the checkbox is tapped.
  /// If null, the checkbox will be disabled.
  final ValueChanged<bool?>? onChanged;

  /// Creates a new AppCheckbox.
  ///
  /// The [label] and [value] are required. [onChanged] is required for the
  /// checkbox to be interactive.
  const AppCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Using CheckboxListTile to ensure a large touch target and proper alignment
    // of the checkbox and its label, which is crucial for accessibility (REQ-1-063).
    return Semantics(
      label: label,
      checked: value,
      child: CheckboxListTile(
        title: Text(label, style: theme.textTheme.bodyMedium),
        value: value,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        activeColor: theme.colorScheme.primary,
        checkColor: theme.colorScheme.onPrimary,
      ),
    );
  }
}