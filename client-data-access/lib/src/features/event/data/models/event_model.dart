import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({
    required String id,
    required String tenantId,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    required String createdBy,
    List<String> assignedUserIds = const [],
    List<String> assignedTeamIds = const [],
    Map<String, dynamic> recurrenceRule = const {},
  }) : super(
          id: id,
          tenantId: tenantId,
          title: title,
          description: description,
          startTime: startTime,
          endTime: endTime,
          createdBy: createdBy,
          assignedUserIds: assignedUserIds,
          assignedTeamIds: assignedTeamIds,
          recurrenceRule: recurrenceRule,
        );

  factory EventModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return EventModel(
      id: snap.id,
      tenantId: data['tenantId'] as String,
      title: data['title'] as String,
      description: data['description'] as String?,
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      createdBy: data['createdBy'] as String,
      assignedUserIds: List<String>.from(data['assignedUserIds'] ?? []),
      assignedTeamIds: List<String>.from(data['assignedTeamIds'] ?? []),
      recurrenceRule: Map<String, dynamic>.from(data['recurrenceRule'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenantId': tenantId,
      'title': title,
      if (description != null) 'description': description,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'createdBy': createdBy,
      'assignedUserIds': assignedUserIds,
      'assignedTeamIds': assignedTeamIds,
      'recurrenceRule': recurrenceRule,
    };
  }

  factory EventModel.fromEntity(Event entity) {
    return EventModel(
      id: entity.id,
      tenantId: entity.tenantId,
      title: entity.title,
      description: entity.description,
      startTime: entity.startTime,
      endTime: entity.endTime,
      createdBy: entity.createdBy,
      assignedUserIds: entity.assignedUserIds,
      assignedTeamIds: entity.assignedTeamIds,
      recurrenceRule: entity.recurrenceRule,
    );
  }

  EventModel copyWith({
    String? id,
    String? tenantId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? createdBy,
    List<String>? assignedUserIds,
    List<String>? assignedTeamIds,
    Map<String, dynamic>? recurrenceRule,
  }) {
    return EventModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdBy: createdBy ?? this.createdBy,
      assignedUserIds: assignedUserIds ?? this.assignedUserIds,
      assignedTeamIds: assignedTeamIds ?? this.assignedTeamIds,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
    );
  }
}