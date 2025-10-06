/**
 * Represents the Event aggregate root in the domain.
 * An Event is a scheduled activity that can be assigned to users or teams.
 */
export class Event {
  /**
   * The unique identifier for the event.
   */
  public readonly id: string;

  /**
   * The identifier of the tenant this event belongs to.
   */
  public readonly tenantId: string;

  /**
   * The user ID of the person who created the event.
   */
  public readonly createdByUserId: string;

  public title: string;
  public description?: string;
  public startTime: Date;
  public endTime: Date;
  public assignedUserIds: Set<string>;
  public assignedTeamIds: Set<string>;
  public recurrenceRule?: string;

  /**
   * @param id The unique identifier for the event.
   * @param tenantId The identifier of the tenant.
   * @param createdByUserId The user ID of the event creator.
   * @param title The title of the event.
   * @param startTime The start date and time of the event.
   * @param endTime The end date and time of the event.
   * @param description An optional description of the event.
   * @param assignedUserIds An array of user IDs directly assigned to the event.
   * @param assignedTeamIds An array of team IDs assigned to the event.
   * @param recurrenceRule An optional RRULE string for recurring events.
   */
  constructor(
    id: string,
    tenantId: string,
    createdByUserId: string,
    title: string,
    startTime: Date,
    endTime: Date,
    description?: string,
    assignedUserIds: string[] = [],
    assignedTeamIds: string[] = [],
    recurrenceRule?: string,
  ) {
    if (!id || !tenantId || !createdByUserId || !title || !startTime || !endTime) {
      throw new Error("Event entity requires id, tenantId, createdByUserId, title, startTime, and endTime.");
    }

    if (endTime <= startTime) {
      throw new Error("Event end time must be after the start time.");
    }

    this.id = id;
    this.tenantId = tenantId;
    this.createdByUserId = createdByUserId;
    this.title = title;
    this.description = description;
    this.startTime = startTime;
    this.endTime = endTime;
    this.assignedUserIds = new Set(assignedUserIds);
    this.assignedTeamIds = new Set(assignedTeamIds);
    this.recurrenceRule = recurrenceRule;
  }

  /**
   * Checks if the event is a recurring event.
   * @returns True if the event has a recurrence rule, false otherwise.
   */
  public isRecurring(): boolean {
    return !!this.recurrenceRule && this.recurrenceRule.length > 0;
  }

  /**
   * Updates the details of the event.
   * @param details An object containing the event details to update.
   */
  public updateDetails(details: {
    title?: string;
    description?: string;
    startTime?: Date;
    endTime?: Date;
  }): void {
    const newStartTime = details.startTime ?? this.startTime;
    const newEndTime = details.endTime ?? this.endTime;

    if (newEndTime <= newStartTime) {
      throw new Error("Event end time must be after the start time.");
    }

    this.title = details.title ?? this.title;
    this.description = details.description ?? this.description;
    this.startTime = newStartTime;
    this.endTime = newEndTime;
  }

  /**
   * Assigns the event to a specific user.
   * @param userId The ID of the user to assign.
   */
  public assignToUser(userId: string): void {
    this.assignedUserIds.add(userId);
  }

  /**
   * Unassigns a user from the event.
   * @param userId The ID of the user to unassign.
   */
  public unassignFromUser(userId: string): void {
    this.assignedUserIds.delete(userId);
  }

  /**
   * Assigns the event to a specific team.
   * @param teamId The ID of the team to assign.
   */
  public assignToTeam(teamId: string): void {
    this.assignedTeamIds.add(teamId);
  }

  /**
   * Unassigns a team from the event.
   * @param teamId The ID of the team to unassign.
   */
  public unassignFromTeam(teamId: string): void {
    this.assignedTeamIds.delete(teamId);
  }
}