import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_lib_client_008/repo_lib_client_008.dart';

part 'correction_request_notifier.freezed.dart';

@freezed
class CorrectionRequestState with _$CorrectionRequestState {
  const factory CorrectionRequestState.initial() = _Initial;
  const factory CorrectionRequestState.loading(String message) = _Loading;
  const factory CorrectionRequestState.success(String message) = _Success;
  const factory CorrectionRequestState.error(String message) = _Error;
}

class CorrectionRequestNotifier extends StateNotifier<CorrectionRequestState> {
  final ICorrectionRepository _correctionRepository;
  final String _userId;

  CorrectionRequestNotifier({
    required ICorrectionRepository correctionRepository,
    required String userId,
  })  : _correctionRepository = correctionRepository,
        _userId = userId,
        super(const CorrectionRequestState.initial());

  Future<void> submitCorrectionRequest({
    required String attendanceRecordId,
    required DateTime? newCheckInTime,
    required DateTime? newCheckOutTime,
    required String justification,
  }) async {
    // Validation
    if (justification.trim().length < 20) {
      state = const CorrectionRequestState.error('Justification must be at least 20 characters long.');
      return;
    }
    if (newCheckInTime == null && newCheckOutTime == null) {
      state = const CorrectionRequestState.error('You must suggest at least one new time.');
      return;
    }
    // Assuming original times are passed or fetched inside repository.
    // Here we'll just check if new times are logical.
    if (newCheckInTime != null && newCheckOutTime != null && newCheckOutTime.isBefore(newCheckInTime)) {
      state = const CorrectionRequestState.error('New check-out time must be after new check-in time.');
      return;
    }

    state = const CorrectionRequestState.loading('Submitting correction request...');
    try {
      await _correctionRepository.submitCorrectionRequest(
        recordId: attendanceRecordId,
        userId: _userId,
        newCheckIn: newCheckInTime,
        newCheckOut: newCheckOutTime,
        justification: justification,
      );
      state = const CorrectionRequestState.success('Correction request submitted successfully.');
    } on CorrectionException catch (e) {
      state = CorrectionRequestState.error(e.message);
    } catch (e) {
      state = const CorrectionRequestState.error('An unexpected error occurred.');
    }
  }

  Future<void> approveCorrectionRequest({
    required String attendanceRecordId,
    required String supervisorId,
  }) async {
    state = const CorrectionRequestState.loading('Approving request...');
    try {
      await _correctionRepository.approveCorrectionRequest(
        recordId: attendanceRecordId,
        supervisorId: supervisorId,
      );
      state = const CorrectionRequestState.success('Correction approved.');
    } on CorrectionException catch (e) {
      state = CorrectionRequestState.error(e.message);
    } catch (e) {
      state = const CorrectionRequestState.error('An unexpected error occurred.');
    }
  }

  Future<void> rejectCorrectionRequest({
    required String attendanceRecordId,
    required String supervisorId,
    required String reason,
  }) async {
    if (reason.trim().isEmpty) {
      state = const CorrectionRequestState.error('A reason is required for rejection.');
      return;
    }

    state = const CorrectionRequestState.loading('Rejecting request...');
    try {
      await _correctionRepository.rejectCorrectionRequest(
        recordId: attendanceRecordId,
        supervisorId: supervisorId,
        reason: reason,
      );
      state = const CorrectionRequestState.success('Correction rejected.');
    } on CorrectionException catch (e) {
      state = CorrectionRequestState.error(e.message);
    } catch (e) {
      state = const CorrectionRequestState.error('An unexpected error occurred.');
    }
  }

  void resetState() {
    state = const CorrectionRequestState.initial();
  }
}