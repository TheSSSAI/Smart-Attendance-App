import 'package:flutter/material.dart';
import 'package:shared_ui_components/src/atomic/loading_spinner.dart';
import 'package:shared_ui_components/src/theme/app_spacing.dart';

/// A primary call-to-action button for the application, conforming to the
/// Material 3 design system and application's theme.
///
/// This atomic widget is designed to be the main button for form submissions
/// and critical actions. It supports enabled, disabled, and loading states.
///
/// It adheres to the following requirements:
/// - **REQ-1-062**: Follows Material Design 3 principles and uses the app's theme.
/// - **REQ-1-063 (Accessibility)**: Ensures a minimum touch target size and uses
///   semantic properties. The button's label is derived from the passed `child`.
/// - **REQ-1-064 (Internationalization)**: Does not contain hardcoded strings. The
///   label is provided via the `child` widget.
/// - **REQ-1-067 (Performance)**: Uses a `const` constructor for performance optimization.
class PrimaryButton extends StatelessWidget {
  /// Creates a primary themed button.
  ///
  /// The [onPressed] callback is required for the button to be enabled. If null,
  /// the button will be visually disabled.
  ///
  /// The [child] is the widget to be displayed as the button's content,
  /// typically a [Text] widget.
  ///
  /// The [isLoading] flag, when true, shows a [LoadingSpinner] instead of the
  /// [child] and disables the button.
  ///
  /// The [style] parameter allows for overriding the default theme style.
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
  });

  /// The callback that is called when the button is tapped. If `null`, the
  /// button will be disabled.
  final VoidCallback? onPressed;

  /// The widget below this widget in the tree, typically a [Text] widget for
  /// the button's label.
  final Widget child;

  /// Whether the button is in a loading state. When `true`, a loading
  /// indicator is shown, and the button is disabled.
  final bool isLoading;

  /// Optional style to override the theme's default `ElevatedButton` style.
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      height: 48, // Enforces minimum touch target height per REQ-1-063
      child: ElevatedButton(
        style: style,
        // The button is functionally disabled if isLoading is true or if the
        // provided onPressed callback is null.
        onPressed: isEnabled ? onPressed : null,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? LoadingSpinner(
                  key: const ValueKey('loading'),
                  color: theme.colorScheme.onPrimary,
                  size: AppSpacing.medium,
                )
              : Container(
                  key: const ValueKey('child'),
                  child: child,
                ),
        ),
      ),
    );
  }
}