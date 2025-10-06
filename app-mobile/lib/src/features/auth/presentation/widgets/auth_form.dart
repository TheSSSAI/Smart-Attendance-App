import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_mobile/src/features/auth/application/providers/auth_providers.dart';
import 'package:app_mobile/src/features/auth/application/notifiers/login_notifier.dart';

// Assuming a shared UI library provides these basic components.
// If not, they can be replaced with standard Material widgets.
// For this generation, standard widgets will be used to ensure compilability.
// import 'package:repo_lib_ui_009/src/widgets/primary_button.dart';
// import 'package:repo_lib_ui_009/src/widgets/text_input_field.dart';

enum AuthMode { email, phone }

class AuthForm extends ConsumerStatefulWidget {
  final VoidCallback onSuccess;

  const AuthForm({
    super.key,
    required this.onSuccess,
  });

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;
  late final TextEditingController _otpController;

  AuthMode _authMode = AuthMode.email;
  bool _passwordVisible = false;
  bool _isOtpSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    final notifier = ref.read(loginNotifierProvider.notifier);

    bool success = false;
    if (_authMode == AuthMode.email) {
      success = await notifier.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      if (!_isOtpSent) {
        success = await notifier.sendOtp(_phoneController.text.trim());
        if (success) {
          setState(() {
            _isOtpSent = true;
          });
        }
      } else {
        success = await notifier.verifyOtp(
          _otpController.text.trim(),
        );
      }
    }

    if (success && mounted && !_isOtpSent) {
      widget.onSuccess();
    } else if (success && mounted && _authMode == AuthMode.phone && _isOtpSent) {
      widget.onSuccess();
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }
    // Simple validation, can be improved with country codes
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number with country code.';
    }
    return null;
  }
  
  String? _validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Verification code is required.';
    }
    if (value.length != 6 || int.tryParse(value) == null) {
      return 'Please enter a valid 6-digit code.';
    }
    return null;
  }

  void _switchAuthMode() {
    setState(() {
      _authMode = _authMode == AuthMode.email ? AuthMode.phone : AuthMode.email;
      _isOtpSent = false;
      _formKey.currentState?.reset();
      ref.read(loginNotifierProvider.notifier).clearError();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifierProvider);
    final isLoading = loginState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    ref.listen<LoginState>(loginNotifierProvider, (_, state) {
      state.whenOrNull(
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
      );
    });

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_authMode == AuthMode.email) ...[
            _buildEmailPasswordForm(isLoading),
          ] else ...[
            _buildPhoneOtpForm(isLoading),
          ],
          const SizedBox(height: 16),
          if (!isLoading)
            TextButton(
              onPressed: _switchAuthMode,
              child: Text(
                _authMode == AuthMode.email
                    ? 'Login with Phone OTP'
                    : 'Login with Email and Password',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmailPasswordForm(bool isLoading) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: !isLoading,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
          obscureText: !_passwordVisible,
          validator: _validatePassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: !isLoading,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: isLoading ? null : () {
              // TODO: Navigate to Forgot Password screen (US-020)
            },
            child: const Text('Forgot Password?'),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          onPressed: isLoading ? null : _submit,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Log In'),
        ),
      ],
    );
  }

  Widget _buildPhoneOtpForm(bool isLoading) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'Phone Number', hintText: '+1234567890'),
          keyboardType: TextInputType.phone,
          validator: _validatePhoneNumber,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: !isLoading && !_isOtpSent,
        ),
        if (_isOtpSent) ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: _otpController,
            decoration: const InputDecoration(labelText: 'Verification Code'),
            keyboardType: TextInputType.number,
            validator: _validateOtp,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            enabled: !isLoading,
          ),
           Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isLoading ? null : () {
                 // TODO: Implement resend logic with cooldown timer (US-018)
              },
              child: const Text('Resend Code'),
            ),
          ),
        ],
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          onPressed: isLoading ? null : _submit,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(_isOtpSent ? 'Verify & Log In' : 'Send Code'),
        ),
      ],
    );
  }
}