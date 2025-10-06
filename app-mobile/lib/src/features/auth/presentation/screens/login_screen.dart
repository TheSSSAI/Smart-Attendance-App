import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:app_mobile/src/core/routing/routes.dart';
import 'package:app_mobile/src/features/auth/application/providers/auth_providers.dart';
import 'package:app_mobile/src/features/auth/presentation/widgets/auth_form.dart';
import 'package:shared_ui/widgets/widgets.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void _listenToLoginState(BuildContext context, WidgetRef ref) {
    ref.listen(loginNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
        data: (user) {
          if (user != null) {
            // The AppRouter's redirect logic will handle navigation
            // based on the user's role.
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenToLoginState(context, ref);
    final loginState = ref.watch(loginNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  AuthForm(
                    formType: AuthFormType.login,
                    onSubmit: (email, password) {
                      ref
                          .read(loginNotifierProvider.notifier)
                          .signInWithEmail(email, password);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement Forgot Password Screen Navigation
                      // context.go(AppRoutes.forgotPassword.path);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Forgot Password flow not yet implemented.')),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.phone),
                    label: const Text('Login with Phone OTP'),
                    onPressed: () {
                      // TODO: Implement Phone OTP Login Screen Navigation
                      // context.go(AppRoutes.phoneLogin.path);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Phone OTP login not yet implemented.')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (loginState.isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }
}