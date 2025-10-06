import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../atomic/primary_button.dart';
import '../atomic/text_input_field.dart';

/// A utility function to show a platform-adaptive confirmation dialog.
///
/// This function abstracts the logic for displaying a Material `AlertDialog` on
/// Android/Web and a `CupertinoAlertDialog` on iOS, ensuring a native look and feel.
/// It is used for actions that require user confirmation, especially destructive ones.
///
/// Returns a `Future<bool?>` which resolves to:
/// - `true` if the user confirms the action.
/// - `false` if the user cancels the action.
/// - `null` if the dialog is dismissed by other means (e.g., tapping outside).
///
/// ### Requirements Covered:
/// - **REQ-1-062 (Platform Guidelines)**: Shows different dialog styles for iOS and Android.
/// - **REQ-1-063 (Accessibility)**: Uses platform dialogs which have good accessibility support.
/// - **User Stories**:
///   - **US-013**: Confirming team deletion.
///   - **US-014**: Confirming removal of a team member.
///   - **US-022**: Confirming tenant deletion.
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool isDestructive = false,
}) {
  if (Platform.isIOS) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text(cancelText),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: isDestructive,
            child: Text(confirmText),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  } else {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text(cancelText),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            style: isDestructive
                ? TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  )
                : null,
            child: Text(confirmText),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }
}

/// A utility function to show a dialog with a text input field.
///
/// Useful for actions that require a mandatory justification, like rejecting a record.
/// Returns a `Future<String?>` which resolves to:
/// - The `String` text if the user confirms.
/// - `null` if the user cancels or dismisses the dialog.
///
/// ### User Stories Covered:
///   - **US-040, US-042**: Supervisor provides a reason for rejecting records.
///   - **US-050**: Admin provides a justification for a direct edit.
Future<String?> showInputDialog({
  required BuildContext context,
  required String title,
  required String labelText,
  String? content,
  String confirmText = 'Submit',
  String cancelText = 'Cancel',
  int minLength = 10,
}) {
  final textController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  if (Platform.isIOS) {
    return showCupertinoDialog<String>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (content != null) ...[
                Text(content),
                const SizedBox(height: 16),
              ],
              Material( // Material widget is needed for text field theming
                color: Colors.transparent,
                child: Form(
                  key: formKey,
                  child: CupertinoTextField(
                    controller: textController,
                    placeholder: labelText,
                    maxLines: 3,
                    autofocus: true,
                    onChanged: (value) => formKey.currentState?.validate(),
                    decoration: BoxDecoration(
                      color: CupertinoColors.extraLightBackgroundGray,
                      border: Border.all(
                        color: CupertinoColors.lightBackgroundGray,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(cancelText),
              onPressed: () => Navigator.of(context).pop(null),
            ),
            CupertinoDialogAction(
              child: Text(confirmText),
              onPressed: () {
                 if (textController.text.trim().length >= minLength) {
                  Navigator.of(context).pop(textController.text.trim());
                }
              },
            ),
          ],
        );
      },
    );
  } else {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (content != null) ...[
                  Text(content),
                  const SizedBox(height: 16),
                ],
                TextInputField(
                  controller: textController,
                  labelText: labelText,
                  autofocus: true,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().length < minLength) {
                      return 'Reason must be at least $minLength characters.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(cancelText),
            ),
            PrimaryButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop(textController.text.trim());
                }
              },
              label: confirmText,
            ),
          ],
        );
      },
    );
  }
}