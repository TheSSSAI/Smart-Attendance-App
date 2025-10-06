import { User } from "../entities/User";
import { WriteBatch } from "firebase-admin/firestore";

/**
 * Interface for the User repository.
 * Defines a contract for accessing User data. As the User entity is owned by the
 * Identity service, this repository primarily provides read-access and limited, specific
 * write-access for fields managed by this bounded context (e.g., team memberships).
 */
export interface IUserRepository {
  /**
   * Finds a User by their unique identifier within a specific tenant.
   * @param userId - The unique identifier of the user (typically Firebase Auth UID).
   * @param tenantId - The identifier of the tenant to which the user belongs.
   * @returns A Promise that resolves to the User entity if found, otherwise null.
   */
  findById(userId: string, tenantId: string): Promise<User | null>;

  /**
   * Finds multiple Users by their unique identifiers within a specific tenant.
   * This is optimized for fetching details for a list of users, such as all members of a team.
   * @param userIds - An array of user identifiers to fetch.
   * @param tenantId - The identifier of the tenant.
   * @returns A Promise that resolves to an array of found User entities. Users not found are omitted.
   */
  findByIds(userIds: string[], tenantId: string): Promise<User[]>;

  /**
   * Retrieves all users who are direct subordinates of a given supervisor.
   * @param supervisorId - The ID of the supervisor.
   * @param tenantId - The ID of the tenant.
   * @returns A promise that resolves to an array of subordinate User entities.
   */
  findAllSubordinates(supervisorId: string, tenantId: string): Promise<User[]>;

  /**
   * Saves changes to a User entity. This method's use is restricted to fields
   * that this service is responsible for, such as `teamIds`.
   * The operation should be part of a larger transaction controlled by a WriteBatch.
   * @param user - The User entity with updated information.
   * @param batch - The Firestore WriteBatch to add this operation to for transactional consistency.
   * @returns A Promise that resolves when the save operation is added to the batch.
   */
  save(user: User, batch?: WriteBatch): Promise<void>;

  /**
   * Finds all users within a tenant that are eligible to be assigned as a supervisor.
   * Typically, these are users with the 'Admin' or 'Supervisor' role.
   * @param tenantId The identifier of the tenant.
   * @returns A Promise that resolves to an array of eligible User entities.
   */
  findSupervisorCandidates(tenantId: string): Promise<User[]>;
}