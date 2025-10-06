import 'package:app_mobile/src/core/routing/app_router.dart';
import 'package:app_mobile/src/core/services/sync_status_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repo_lib_ui_009/repo_lib_ui_009.dart';

/// The root widget of the entire application.
///
/// It sets up the `MaterialApp.router`, theme, and listens to global providers
/// to display application-wide UI elements like alert banners.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Attendance App',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Or make this configurable

      // Router configuration from go_router
      routerConfig: goRouter,

      // Global builder to insert widgets above the navigator
      builder: (context, child) {
        return _GlobalBannerWrapper(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

/// A helper widget that wraps the entire application and displays global banners
/// based on the state of global providers.
class _GlobalBannerWrapper extends ConsumerWidget {
  const _GlobalBannerWrapper({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the sync status provider to show a persistent failure banner
    // as required by US-035.
    final syncFailureState = ref.watch(syncFailureStateProvider);

    return Column(
      children: [
        if (syncFailureState.hasFailure)
          AlertBanner(
            message: syncFailureState.message,
            severity: AlertBannerSeverity.warning,
            action: TextButton(
              onPressed: () {
                // Trigger manual re-sync as per US-036
                ref
                    .read(syncFailureStateProvider.notifier)
                    .retrySync();
              },
              child: const Text('RETRY SYNC'),
            ),
          ),
        Expanded(child: child),
      ],
    );
  }
}

/// Defines the application's theme using Material 3 design principles.
/// Fulfills REQ-1-062.
class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0052D4),
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
    ),
    scaffoldBackgroundColor: Colors.grey[50],
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4C8DFF),
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}