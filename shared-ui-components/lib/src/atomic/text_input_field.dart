import 'package:flutter/material.dart';

/// A reusable and styled text input field for use in forms across the application.
///
/// This atomic component wraps a [TextFormField] and applies consistent styling
/// based on the application's theme. It supports various configurations,
/// including password fields with visibility toggles, multiline inputs, and
/// validation error display.
///
/// It is designed to be localization-ready by accepting all text content
/// via constructor parameters (REQ-1-064) and is built with accessibility
/// in mind (REQ-1-063).
class TextInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorMessage;
  final bool isPassword;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final bool enabled;

  /// Creates a styled text input field.
  const TextInputField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorMessage,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.maxLines,
    this.enabled = true,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = !widget.isPassword;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: widget.controller,
      obscureText: !_isPasswordVisible,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorMessage,
        // The overall style (borders, padding, etc.) is derived from
        // the InputDecorationTheme set in AppTheme (Level 1).
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: _togglePasswordVisibility,
                tooltip: _isPasswordVisible
                    ? 'Hide password'
                    : 'Show password', // Note: In a real app, this would be localized.
              )
            : null,
      ),
    );
  }
}