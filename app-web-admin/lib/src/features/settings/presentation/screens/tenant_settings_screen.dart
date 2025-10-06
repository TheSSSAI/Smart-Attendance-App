import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/settings_providers.dart';
import '../../domain/tenant_settings.dart';

class TenantSettingsScreen extends ConsumerStatefulWidget {
  const TenantSettingsScreen({super.key});

  @override
  ConsumerState<TenantSettingsScreen> createState() =>
      _TenantSettingsScreenState();
}

class _TenantSettingsScreenState extends ConsumerState<TenantSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  // Controllers will be initialized in initState based on provider state
  late TextEditingController _timezoneController;
  late TextEditingController _autoCheckoutController;
  late TextEditingController _escalationPeriodController;
  bool _isDirty = false;
  bool _autoCheckoutEnabled = false;

  @override
  void initState() {
    super.initState();
    _timezoneController = TextEditingController();
    _autoCheckoutController = TextEditingController();
    _escalationPeriodController = TextEditingController();

    // Initialize form with data from provider
    final settingsState = ref.read(settingsNotifierProvider);
    settingsState.whenData((settings) {
      _updateControllers(settings);
    });
  }

  void _updateControllers(TenantSettings settings) {
    _timezoneController.text = settings.timezone;
    _autoCheckoutEnabled = settings.autoCheckoutTime != null;
    _autoCheckoutController.text = settings.autoCheckoutTime ?? '';
    _escalationPeriodController.text =
        settings.approvalEscalationDays?.toString() ?? '';
  }

  @override
  void dispose() {
    _timezoneController.dispose();
    _autoCheckoutController.dispose();
    _escalationPeriodController.dispose();
    super.dispose();
  }
  
  void _onChanged() {
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      final newSettings = TenantSettings(
        timezone: _timezoneController.text,
        autoCheckoutTime: _autoCheckoutEnabled ? _autoCheckoutController.text : null,
        approvalEscalationDays: int.tryParse(_escalationPeriodController.text),
        // Other settings would be added here
      );

      await ref.read(settingsNotifierProvider.notifier).saveSettings(newSettings);
      
      final currentState = ref.read(settingsNotifierProvider);
      if (currentState is! AsyncError) {
        setState(() {
          _isDirty = false;
        });
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Settings saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsNotifierProvider);

    ref.listen(settingsNotifierProvider, (previous, next) {
      if (next is AsyncData<TenantSettings>) {
        _updateControllers(next.value!);
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: ${next.error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenant Settings'),
      ),
      body: settingsState.when(
        data: (settings) => _buildForm(context, settings),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading settings: $error'),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, TenantSettings settings) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('General Settings', context),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _timezoneController,
                    decoration: const InputDecoration(
                      labelText: 'Organization Timezone',
                      hintText: 'e.g., America/New_York',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _onChanged(),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Timezone is required'
                        : null,
                  ),

                  const SizedBox(height: 32),
                  _buildSectionHeader('Attendance Policy', context),
                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    title: const Text('Enable Automatic Check-out'),
                    value: _autoCheckoutEnabled,
                    onChanged: (value) {
                      setState(() {
                        _autoCheckoutEnabled = value;
                         _onChanged();
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _autoCheckoutController,
                    enabled: _autoCheckoutEnabled,
                    decoration: const InputDecoration(
                      labelText: 'Auto-checkout Time (HH:mm)',
                      hintText: 'e.g., 17:30',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _onChanged(),
                    validator: (value) {
                      if (!_autoCheckoutEnabled) return null;
                      if (value == null || value.isEmpty) {
                        return 'Time is required when auto-checkout is enabled';
                      }
                      // Basic HH:mm format check
                      if (!RegExp(r'^[0-2][0-9]:[0-5][0-9]$').hasMatch(value)) {
                        return 'Invalid format. Use HH:mm';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  _buildSectionHeader('Approval Workflow', context),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _escalationPeriodController,
                    decoration: const InputDecoration(
                      labelText: 'Approval Escalation Period (days)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _onChanged(),
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final numValue = int.tryParse(value);
                      if (numValue == null || numValue < 1) {
                        return 'Must be a whole number greater than 0';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: (_isDirty && !settingsState.isLoading) ? _saveSettings : null,
                        child: settingsState.isLoading 
                            ? const CircularProgressIndicator()
                            : const Text('Save Changes'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}