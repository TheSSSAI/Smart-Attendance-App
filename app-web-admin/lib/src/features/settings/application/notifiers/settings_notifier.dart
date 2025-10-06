import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:attendance_client_data/attendance_client_data.dart';

part 'settings_notifier.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required AsyncValue<TenantConfiguration> config,
    @Default(false) bool isSaving,
  }) = _SettingsState;
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final ITenantConfigRepository _configRepository;
  final String _tenantId;

  SettingsNotifier(this._configRepository, this._tenantId)
      : super(SettingsState(config: const AsyncValue.loading())) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = state.copyWith(config: const AsyncValue.loading());
    try {
      final config = await _configRepository.getTenantConfiguration(_tenantId);
      if (config != null) {
        state = state.copyWith(config: AsyncValue.data(config));
      } else {
        state = state.copyWith(
          config: AsyncValue.error(
            'Configuration not found for this tenant.',
            StackTrace.current,
          ),
        );
      }
    } on AppException catch (e, st) {
      state = state.copyWith(config: AsyncValue.error(e.message, st));
    } catch (e, st) {
      state = state.copyWith(config: AsyncValue.error('An unexpected error occurred.', st));
    }
  }

  Future<String?> updateSettings(TenantConfiguration newConfig) async {
    if (state.isSaving) return "Save already in progress.";
    
    state = state.copyWith(isSaving: true);

    try {
      await _configRepository.updateTenantConfiguration(_tenantId, newConfig);
      // Reload the data from the server to ensure consistency
      await loadSettings(); 
      state = state.copyWith(isSaving: false);
      return null; // Indicates success
    } on AppException catch (e) {
      state = state.copyWith(
        isSaving: false,
        config: AsyncValue.error(
          'Failed to save settings: ${e.message}',
          StackTrace.current,
        ),
      );
      return 'Failed to save settings: ${e.message}';
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        config: AsyncValue.error(
          'An unexpected error occurred while saving.',
          StackTrace.current,
        ),
      );
      return 'An unexpected error occurred while saving.';
    } finally {
        if (mounted) {
            state = state.copyWith(isSaving: false);
        }
    }
  }

  Future<String?> updateTimezone(String timezone) async {
    return state.config.when(
      data: (currentConfig) async {
        final newConfig = currentConfig.copyWith(timezone: timezone);
        return await updateSettings(newConfig);
      },
      loading: () => "Settings are still loading.",
      error: (_, __) => "Cannot update, current settings have an error.",
    );
  }

  Future<String?> updateAutoCheckout(String? time, bool isEnabled) async {
     return state.config.when(
      data: (currentConfig) async {
        final newConfig = currentConfig.copyWith(
          autoCheckoutTime: isEnabled ? time : null
        );
        return await updateSettings(newConfig);
      },
      loading: () => "Settings are still loading.",
      error: (_, __) => "Cannot update, current settings have an error.",
    );
  }

  Future<String?> updatePasswordPolicy(PasswordPolicy policy) async {
     return state.config.when(
      data: (currentConfig) async {
        final newConfig = currentConfig.copyWith(passwordPolicy: policy);
        return await updateSettings(newConfig);
      },
      loading: () => "Settings are still loading.",
      error: (_, __) => "Cannot update, current settings have an error.",
    );
  }
}