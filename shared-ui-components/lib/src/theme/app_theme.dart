import 'package:flutter/material.dart';
import 'package:shared_ui_components/src/theme/app_colors.dart';
import 'package:shared_ui_components/src/theme/app_spacing.dart';
import 'package:shared_ui_components/src/theme/app_typography.dart';

/// Defines the application's theme configuration based on Material Design 3.
///
/// This class acts as the single source of truth for the application's visual
/// styling, providing ThemeData for both light and dark modes. It consumes
/// the design tokens defined in `app_colors.dart`, `app_typography.dart`, and
/// `app_spacing.dart` to build a consistent and maintainable design system.
///
/// This implementation directly addresses REQ-1-062 by codifying the Material 3
/// design principles and ensures that all components, by using this theme,
/// will adhere to the specified visual guidelines. It also lays the foundation
/// for accessibility (REQ-1-063) by defining high-contrast color schemes and
/// scalable typography.
class AppTheme {
  // Private constructor to prevent instantiation of this utility class.
  AppTheme._();

  /// Provides the ThemeData for the light theme.
  static ThemeData lightTheme() {
    final baseTheme = ThemeData.from(
      colorScheme: AppColors.lightScheme,
      textTheme: AppTypography.textTheme,
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: AppColors.lightScheme.background,
      appBarTheme: _appBarTheme(baseTheme.appBarTheme, AppColors.lightScheme),
      elevatedButtonTheme: _elevatedButtonTheme(baseTheme.elevatedButtonTheme),
      inputDecorationTheme:
          _inputDecorationTheme(baseTheme.inputDecorationTheme),
      cardTheme: _cardTheme(baseTheme.cardTheme),
      dialogTheme: _dialogTheme(baseTheme.dialogTheme),
      checkboxTheme: _checkboxTheme(baseTheme.checkboxTheme),
      bottomNavigationBarTheme: _bottomNavigationBarTheme(
          baseTheme.bottomNavigationBarTheme, AppColors.lightScheme),
      // Add other component themes here as the library grows
    );
  }

  /// Provides the ThemeData for the dark theme.
  static ThemeData darkTheme() {
    final baseTheme = ThemeData.from(
      colorScheme: AppColors.darkScheme,
      textTheme: AppTypography.textTheme,
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: AppColors.darkScheme.background,
      appBarTheme: _appBarTheme(baseTheme.appBarTheme, AppColors.darkScheme),
      elevatedButtonTheme: _elevatedButtonTheme(baseTheme.elevatedButtonTheme),
      inputDecorationTheme:
          _inputDecorationTheme(baseTheme.inputDecorationTheme),
      cardTheme: _cardTheme(baseTheme.cardTheme),
      dialogTheme: _dialogTheme(baseTheme.dialogTheme),
      checkboxTheme: _checkboxTheme(baseTheme.checkboxTheme),
      bottomNavigationBarTheme: _bottomNavigationBarTheme(
          baseTheme.bottomNavigationBarTheme, AppColors.darkScheme),
      // Add other component themes here as the library grows
    );
  }

  static AppBarTheme _appBarTheme(AppBarTheme base, ColorScheme colorScheme) {
    return base.copyWith(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 2.0,
      shadowColor: colorScheme.shadow.withOpacity(0.2),
      titleTextStyle: AppTypography.textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      actionsIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(
      ElevatedButtonThemeData base) {
    return ElevatedButtonThemeData(
      style: base.style?.copyWith(
        elevation: MaterialStateProperty.resolveWith<double>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return 2.0;
            if (states.contains(MaterialState.disabled)) return 0.0;
            return 4.0;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle?>(
          AppTypography.textTheme.labelLarge,
        ),
        // Minimum size ensures touch targets meet accessibility requirements (REQ-1-063)
        minimumSize: MaterialStateProperty.all<Size>(const Size(48, 48)),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(
      InputDecorationTheme base) {
    final colorScheme = base.fillColor != null
        ? AppColors.darkScheme // A heuristic to guess the theme
        : AppColors.lightScheme;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      borderSide: BorderSide(
        color: colorScheme.outline,
        width: 1.0,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: 2.0,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 1.0,
      ),
    );

    final focusedErrorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 2.0,
      ),
    );

    return base.copyWith(
      filled: true,
      fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      hintStyle: AppTypography.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      labelStyle: AppTypography.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      floatingLabelStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: colorScheme.primary,
      ),
      errorStyle: AppTypography.textTheme.bodySmall?.copyWith(
        color: colorScheme.error,
      ),
      border: border,
      enabledBorder: border,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedErrorBorder,
      disabledBorder: border.copyWith(
        borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
      ),
    );
  }

  static CardTheme _cardTheme(CardTheme base) {
    return base.copyWith(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      ),
      margin: const EdgeInsets.all(AppSpacing.sm),
    );
  }

  static DialogTheme _dialogTheme(DialogTheme base) {
    return base.copyWith(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
      ),
      titleTextStyle: AppTypography.textTheme.titleLarge,
      contentTextStyle: AppTypography.textTheme.bodyMedium,
    );
  }

  static CheckboxThemeData _checkboxTheme(CheckboxThemeData base) {
    return base.copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      side: MaterialStateBorderSide.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return null; // Uses fillColor
          }
          // Using a slightly more visible color for the unchecked state
          return BorderSide(
              color: base.checkColor?.resolve(states) ?? Colors.grey,
              width: 1.5);
        },
      ),
    );
  }

  static BottomNavigationBarThemeData _bottomNavigationBarTheme(
      BottomNavigationBarThemeData base, ColorScheme colorScheme) {
    return base.copyWith(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      selectedLabelStyle: AppTypography.textTheme.labelSmall,
      unselectedLabelStyle: AppTypography.textTheme.labelSmall,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
    );
  }
}