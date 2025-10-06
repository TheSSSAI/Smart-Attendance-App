import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/attendance_record.dart';

class AttendanceModel extends AttendanceRecord {
  const AttendanceModel({
    required String id,
    required String userId,
    required String tenantId,
    String? supervisorId,
    DateTime? checkInTime,
    GeoPoint? checkInGps,
    DateTime? checkOutTime,
    GeoPoint? checkOutGps,
    required AttendanceStatus status,
    String? eventId,
    List<String> flags = const [],
    String? rejectionReason,
    Map<String, dynamic> correctionDetails = const {},
    required bool isOfflineEntry,
  }) : super(
          id: id,
          userId: userId,
          tenantId: tenantId,
          supervisorId: supervisorId,
          checkInTime: checkInTime,
          checkInGps: checkInGps,
          checkOutTime: checkOutTime,
          checkOutGps: checkOutGps,
          status: status,
          eventId: eventId,
          flags: flags,
          rejectionReason: rejectionReason,
          correctionDetails: correctionDetails,
          isOfflineEntry: isOfflineEntry,
        );

  factory AttendanceModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return AttendanceModel(
      id: snap.id,
      userId: data['userId'] as String,
      tenantId: data['tenantId'] as String,
      supervisorId: data['supervisorId'] as String?,
      checkInTime: (data['checkInTime'] as Timestamp?)?.toDate(),
      checkInGps: data['checkInGps'] as GeoPoint?,
      checkOutTime: (data['checkOutTime'] as Timestamp?)?.toDate(),
      checkOutGps: data['checkOutGps'] as GeoPoint?,
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString() == 'AttendanceStatus.${data['status']}',
        orElse: () => AttendanceStatus.pending,
      ),
      eventId: data['eventId'] as String?,
      flags: List<String>.from(data['flags'] ?? []),
      rejectionReason: data['rejectionReason'] as String?,
      correctionDetails:
          Map<String, dynamic>.from(data['correctionDetails'] ?? {}),
      isOfflineEntry: data['isOfflineEntry'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'tenantId': tenantId,
      if (supervisorId != null) 'supervisorId': supervisorId,
      if (checkInTime != null) 'checkInTime': Timestamp.fromDate(checkInTime!),
      if (checkInGps != null) 'checkInGps': checkInGps,
      if (checkOutTime != null)
        'checkOutTime': Timestamp.fromDate(checkOutTime!),
      if (checkOutGps != null) 'checkOutGps': checkOutGps,
      'status': status.name,
      if (eventId != null) 'eventId': eventId,
      'flags': flags,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      'correctionDetails': correctionDetails,
      'isOfflineEntry': isOfflineEntry,
      'serverTimestamp': FieldValue.serverTimestamp(),
    };
  }

  factory AttendanceModel.fromEntity(AttendanceRecord entity) {
    return AttendanceModel(
      id: entity.id,
      userId: entity.userId,
      tenantId: entity.tenantId,
      supervisorId: entity.supervisorId,
      checkInTime: entity.checkInTime,
      checkInGps: entity.checkInGps,
      checkOutTime: entity.checkOutTime,
      checkOutGps: entity.checkOutGps,
      status: entity.status,
      eventId: entity.eventId,
      flags: entity.flags,
      rejectionReason: entity.rejectionReason,
      correctionDetails: entity.correctionDetails,
      isOfflineEntry: entity.isOfflineEntry,
    );
  }

  AttendanceModel copyWith({
    String? id,
    String? userId,
    String? tenantId,
    String? supervisorId,
    DateTime? checkInTime,
    GeoPoint? checkInGps,
    DateTime? checkOutTime,
    GeoPoint? checkOutGps,
    AttendanceStatus? status,
    String? eventId,
    List<String>? flags,
    String? rejectionReason,
    Map<String, dynamic>? correctionDetails,
    bool? isOfflineEntry,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tenantId: tenantId ?? this.tenantId,
      supervisorId: supervisorId ?? this.supervisorId,
      checkInTime: checkInTime ?? this.checkInTime,
      checkInGps: checkInGps ?? this.checkInGps,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkOutGps: checkOutGps ?? this.checkOutGps,
      status: status ?? this.status,
      eventId: eventId ?? this.eventId,
      flags: flags ?? this.flags,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      correctionDetails: correctionDetails ?? this.correctionDetails,
      isOfflineEntry: isOfflineEntry ?? this.isOfflineEntry,
    );
  }
}