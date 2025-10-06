import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String tenantId,
    required String email,
    required String name,
    required UserRole role,
    required UserStatus status,
    String? supervisorId,
    List<String> teamIds = const [],
    String? phoneNumber,
    DateTime? deactivatedTimestamp,
  }) : super(
          id: id,
          tenantId: tenantId,
          email: email,
          name: name,
          role: role,
          status: status,
          supervisorId: supervisorId,
          teamIds: teamIds,
          phoneNumber: phoneNumber,
          deactivatedTimestamp: deactivatedTimestamp,
        );

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return UserModel(
      id: snap.id,
      tenantId: data['tenantId'] as String,
      email: data['email'] as String,
      name: data['name'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${data['role']}',
        orElse: () => UserRole.Subordinate,
      ),
      status: UserStatus.values.firstWhere(
        (e) => e.toString() == 'UserStatus.${data['status']}',
        orElse: () => UserStatus.invited,
      ),
      supervisorId: data['supervisorId'] as String?,
      teamIds: List<String>.from(data['teamIds'] ?? []),
      phoneNumber: data['phoneNumber'] as String?,
      deactivatedTimestamp:
          (data['deactivatedTimestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenantId': tenantId,
      'email': email,
      'name': name,
      'role': role.name,
      'status': status.name,
      if (supervisorId != null) 'supervisorId': supervisorId,
      'teamIds': teamIds,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (deactivatedTimestamp != null)
        'deactivatedTimestamp': Timestamp.fromDate(deactivatedTimestamp!),
    };
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      tenantId: entity.tenantId,
      email: entity.email,
      name: entity.name,
      role: entity.role,
      status: entity.status,
      supervisorId: entity.supervisorId,
      teamIds: entity.teamIds,
      phoneNumber: entity.phoneNumber,
      deactivatedTimestamp: entity.deactivatedTimestamp,
    );
  }

  UserModel copyWith({
    String? id,
    String? tenantId,
    String? email,
    String? name,
    UserRole? role,
    UserStatus? status,
    String? supervisorId,
    List<String>? teamIds,
    String? phoneNumber,
    DateTime? deactivatedTimestamp,
  }) {
    return UserModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      status: status ?? this.status,
      supervisorId: supervisorId ?? this.supervisorId,
      teamIds: teamIds ?? this.teamIds,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      deactivatedTimestamp: deactivatedTimestamp ?? this.deactivatedTimestamp,
    );
  }
}