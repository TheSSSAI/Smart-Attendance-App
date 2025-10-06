import 'package:flutter/material.dart';

/// An enum defining the types of status badges, which determines their styling.
enum BadgeType {
  /// For pending or warning states. Typically yellow/amber.
  pending,

  /// For approved or success states. Typically green.
  approved,

  /// For rejected or error states. Typically red.
  rejected,

  /// For informational states. Typically blue.
  info,

  /// For items created or actioned offline. Typically grey.
  offline,

  /// A generic error state. Typically red.
  error,
}

/// A small, colored atomic component used to indicate the status of an item.
///
/// This widget provides a consistent look and feel for statuses like 'Pending',
/// 'Approved', 'Rejected', etc., as seen in various lists across the application.
///
/// It adheres to accessibility requirements by conveying information through text,
/// not just color.
class StatusBadge extends StatelessWidget {
  /// The text to display inside the badge.
  final String label;

  /// The type of the badge, which determines its color scheme.
  final BadgeType type;

  /// Creates a status badge.
  ///
  /// The [label] and [type] are required. The constructor is `const` for
  /// performance optimizations, especially in lists.
  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final (Color backgroundColor, Color foregroundColor) = _getColors(colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Determines the background and foreground colors based on the badge type.
  (Color, Color) _getColors(ColorScheme colorScheme) {
    switch (type) {
      case BadgeType.pending:
        return (colorScheme.tertiaryContainer, colorScheme.onTertiaryContainer);
      case BadgeType.approved:
        return (colorScheme.primaryContainer, colorScheme.onPrimaryContainer);
      case BadgeType.rejected:
      case BadgeType.error:
        return (colorScheme.errorContainer, colorScheme.onErrorContainer);
      case BadgeType.info:
        return (colorScheme.secondaryContainer, colorScheme.onSecondaryContainer);
      case BadgeType.offline:
        return (colorScheme.surfaceVariant, colorScheme.onSurfaceVariant);
    }
  }
}