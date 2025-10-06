import 'package:flutter/material.dart';

/// A consistent, theme-aware loading spinner for use across the application.
///
/// This atomic component wraps a [CircularProgressIndicator] and ensures
/// it uses the application's primary theme color by default. It is optimized
/// for performance by using a `const` constructor.
class LoadingSpinner extends StatelessWidget {
  /// The size of the spinner.
  ///
  /// Defaults to 24.0 logical pixels for the diameter.
  final double size;

  /// The width of the line used to draw the circle.
  ///
  /// Defaults to 4.0.
  final double strokeWidth;

  /// The color of the spinner.
  ///
  /// If null, it defaults to the `primary` color of the current theme's color scheme.
  final Color? color;

  /// Creates a theme-aware loading spinner.
  ///
  /// All parameters are optional.
  const LoadingSpinner({
    super.key,
    this.size = 24.0,
    this.strokeWidth = 4.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? theme.colorScheme.primary,
        ),
      ),
    );
  }
}