/**
 * Represents the Team aggregate root in the domain.
 * A Team is a collection of users managed by a single Supervisor.
 */
export class Team {
  /**
   * The unique identifier for the team.
   */
  public readonly id: string;

  /**
   * The identifier of the tenant this team belongs to.
   */
  public readonly tenantId: string;

  private _name: string;
  private _supervisorId: string;
  private _memberIds: Set<string>;

  /**
   * @param id The unique identifier for the team.
   * @param tenantId The identifier of the tenant.
   * @param name The name of the team.
   * @param supervisorId The user ID of the team's supervisor.
   * @param memberIds An initial array of user IDs for team members.
   */
  constructor(id: string, tenantId: string, name: string, supervisorId: string, memberIds: string[] = []) {
    if (!id || !tenantId || !name || !supervisorId) {
      throw new Error("Team entity requires id, tenantId, name, and supervisorId.");
    }
    this.id = id;
    this.tenantId = tenantId;
    this._name = name;
    this._supervisorId = supervisorId;
    this._memberIds = new Set(memberIds);
  }

  get name(): string {
    return this._name;
  }

  get supervisorId(): string {
    return this._supervisorId;
  }

  /**
   * Returns a copy of the member IDs array.
   */
  get memberIds(): string[] {
    return Array.from(this._memberIds);
  }

  /**
   * Updates the name of the team.
   * @param newName The new name for the team.
   */
  public changeName(newName: string): void {
    if (!newName || newName.trim().length === 0) {
      throw new Error("Team name cannot be empty.");
    }
    this._name = newName;
  }

  /**
   * Changes the supervisor for the team.
   * @param newSupervisorId The user ID of the new supervisor.
   */
  public changeSupervisor(newSupervisorId: string): void {
    if (!newSupervisorId) {
      throw new Error("Supervisor ID cannot be empty.");
    }
    this._supervisorId = newSupervisorId;
  }

  /**
   * Adds a new member to the team.
   * @param userId The user ID of the member to add.
   * @throws An error if the user is already a member of the team.
   */
  public addMember(userId: string): void {
    if (this._memberIds.has(userId)) {
      throw new Error(`User with ID ${userId} is already a member of this team.`);
    }
    this._memberIds.add(userId);
  }

  /**
   * Removes a member from the team.
   * @param userId The user ID of the member to remove.
   * @throws An error if the user is not a member of the team.
   */
  public removeMember(userId: string): void {
    if (!this._memberIds.has(userId)) {
      throw new Error(`User with ID ${userId} is not a member of this team.`);
    }
    this._memberIds.delete(userId);
  }

  /**
   * Checks if a user is a member of this team.
   * @param userId The user ID to check.
   * @returns True if the user is a member, false otherwise.
   */
  public isMember(userId: string): boolean {
    return this._memberIds.has(userId);
  }
}