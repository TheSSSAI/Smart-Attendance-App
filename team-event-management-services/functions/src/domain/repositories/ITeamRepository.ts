import { Team } from "../entities/Team";
import { WriteBatch } from "firebase-admin/firestore";

/**
 * Interface for the Team repository.
 * Defines the contract for data access operations related to the Team aggregate.
 * This abstraction decouples the domain and application layers from the specific
 * persistence mechanism (e.g., Firestore).
 */
export interface ITeamRepository {
  /**
   * Finds a Team by its unique identifier within a specific tenant.
   * @param teamId - The unique identifier of the team.
   * @param tenantId - The identifier of the tenant to which the team belongs.
   * @returns A Promise that resolves to the Team entity if found, otherwise null.
   */
  findById(teamId: string, tenantId: string): Promise<Team | null>;

  /**
   * Finds a Team by its name within a specific tenant. This is crucial for
   * enforcing name uniqueness. The search should be case-insensitive.
   * @param name - The name of the team to find.
   * @param tenantId - The identifier of the tenant to which the team belongs.
   * @returns A Promise that resolves to the Team entity if a team with that name exists, otherwise null.
   */
  findByName(name: string, tenantId: string): Promise<Team | null>;

  /**
   * Retrieves all teams managed by a specific supervisor within a tenant.
   * @param supervisorId - The unique identifier of the supervisor.
   * @param tenantId - The identifier of the tenant.
   * @returns A Promise that resolves to an array of Team entities.
   */
  findAllBySupervisorId(supervisorId: string, tenantId: string): Promise<Team[]>;

  /**
   * Saves a Team entity (creates a new one or updates an existing one).
   * This operation should be part of a larger transaction controlled by a WriteBatch.
   * @param team - The Team entity to save.
   * @param batch - The Firestore WriteBatch to add this operation to. If not provided,
   * a new batch might be created and committed immediately by the implementation,
   * but the standard pattern is to use a provided batch for transactional integrity.
   * @returns A Promise that resolves when the save operation is added to the batch.
   */
  save(team: Team, batch?: WriteBatch): Promise<void>;

  /**
   * Deletes a Team by its unique identifier.
   * This operation should be part of a larger transaction controlled by a WriteBatch.
   * @param teamId - The unique identifier of the team to delete.
   * @param tenantId - The identifier of the tenant to which the team belongs.
   * @param batch - The Firestore WriteBatch to add this operation to.
   * @returns A Promise that resolves when the delete operation is added to the batch.
   */
  delete(teamId: string, tenantId: string, batch?: WriteBatch): Promise<void>;

  /**
   * Adds a user to a team's member list.
   * Implementations should ensure this is an atomic operation.
   * @param teamId The ID of the team.
   * @param userId The ID of the user to add.
   * @param tenantId The ID of the tenant.
   * @param batch The Firestore WriteBatch for transactional consistency.
   * @returns A promise that resolves on completion.
   */
  addMember(teamId: string, userId: string, tenantId: string, batch?: WriteBatch): Promise<void>;

  /**
   * Removes a user from a team's member list.
   * Implementations should ensure this is an atomic operation.
   * @param teamId The ID of the team.
   * @param userId The ID of the user to remove.
   * @param tenantId The ID of the tenant.
   * @param batch The Firestore WriteBatch for transactional consistency.
   * @returns A promise that resolves on completion.
   */
  removeMember(teamId: string, userId: string, tenantId: string, batch?: WriteBatch): Promise<void>;
}