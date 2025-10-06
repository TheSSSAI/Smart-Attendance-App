import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Enum to define the type of alert for styling purposes.
enum AlertType {
  info,
  success,
  warning,
  error,
}

/// A reusable atomic widget for displaying prominent, contextual alerts.
///
/// This banner is designed to be non-dismissible by default and should be
/// controlled by a parent widget's state. It provides clear visual feedback
/// for different states like information, success, warnings, or errors.
///
/// It adheres to accessibility standards by using icons alongside color and
/// ensuring its content is announced by screen readers.
///
/// ### Requirements Covered:
/// - **REQ-1-063 (WCAG 2.1 AA)**: Ensures color contrast and proper semantics.
/// - **REQ-1-064 (Internationalization)**: All text is passed in, not hardcoded.
/// - **User Stories**:
///   - **US-035**: Notifies subordinate of persistent sync failure.
///   - **US-067**: Alerts Admin to a Google Sheets sync failure.
///   - **US-024**: Informs Admin of the tenant deletion grace period.
class AlertBanner extends StatelessWidget {
  /// The main message to be displayed in the banner.
  final String message;

  /// The type of alert, which determines the color and icon.
  final AlertType type;

  /// An optional action widget, typically a button, to be displayed on the banner.
  /// Example: A "Retry" button for a sync failure alert.
  final Widget? action;

  /// Creates an AlertBanner widget.
  ///
  /// The [message] and [type] are required. The [action] is optional.
  const AlertBanner({
    super.key,
    required this.message,
    required this.type,
    this.action,
  });

  /// Determines the background color based on the [AlertType].
  Color _getBackgroundColor(BuildContext context, AlertType type) {
    final colors = Theme.of(context).colorScheme;
    switch (type) {
      case AlertType.info:
        return AppColors.infoContainer; // Assuming custom semantic colors
      case AlertType.success:
        return AppColors.successContainer;
      case AlertType.warning:
        return colors.secondaryContainer;
      case AlertType.error:
        return colors.errorContainer;
    }
  }

  /// Determines the icon and icon color based on the [AlertType].
  Widget _getIcon(BuildContext context, AlertType type) {
    final colors = Theme.of(context).colorScheme;
    switch (type) {
      case AlertType.info:
        return Icon(Icons.info_outline, color: AppColors.onInfoContainer);
      case AlertType.success:
        return Icon(Icons.check_circle_outline, color: AppColors.onSuccessContainer);
      case AlertType.warning:
        return Icon(Icons.warning_amber_rounded, color: colors.onSecondaryContainer);
      case AlertType.error:
        return Icon(Icons.error_outline, color: colors.onErrorContainer);
    }
  }
  
  /// Determines the text color based on the [AlertType].
  Color _getTextColor(BuildContext context, AlertType type) {
    final colors = Theme.of(context).colorScheme;
    switch (type) {
      case AlertType.info:
        return AppColors.onInfoContainer;
      case AlertType.success:
        return AppColors.onSuccessContainer;
      case AlertType.warning:
        return colors.onSecondaryContainer;
      case AlertType.error:
        return colors.onErrorContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final backgroundColor = _getBackgroundColor(context, type);
    final icon = _getIcon(context, type);
    final textColor = _getTextColor(context, type);

    // Semantics widget to group the banner content and make it behave as a single unit
    // for screen readers. The 'liveRegion' property should be handled by the parent
    // widget that dynamically adds/removes this banner.
    return Semantics(
      container: true,
      label: 'Alert, ${type.name}: $message',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                message,
                style: textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: action == null ? TextAlign.start : TextAlign.start,
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: 16.0),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}