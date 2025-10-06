import 'package:flutter/material.dart';

/// A consistent, theme-aware app bar for use as the primary top bar on screens.
///
/// This molecular component implements [PreferredSizeWidget] for direct use in
/// a [Scaffold]'s `appBar` property. It provides a standardized appearance
/// for screen titles and actions, deriving its styling from the `AppBarTheme`
/// defined in `AppTheme`.
///
/// Accessibility is handled by ensuring the title is treated as a header by
/// screen readers.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text to display in the app bar.
  final String title;

  /// An optional widget to display before the title (e.g., a back button).
  final Widget? leading;

  /// A list of widgets to display after the title (e.g., action icons).
  final List<Widget>? actions;

  /// Creates a new app bar.
  const AppTopBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // By not setting specific colors or text styles here, we ensure that
      // this component correctly uses the AppBarTheme defined in AppTheme,
      // making it fully theme-aware (REQ-1-062).
      leading: leading,
      title: Semantics(
        header: true,
        child: Text(title),
      ),
      actions: actions,
      centerTitle: true,
    );
  }

  /// The preferred height of the app bar, which is the standard toolbar height.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}