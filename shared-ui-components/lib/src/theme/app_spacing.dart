import 'package:flutter/widgets.dart';

/// Defines the spacing and sizing scale for the application's design system.
///
/// This class provides a centralized source for consistent spacing values (e.g.,
/// for padding, margins, and gaps) and common sizes (e.g., icon sizes, border
/// radii). Using these constants instead of magic numbers ensures a harmonious
/// and maintainable layout across the entire application.
///
/// The scale is based on a base unit of 4.0, a common practice in modern
/// design systems.
abstract final class AppSpacing {
  // Prevent instantiation
  AppSpacing._();

  // --- Spacing Scale (based on 4.0 unit) ---

  /// 2.0 - Extra, extra small spacing.
  static const double xxs = 2.0;

  /// 4.0 - Extra small spacing.
  static const double xs = 4.0;

  /// 8.0 - Small spacing.
  static const double sm = 8.0;

  /// 12.0 - Small-medium spacing.
  static const double smd = 12.0;

  /// 16.0 - Medium spacing, a common default.
  static const double md = 16.0;

  /// 24.0 - Large spacing.
  static const double lg = 24.0;

  /// 32.0 - Extra large spacing.
  static const double xl = 32.0;

  /// 48.0 - Extra, extra large spacing.
  static const double xxl = 48.0;

  /// 64.0 - Extra, extra, extra large spacing.
  static const double xxxl = 64.0;

  // --- Common Sizes ---

  /// Standard icon size: 24.0
  static const double iconSize = 24.0;

  /// Small icon size: 16.0
  static const double iconSizeSmall = 16.0;

  /// Large icon size: 32.0
  static const double iconSizeLarge = 32.0;
  
  /// Standard touch target size: 48.0 (Meets accessibility guidelines)
  static const double touchTarget = 48.0;

  // --- Border Radii ---

  /// Small border radius: 4.0
  static const Radius radiusSm = Radius.circular(4.0);

  /// Medium border radius: 8.0
  static const Radius radiusMd = Radius.circular(8.0);

  /// Large border radius: 16.0
  static const Radius radiusLg = Radius.circular(16.0);
  
  /// Circular/Pill border radius: 999.0
  static const Radius radiusFull = Radius.circular(999.0);
}