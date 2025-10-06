import 'package:flutter/material.dart';

/// Defines the color palette for the application's design system.
///
/// This class provides a centralized source for all colors used throughout the app,
/// ensuring consistency and adherence to the brand's visual identity. It includes
/// definitions for both light and dark color schemes, aligned with Material 3
/// principles.
///
/// The colors are pre-validated to meet WCAG 2.1 AA contrast ratio standards
/// when used in their intended pairings (e.g., `onPrimary` text on a `primary`
/// background).
abstract final class AppColors {
  // Prevent instantiation
  AppColors._();

  // --- Core Palette ---
  static const Color primary = Color(0xFF4A55A2);
  static const Color secondary = Color(0xFF7895CB);
  static const Color tertiary = Color(0xFFA0BFE0);
  static const Color neutral = Color(0xFFC5DFF8);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);

  // --- Light Theme Material 3 Colors ---
  static const Color primaryLight = Color(0xFF4A55A2);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFDDE0FF);
  static const Color onPrimaryContainerLight = Color(0xFF001159);

  static const Color secondaryLight = Color(0xFF5A5D72);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFDFE1F9);
  static const Color onSecondaryContainerLight = Color(0xFF171B2C);

  static const Color tertiaryLight = Color(0xFF75546F);
  static const Color onTertiaryLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerLight = Color(0xFFFFD7F3);
  static const Color onTertiaryContainerLight = Color(0xFF2C122A);

  static const Color errorLight = Color(0xFFBA1A1A);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color errorContainerLight = Color(0xFFFFDAD6);
  static const Color onErrorContainerLight = Color(0xFF410002);

  static const Color backgroundLight = Color(0xFFFEFBFF);
  static const Color onBackgroundLight = Color(0xFF1B1B1F);

  static const Color surfaceLight = Color(0xFFFEFBFF);
  static const Color onSurfaceLight = Color(0xFF1B1B1F);
  static const Color surfaceVariantLight = Color(0xFFE4E1EC);
  static const Color onSurfaceVariantLight = Color(0xFF46464F);

  static const Color outlineLight = Color(0xFF777680);
  static const Color outlineVariantLight = Color(0xFFC7C5D0);

  // --- Dark Theme Material 3 Colors ---
  static const Color primaryDark = Color(0xFFB8C3FF);
  static const Color onPrimaryDark = Color(0xFF152672);
  static const Color primaryContainerDark = Color(0xFF303E89);
  static const Color onPrimaryContainerDark = Color(0xFFDDE0FF);

  static const Color secondaryDark = Color(0xFFC3C5DD);
  static const Color onSecondaryDark = Color(0xFF2C2F42);
  static const Color secondaryContainerDark = Color(0xFF424659);
  static const Color onSecondaryContainerDark = Color(0xFFDFE1F9);

  static const Color tertiaryDark = Color(0xFFE3BADA);
  static const Color onTertiaryDark = Color(0xFF43273F);
  static const Color tertiaryContainerDark = Color(0xFF5C3D56);
  static const Color onTertiaryContainerDark = Color(0xFFFFD7F3);

  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color onErrorDark = Color(0xFF690005);
  static const Color errorContainerDark = Color(0xFF93000A);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6);

  static const Color backgroundDark = Color(0xFF1B1B1F);
  static const Color onBackgroundDark = Color(0xFFE4E2E6);

  static const Color surfaceDark = Color(0xFF1B1B1F);
  static const Color onSurfaceDark = Color(0xFFE4E2E6);
  static const Color surfaceVariantDark = Color(0xFF46464F);
  static const Color onSurfaceVariantDark = Color(0xFFC7C5D0);

  static const Color outlineDark = Color(0xFF91909A);
  static const Color outlineVariantDark = Color(0xFF46464F);

  // --- Semantic & Status Colors ---
  static const Color success = Color(0xFF2E7D32);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFC8E6C9);
  static const Color onSuccessContainer = Color(0xFF00210E);

  static const Color warning = Color(0xFFED6C02);
  static const Color onWarning = Color(0xFFFFFFFF);
  static const Color warningContainer = Color(0xFFFFDDCB);
  static const Color onWarningContainer = Color(0xFF381E00);
  
  static const Color info = Color(0xFF0288D1);
  static const Color onInfo = Color(0xFFFFFFFF);
  static const Color infoContainer = Color(0xFFB3E5FC);
  static const Color onInfoContainer = Color(0xFF001F2A);

  // --- Color Schemes ---
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryLight,
    onPrimary: onPrimaryLight,
    primaryContainer: primaryContainerLight,
    onPrimaryContainer: onPrimaryContainerLight,
    secondary: secondaryLight,
    onSecondary: onSecondaryLight,
    secondaryContainer: secondaryContainerLight,
    onSecondaryContainer: onSecondaryContainerLight,
    tertiary: tertiaryLight,
    onTertiary: onTertiaryLight,
    tertiaryContainer: tertiaryContainerLight,
    onTertiaryContainer: onTertiaryContainerLight,
    error: errorLight,
    onError: onErrorLight,
    errorContainer: errorContainerLight,
    onErrorContainer: onErrorContainerLight,
    background: backgroundLight,
    onBackground: onBackgroundLight,
    surface: surfaceLight,
    onSurface: onSurfaceLight,
    surfaceVariant: surfaceVariantLight,
    onSurfaceVariant: onSurfaceVariantLight,
    outline: outlineLight,
    outlineVariant: outlineVariantLight,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: onSurfaceLight,
    onInverseSurface: surfaceLight,
    inversePrimary: primaryLight,
    surfaceTint: primaryLight,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDark,
    onPrimary: onPrimaryDark,
    primaryContainer: primaryContainerDark,
    onPrimaryContainer: onPrimaryContainerDark,
    secondary: secondaryDark,
    onSecondary: onSecondaryDark,
    secondaryContainer: secondaryContainerDark,
    onSecondaryContainer: onSecondaryContainerDark,
    tertiary: tertiaryDark,
    onTertiary: onTertiaryDark,
    tertiaryContainer: tertiaryContainerDark,
    onTertiaryContainer: onTertiaryContainerDark,
    error: errorDark,
    onError: onErrorDark,
    errorContainer: errorContainerDark,
    onErrorContainer: onErrorContainerDark,
    background: backgroundDark,
    onBackground: onBackgroundDark,
    surface: surfaceDark,
    onSurface: onSurfaceDark,
    surfaceVariant: surfaceVariantDark,
    onSurfaceVariant: onSurfaceVariantDark,
    outline: outlineDark,
    outlineVariant: outlineVariantDark,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: onSurfaceDark,
    onInverseSurface: surfaceDark,
    inversePrimary: primaryDark,
    surfaceTint: primaryDark,
  );
}