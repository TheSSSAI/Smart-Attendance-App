import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_lib_client_008/repo_lib_client_008.dart';

part 'supervisor_dashboard_notifier.freezed.dart';

@freezed
class SupervisorDashboardActionState with _$SupervisorDashboardActionState {
  const factory SupervisorDashboardActionState.initial() = _Initial;
  const factory SupervisorDashboardActionState.loading(String message) = _Loading;
  const factory SupervisorDashboardActionState.success(String message) = _Success;
  const factory SupervisorDashboardActionState.error(String message) = _Error;
}

class SupervisorDashboardNotifier extends StateNotifier<SupervisorDashboardActionState> {
  final IAttendanceRepository _attendanceRepository;
  final ICorrectionRepository _correctionRepository;
  final String _supervisorId;

  SupervisorDashboardNotifier({
    required IAttendanceRepository attendanceRepository,
    required ICorrectionRepository correctionRepository,
    required String supervisorId,
  })  : _attendanceRepository = attendanceRepository,
        _correctionRepository = correctionRepository,
        _supervisorId = supervisorId,
        super(const SupervisorDashboardActionState.initial());

  Future<void> approveRecord(String attendanceRecordId) async {
    state = const SupervisorDashboardActionState.loading('Approving record...');
    try {
      await _attendanceRepository.approveRecord(
        recordId: attendanceRecordId,
        supervisorId: _supervisorId,
      );
      state = const SupervisorDashboardActionState.success('Record approved.');
    } on AttendanceException catch (e) {
      state = SupervisorDashboardActionState.error(e.message);
    } catch (e) {
      state = const SupervisorDashboardActionState.error('An unexpected error occurred.');
    }
  }

  Future<void> rejectRecord(String attendanceRecordId, String reason) async {
    if (reason.trim().isEmpty) {
      state = const SupervisorDashboardActionState.error('A reason is required for rejection.');
      return;
    }
    state = const SupervisorDashboardActionState.loading('Rejecting record...');
    try {
      await _attendanceRepository.rejectRecord(
        recordId: attendanceRecordId,
        supervisorId: _supervisorId,
        reason: reason,
      );
      state = const SupervisorDashboardActionState.success('Record rejected.');
    } on AttendanceException catch (e) {
      state = SupervisorDashboardActionState.error(e.message);
    } catch (e) {
      state = const SupervisorDashboardActionState.error('An unexpected error occurred.');
    }
  }
  
  Future<void> approveMultipleRecords(List<String> recordIds) async {
    if (recordIds.isEmpty) return;
    state = SupervisorDashboardActionState.loading('Approving ${recordIds.length} records...');
    try {
      await _attendanceRepository.approveMultipleRecords(
        recordIds: recordIds,
        supervisorId: _supervisorId,
      );
      state = SupervisorDashboardActionState.success('${recordIds.length} records approved.');
    } on AttendanceException catch (e) {
      state = SupervisorDashboardActionState.error(e.message);
    } catch (e) {
      state = const SupervisorDashboardActionState.error('An unexpected error occurred during bulk approval.');
    }
  }

  Future<void> rejectMultipleRecords(List<String> recordIds, String reason) async {
    if (recordIds.isEmpty) return;
    if (reason.trim().isEmpty) {
      state = const SupervisorDashboardActionState.error('A reason is required for rejection.');
      return;
    }
    state = SupervisorDashboardActionState.loading('Rejecting ${recordIds.length} records...');
    try {
      await _attendanceRepository.rejectMultipleRecords(
        recordIds: recordIds,
        supervisorId: _supervisorId,
        reason: reason,
      );
      state = SupervisorDashboardActionState.success('${recordIds.length} records rejected.');
    } on AttendanceException catch (e) {
      state = SupervisorDashboardActionState.error(e.message);
    } catch (e) {
      state = const SupervisorDashboardActionState.error('An unexpected error occurred during bulk rejection.');
    }
  }

  void resetState() {
    state = const SupervisorDashboardActionState.initial();
  }
}