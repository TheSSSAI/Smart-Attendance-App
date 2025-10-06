import 'package:app_web_admin/src/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// The root widget of the admin web application.
///
/// This widget is responsible for setting up the top-level application concerns:
/// - Providing the Riverpod scope to the entire widget tree.
/// - Configuring the MaterialApp with the application theme.
/// - Integrating the GoRouter instance for navigation.
class App extends ConsumerWidget {
  /// Creates the root application widget.
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the GoRouter provider to get the router configuration.
    // This allows the router to be stateful and access other providers
    // for functionalities like the AuthGuard.
    final router = ref.watch(goRouterProvider);

    // Using MaterialApp.router to integrate with the GoRouter package.
    return MaterialApp.router(
      title: 'Attendance App - Admin Dashboard',
      // Hide the debug banner in the top-right corner.
      debugShowCheckedModeBanner: false,

      // Configure the router delegate and information parser from GoRouter.
      // The routerConfig property is the modern and simpler way to set this up.
      routerConfig: router,

      // Define the application's theme based on Material Design 3 principles.
      // This fulfills the requirement REQ-1-062 and sets a foundation for
      // accessibility (REQ-1-063).
      theme: _buildThemeData(context),
    );
  }

  /// Builds the ThemeData for the application.
  ///
  /// This centralized theme configuration ensures a consistent look and feel
  /// across the entire admin dashboard. It uses Material 3 and a custom
  /// color scheme.
  ThemeData _buildThemeData(BuildContext context) {
    final baseTheme = ThemeData.light(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF005A9C), // A professional blue seed color
      brightness: Brightness.light,
    );

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 1,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surface,
        labelStyle: GoogleFonts.inter(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        color: colorScheme.surface,
      ),
      dataTableTheme: DataTableThemeData(
        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return colorScheme.primary.withOpacity(0.08);
            }
            return null; // Use default value for other states and odd/even rows.
          },
        ),
        headingRowColor: MaterialStateProperty.all<Color>(
          colorScheme.surfaceContainerHighest,
        ),
        headingTextStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        dataTextStyle: GoogleFonts.inter(
          color: colorScheme.onSurfaceVariant,
        ),
        dividerThickness: 1,
        columnSpacing: 24,
        horizontalMargin: 24,
        headingRowHeight: 48,
        dataRowMinHeight: 52,
        dataRowMaxHeight: 52,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}