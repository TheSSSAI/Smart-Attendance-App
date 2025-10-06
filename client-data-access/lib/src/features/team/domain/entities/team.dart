import 'package:equatable/equatable.dart';

/// Represents a team within an organization's tenant.
/// This is a pure domain entity.
class Team extends Equatable {
  /// The unique identifier for the team.
  final String id;

  /// The ID of the tenant this team belongs to.
  final String tenantId;

  /// The name of the team.
  final String name;

  /// The ID of the user designated as the supervisor for this team.
  final String supervisorId;

  /// A list of user IDs for the members of this team.
  final List<String> memberIds;

  const Team({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.supervisorId,
    this.memberIds = const [],
  });
  
  /// Returns the number of members in the team.
  int get memberCount => memberIds.length;

  @override
  List<Object?> get props => [id, tenantId, name, supervisorId, memberIds];
}