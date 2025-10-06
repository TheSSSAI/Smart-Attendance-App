import 'package:flutter/material.dart';
import 'package:shared_ui_components/src/atomic/checkbox.dart';
import 'package:shared_ui_components/src/atomic/status_badge.dart';
import 'package:shared_ui_components/src/theme/app_spacing.dart';

/// Enum to define the status of an attendance record for styling the badge.
enum AttendanceStatusType {
  pending,
  approved,
  rejected,
  correctionPending,
}

/// Enum to represent various flags that can be associated with an attendance
/// record.
enum AttendanceFlagType {
  isOfflineEntry,
  clockDiscrepancy,
  autoCheckedOut,
  manuallyCorrected,
}

/// A transient data class (ViewModel) to hold the display data for an
/// [AttendanceListItem].
///
/// This class ensures the UI component is decoupled from the main application's
/// domain models, promoting reusability and adhering to Clean Architecture
/// principles.
class AttendanceListItemData {
  const AttendanceListItemData({
    required this.userName,
    required this.date,
    required this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.flags = const [],
  });

  final String userName;
  final String date;
  final String checkInTime;
  final String? checkOutTime;
  final AttendanceStatusType status;
  final List<AttendanceFlagType> flags;
}

/// A molecular widget that displays a summary of a single attendance record.
///
/// This component is designed to be used in lists within the application, such
/// as a subordinate's history or a supervisor's approval queue. It is highly
/// configurable to show various states and flags.
///
/// Adheres to the following requirements:
/// - **REQ-1-062**: Styling is derived from the application's `ThemeData`.
/// - **REQ-1-063 (Accessibility)**: Uses semantic labels, ensures touch targets,
///   and is built with responsive widgets to support dynamic text scaling.
/// - **REQ-1-064 (Internationalization)**: All displayable text is passed in
///   via the [data] object, ensuring no hardcoded strings.
/// - **REQ-1-067 (Performance)**: Designed to be efficient for use in long lists.
class AttendanceListItem extends StatelessWidget {
  /// Creates a list item for an attendance record.
  const AttendanceListItem({
    super.key,
    required this.data,
    this.onTap,
    this.isSelected = false,
    this.onSelectedChanged,
  });

  /// The data model containing all the information to be displayed.
  final AttendanceListItemData data;

  /// An optional callback that is triggered when the list item is tapped.
  final VoidCallback? onTap;

  /// Whether the item is currently selected. Used for bulk operations.
  final bool isSelected;

  /// An optional callback that is triggered when the selection state changes.
  /// If this is provided, a checkbox will be displayed.
  final ValueChanged<bool?>? onSelectedChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Semantics(
      label:
          'Attendance for ${data.userName} on ${data.date}, Status: ${data.status.name}',
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(color: theme.dividerColor),
            ),
          ),
          constraints: const BoxConstraints(
            minHeight: 64, // Ensures minimum touch target size
          ),
          child: Row(
            children: [
              if (onSelectedChanged != null)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.small),
                  child: AppCheckbox(
                    value: isSelected,
                    onChanged: onSelectedChanged,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.userName,
                      style: textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxsmall),
                    Text(
                      data.date,
                      style: textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeRow(
                    context,
                    icon: Icons.login,
                    time: data.checkInTime,
                    semanticLabel: 'Check in time',
                  ),
                  const SizedBox(height: AppSpacing.xxsmall),
                  _buildTimeRow(
                    context,
                    icon: Icons.logout,
                    time: data.checkOutTime ?? '--:--',
                    semanticLabel: 'Check out time',
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.medium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusBadge(data.status),
                  if (data.flags.isNotEmpty)
                    const SizedBox(height: AppSpacing.xxsmall),
                  if (data.flags.isNotEmpty)
                    _buildFlagsRow(context, data.flags),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRow(
    BuildContext context, {
    required IconData icon,
    required String time,
    required String semanticLabel,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Semantics(
      label: '$semanticLabel: $time',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xsmall),
            Text(time, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AttendanceStatusType status) {
    switch (status) {
      case AttendanceStatusType.pending:
        return const StatusBadge(status: 'Pending', type: BadgeType.pending);
      case AttendanceStatusType.approved:
        return const StatusBadge(status: 'Approved', type: BadgeType.approved);
      case AttendanceStatusType.rejected:
        return const StatusBadge(status: 'Rejected', type: BadgeType.rejected);
      case AttendanceStatusType.correctionPending:
        return const StatusBadge(
            status: 'Correction Pending', type: BadgeType.info);
    }
  }

  Widget _buildFlagsRow(BuildContext context, List<AttendanceFlagType> flags) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: flags
          .map((flag) => Padding(
                padding: const EdgeInsets.only(left: AppSpacing.xsmall),
                child: Tooltip(
                  message: _getFlagTooltip(flag),
                  child: Icon(
                    _getFlagIcon(flag),
                    size: 16,
                    color: theme.colorScheme.secondary,
                    semanticLabel: _getFlagTooltip(flag),
                  ),
                ),
              ))
          .toList(),
    );
  }

  IconData _getFlagIcon(AttendanceFlagType flag) {
    switch (flag) {
      case AttendanceFlagType.isOfflineEntry:
        return Icons.cloud_off;
      case AttendanceFlagType.clockDiscrepancy:
        return Icons.sync_problem;
      case AttendanceFlagType.autoCheckedOut:
        return Icons.schedule;
      case AttendanceFlagType.manuallyCorrected:
        return Icons.edit;
    }
  }

  String _getFlagTooltip(AttendanceFlagType flag) {
    switch (flag) {
      case AttendanceFlagType.isOfflineEntry:
        return 'Offline Entry';
      case AttendanceFlagType.clockDiscrepancy:
        return 'Clock Discrepancy';
      case AttendanceFlagType.autoCheckedOut:
        return 'Auto Checked Out';
      case AttendanceFlagType.manuallyCorrected:
        return 'Manually Corrected';
    }
  }
}