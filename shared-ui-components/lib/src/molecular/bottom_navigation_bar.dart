import 'package:flutter/material.dart';

/// A theme-aware bottom navigation bar component.
///
/// This molecular component wraps Flutter's `BottomNavigationBar` to provide
/// a consistent entry point for primary navigation in the mobile application.
/// It is designed to be a simple, presentational widget that receives its
/// items and state from a higher-level state management solution.
///
/// Styling is derived entirely from the `BottomNavigationBarThemeData`
/// defined in `AppTheme`.
class AppBottomNavigationBar extends StatelessWidget {
  /// A list of navigation destinations to display.
  final List<BottomNavigationBarItem> items;

  /// The index of the currently selected navigation item.
  final int currentIndex;

  /// A callback that is called when a navigation item is tapped.
  final ValueChanged<int>? onTap;

  /// Creates a new bottom navigation bar.
  const AppBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // The styling of this widget (selected/unselected colors, label styles, etc.)
    // is controlled by the BottomNavigationBarTheme in AppTheme. This ensures
    // consistency and adherence to the design system (REQ-1-062).
    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      // Type is set to fixed to ensure all labels are always visible, which is
      // generally better for usability and accessibility.
      type: BottomNavigationBarType.fixed,
    );
  }
}