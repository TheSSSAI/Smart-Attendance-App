import 'package:app_web_admin/src/features/settings/application/notifiers/settings_notifier.dart';
import 'package:app_web_admin/src/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the [SettingsNotifier] to the widget tree.
///
/// The [SettingsNotifier] handles the business logic and state management for the
/// tenant settings screen. It is responsible for fetching the current tenant
/// configuration and saving any updates made by the Admin.
///
/// This provider is `autoDispose` to ensure that the settings state is fetched
/// when the settings screen is opened and disposed of when it's closed,
/// preventing stale data and unnecessary memory usage.
final settingsNotifierProvider =
    StateNotifierProvider.autoDispose<SettingsNotifier, SettingsState>(
  (ref) {
    final tenantConfigRepository = ref.watch(tenantConfigRepositoryProvider);
    final functionsRepository = ref.watch(functionsRepositoryProvider);
    return SettingsNotifier(tenantConfigRepository, functionsRepository);
  },
  name: 'settingsNotifierProvider',
);