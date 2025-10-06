/// A library that exports all the shared UI components for the attendance application.
///
/// This barrel file simplifies the process of importing shared widgets, themes, and
/// utilities into consumer applications (mobile and web). Instead of referencing
/// individual files within the package's internal `src` directory, consumers can
/// use a single import statement:
/// `import 'package:shared_ui_components/shared_ui_components.dart';`
///
/// This approach decouples the consumer from the internal file structure of this
/// package, making the library easier to maintain and evolve.
///
/// The exported components are organized by their architectural layer based on
/// Atomic Design principles:
/// - **Theme**: Core design system tokens like colors, typography, spacing, and the main `ThemeData`.
/// - **Atomic**: The smallest, indivisible UI components (e.g., buttons, inputs, badges).
/// - **Molecular**: More complex components composed of multiple atoms (e.g., app bars, list items).
/// - **Organism**: Large, complex components representing distinct sections of an interface (e.g., forms, calendars).

library shared_ui_components;

// --- THEME (Design System Core) ---
export 'src/theme/app_colors.dart';
export 'src/theme/app_spacing.dart';
export 'src/theme/app_theme.dart';
export 'src/theme/app_typography.dart';

// --- ATOMIC COMPONENTS ---
export 'src/atomic/alert_banner.dart';
export 'src/atomic/checkbox.dart';
export 'src/atomic/loading_spinner.dart';
export 'src/atomic/primary_button.dart';
export 'src/atomic/status_badge.dart';
export 'src/atomic/text_input_field.dart';

// --- MOLECULAR COMPONENTS ---
export 'src/molecular/app_bar.dart';
export 'src/molecular/attendance_list_item.dart';
export 'src/molecular/bottom_navigation_bar.dart';
export 'src/molecular/confirmation_dialog.dart';
export 'src/molecular/date_time_picker.dart';

// --- ORGANISM COMPONENTS ---
export 'src/organism/authentication_form.dart';
export 'src/organism/calendar_view.dart';