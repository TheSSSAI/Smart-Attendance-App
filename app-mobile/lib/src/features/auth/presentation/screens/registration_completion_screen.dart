import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:app_mobile/src/features/auth/application/providers/auth_providers.dart';
import 'package:shared_ui/widgets/widgets.dart';

class RegistrationCompletionScreen extends ConsumerStatefulWidget {
  final String token;
  const RegistrationCompletionScreen({super.key, required this.token});

  @override
  ConsumerState<RegistrationCompletionScreen> createState() =>
      _RegistrationCompletionScreenState();
}

class _RegistrationCompletionScreenState
    extends ConsumerState<RegistrationCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() == true && _termsAccepted) {
      ref.read(registrationCompletionNotifierProvider.notifier).completeRegistration(
            token: widget.token,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registrationCompletionNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
        data: (success) {
          if (success) {
            // AppRouter redirect logic will handle navigation to the correct dashboard
          }
        },
      );
    });

    final state = ref.watch(registrationCompletionNotifierProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Registration'),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set Your Password',
                      style: textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome! Please create a secure password to activate your account.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    PasswordInputField(
                      controller: _passwordController,
                      labelText: 'Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required.';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long.';
                        }
                        // Add more complex validation based on US-027
                        if (!value.contains(RegExp(r'[A-Z]'))) {
                           return 'Password must contain an uppercase letter.';
                        }
                        if (!value.contains(RegExp(r'[a-z]'))) {
                           return 'Password must contain a lowercase letter.';
                        }
                        if (!value.contains(RegExp(r'[0-9]'))) {
                           return 'Password must contain a number.';
                        }
                        if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
                           return 'Password must contain a special character.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    PasswordInputField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          onChanged: (value) {
                            setState(() {
                              _termsAccepted = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
                              children: [
                                const TextSpan(text: 'I have read and agree to the '),
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(color: colorScheme.primary, decoration: TextDecoration.underline),
                                  // recognizer: TapGestureRecognizer()..onTap = () => _launchURL('...'),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(color: colorScheme.primary, decoration: TextDecoration.underline),
                                  // recognizer: TapGestureRecognizer()..onTap = () => _launchURL('...'),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      onPressed: state.isLoading ? null : _submit,
                      text: 'Activate Account',
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (state.isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }
}