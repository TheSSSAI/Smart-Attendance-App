import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Assuming these are defined in the data access library (repo_lib_client_008)
// and represent the domain models.
import 'package:app_mobile/src/core/models/attendance_record.dart'; 
import 'package:app_mobile/src/core/models/user.dart';

class AttendanceListItem extends StatelessWidget {
  final AttendanceRecord record;
  final UserRole currentUserRole;
  final bool isSelectable;
  final bool isSelected;
  final ValueChanged<bool?>? onSelected;
  final VoidCallback? onTap;

  const AttendanceListItem({
    super.key,
    required this.record,
    required this.currentUserRole,
    this.isSelectable = false,
    this.isSelected = false,
    this.onSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color statusColor = _getStatusColor(record.status, theme);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSelectable)
                Checkbox(
                  value: isSelected,
                  onChanged: onSelected,
                  visualDensity: VisualDensity.compact,
                ),
              Container(
                width: 4,
                height: 80, // Approximate height to match content
                color: statusColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 8),
                    _buildTimeDetails(context),
                    const SizedBox(height: 8),
                    _buildStatusAndFlags(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dateString = DateFormat.yMMMMd().format(record.checkInTime);

    if (currentUserRole == UserRole.supervisor) {
      // Supervisor sees the subordinate's name
      return Text(
        record.userName ?? 'Unknown User',
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      // Subordinate sees the date
      return Text(
        dateString,
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      );
    }
  }

  Widget _buildTimeDetails(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final timeFormat = DateFormat.jm(); // e.g., 5:08 PM

    final checkInString = timeFormat.format(record.checkInTime);
    final checkOutString = record.checkOutTime != null
        ? timeFormat.format(record.checkOutTime!)
        : '--:--';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Check-in', style: textTheme.bodySmall),
            Text(checkInString, style: textTheme.bodyLarge),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Check-out', style: textTheme.bodySmall),
            Text(checkOutString, style: textTheme.bodyLarge),
          ],
        ),
        if (record.checkInTime != null && record.checkOutTime != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Duration', style: textTheme.bodySmall),
              Text(_calculateDuration(record.checkInTime, record.checkOutTime!),
                  style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
      ],
    );
  }

  String _calculateDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  Widget _buildStatusAndFlags(BuildContext context) {
    if (record.flags.isEmpty && record.status == AttendanceStatus.approved) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: [
        _buildStatusChip(context),
        ...record.flags.map((flag) => _buildFlagChip(flag, context)),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(
        record.status.name.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
      ),
      backgroundColor: _getStatusColor(record.status, theme),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildFlagChip(AttendanceFlag flag, BuildContext context) {
    final theme = Theme.of(context);
    final IconData icon = _getFlagIcon(flag);
    final String label = _getFlagLabel(flag);
    final Color color = _getFlagColor(flag, theme);

    return Tooltip(
      message: _getFlagTooltip(flag),
      child: Chip(
        avatar: Icon(icon, size: 14, color: color),
        label: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(color: color),
        ),
        backgroundColor: color.withOpacity(0.12),
        side: BorderSide(color: color.withOpacity(0.4)),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Color _getStatusColor(AttendanceStatus status, ThemeData theme) {
    switch (status) {
      case AttendanceStatus.approved:
        return Colors.green.shade600;
      case AttendanceStatus.pending:
        return Colors.orange.shade600;
      case AttendanceStatus.rejected:
        return theme.colorScheme.error;
      case AttendanceStatus.correctionPending:
        return Colors.blue.shade600;
    }
  }

  IconData _getFlagIcon(AttendanceFlag flag) {
    switch (flag) {
      case AttendanceFlag.isOfflineEntry:
        return Icons.cloud_off;
      case AttendanceFlag.clockDiscrepancy:
        return Icons.watch_later_outlined;
      case AttendanceFlag.autoCheckedOut:
        return Icons.power_settings_new;
      case AttendanceFlag.manuallyCorrected:
        return Icons.edit;
    }
  }

  String _getFlagLabel(AttendanceFlag flag) {
    switch (flag) {
      case AttendanceFlag.isOfflineEntry:
        return 'OFFLINE';
      case AttendanceFlag.clockDiscrepancy:
        return 'TIME MISMATCH';
      case AttendanceFlag.autoCheckedOut:
        return 'AUTO';
      case AttendanceFlag.manuallyCorrected:
        return 'EDITED';
    }
  }

  String _getFlagTooltip(AttendanceFlag flag) {
    switch (flag) {
      case AttendanceFlag.isOfflineEntry:
        return 'This entry was recorded while the device was offline.';
      case AttendanceFlag.clockDiscrepancy:
        return 'Device time differed from server time by more than 5 minutes.';
      case AttendanceFlag.autoCheckedOut:
        return 'User was automatically checked out by the system.';
      case AttendanceFlag.manuallyCorrected:
        return 'This record was manually corrected by an administrator or supervisor.';
    }
  }

   Color _getFlagColor(AttendanceFlag flag, ThemeData theme) {
    switch (flag) {
      case AttendanceFlag.isOfflineEntry:
        return Colors.grey.shade700;
      case AttendanceFlag.clockDiscrepancy:
        return Colors.purple.shade600;
      case AttendanceFlag.autoCheckedOut:
        return Colors.blueGrey.shade600;
      case AttendanceFlag.manuallyCorrected:
        return Colors.blue.shade700;
    }
  }
}

// Dummy UserRole enum for compilation. This would be imported from a domain model.
enum UserRole {
  admin,
  supervisor,
  subordinate,
}