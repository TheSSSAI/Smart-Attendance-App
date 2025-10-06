/**
 * @fileoverview Defines the contract for a User repository.
 * This interface abstracts the data persistence logic for the User aggregate root.
 */

// These types would typically be imported from a shared core domain models library (e.g., REPO-LIB-CORE-001)
export type UserRole = 'Admin' | 'Supervisor' | 'Subordinate';
export type UserStatus = 'active' | 'invited' | 'deactivated' | 'anonymized';

export interface User {
  userId: string; // Corresponds to Firebase Auth UID
  tenantId: string;
  email: string;
  name: string;
  role: UserRole;
  status: UserStatus;
  supervisorId?: string | null;
  teamIds: string[];
  createdAt: Date;
  deactivatedAt?: Date;
  invitationToken?: string;
  invitationExpiresAt?: Date;
}
// End of shared model definition

export interface IUserRepository {
  /**
   * Finds a user by their unique ID (Firebase Auth UID).
   * @param userId The ID of the user.
   * @returns A Promise that resolves with the User object or null if not found.
   */
  findById(userId: string): Promise<User | null>;

  /**
   * Finds a user by their email address within a specific tenant.
   * @param email The user's email address.
   * @param tenantId The ID of the tenant to search within.
   * @returns A Promise that resolves with the User object or null if not found.
   */
  findByEmailInTenant(email: string, tenantId: string): Promise<User | null>;

  /**
   * Finds a user by their unique invitation token.
   * @param token The invitation token.
   * @returns A Promise that resolves with the User object or null if not found.
   */
  findByInvitationToken(token: string): Promise<User | null>;

  /**
   * Finds all active subordinates for a given supervisor.
   * @param supervisorId The ID of the supervisor.
   * @returns A Promise that resolves with an array of active subordinate User objects.
   * @see REQ-1-029
   */
  findActiveSubordinates(supervisorId: string): Promise<User[]>;

  /**
   * Persists a new user to the data store.
   * @param user The User object to create.
   * @returns A Promise that resolves when the creation is complete.
   */
  create(user: User): Promise<void>;

  /**
   * Updates an existing user in the data store.
   * @param userId The ID of the user to update.
   * @param data The partial data to update.
   * @returns A Promise that resolves when the update is complete.
   */
  update(userId: string, data: Partial<Omit<User, 'userId'>>): Promise<void>;

  /**
   * Finds all users with a 'deactivated' status older than the retention period.
   * @param retentionPeriodInDays The number of days after which a deactivated user is eligible for anonymization.
   * @returns A Promise that resolves with an array of User objects to be anonymized.
   * @see REQ-1-074
   */
  findForAnonymization(retentionPeriodInDays: number): Promise<User[]>;

  /**
   * Deletes all users belonging to a specific tenant.
   * Used during the tenant deletion process.
   * @param tenantId The ID of the tenant whose users should be deleted.
   * @returns A Promise that resolves with the number of users deleted.
   */
  deleteByTenantId(tenantId: string): Promise<number>;
}