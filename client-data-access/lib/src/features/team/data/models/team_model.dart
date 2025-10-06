import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/team.dart';

class TeamModel extends Team {
  const TeamModel({
    required String id,
    required String tenantId,
    required String name,
    required String supervisorId,
    List<String> memberIds = const [],
  }) : super(
          id: id,
          tenantId: tenantId,
          name: name,
          supervisorId: supervisorId,
          memberIds: memberIds,
        );

  factory TeamModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return TeamModel(
      id: snap.id,
      tenantId: data['tenantId'] as String,
      name: data['name'] as String,
      supervisorId: data['supervisorId'] as String,
      memberIds: List<String>.from(data['memberIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenantId': tenantId,
      'name': name,
      'supervisorId': supervisorId,
      'memberIds': memberIds,
    };
  }

  factory TeamModel.fromEntity(Team entity) {
    return TeamModel(
      id: entity.id,
      tenantId: entity.tenantId,
      name: entity.name,
      supervisorId: entity.supervisorId,
      memberIds: entity.memberIds,
    );
  }

  TeamModel copyWith({
    String? id,
    String? tenantId,
    String? name,
    String? supervisorId,
    List<String>? memberIds,
  }) {
    return TeamModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      name: name ?? this.name,
      supervisorId: supervisorId ?? this.supervisorId,
      memberIds: memberIds ?? this.memberIds,
    );
  }
}