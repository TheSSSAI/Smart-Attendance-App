import { IUserRepository } from "../repositories/IUserRepository";
import { User } from "../entities/User"; // Assuming User entity is defined at level 0

/**
 * @class HierarchyValidationService
 * @description A domain service responsible for validating the integrity of the organizational hierarchy.
 * It encapsulates the business rule to prevent circular reporting dependencies.
 * REQ-1-026
 */
export class HierarchyValidationService {
  private static readonly MAX_HIERARCHY_DEPTH = 20;

  /**
   * @constructor
   * @param {IUserRepository} userRepository - The repository for accessing user data.
   */
  constructor(private readonly userRepository: IUserRepository) {
    if (!userRepository) {
      throw new Error("HierarchyValidationService requires a non-null userRepository.");
    }
  }

  /**
   * Checks if assigning a new supervisor to a user would create a circular dependency.
   * A circular dependency occurs if the proposed new supervisor is the user themselves,
   * or if the new supervisor already exists in the user's reporting line (is a subordinate).
   * 
   * @param {string} userId - The ID of the user whose supervisor is being changed.
   * @param {string | null} newSupervisorId - The ID of the proposed new supervisor. Can be null if removing a supervisor.
   * @param {string} tenantId - The ID of the tenant where the operation is taking place.
   * @returns {Promise<boolean>} - True if a circular dependency is detected, otherwise false.
   * @throws {Error} if the hierarchy depth exceeds the defined maximum, indicating malformed data.
   */
  public async isCircularDependency(
    userId: string,
    newSupervisorId: string | null,
    tenantId: string,
  ): Promise<boolean> {
    // A user cannot be their own supervisor.
    if (userId === newSupervisorId) {
      return true;
    }

    // If the new supervisor is null, no circular dependency is possible.
    if (!newSupervisorId) {
      return false;
    }

    let currentSupervisorId: string | null = newSupervisorId;
    let depth = 0;

    // Iteratively traverse up the reporting chain from the new supervisor.
    while (currentSupervisorId) {
      // Safety check to prevent infinite loops from malformed data.
      if (depth >= HierarchyValidationService.MAX_HIERARCHY_DEPTH) {
        throw new Error(
          `Hierarchy depth limit of ${HierarchyValidationService.MAX_HIERARCHY_DEPTH} exceeded during circular dependency check. Potential data corruption.`
        );
      }

      // If we find the original user in the new supervisor's reporting chain, it's a circular dependency.
      if (currentSupervisorId === userId) {
        return true;
      }

      const supervisor: User | null = await this.userRepository.findById(currentSupervisorId, tenantId);

      // If the chain is broken or we've reached the top, no circular dependency exists.
      if (!supervisor) {
        return false;
      }

      currentSupervisorId = supervisor.supervisorId;
      depth++;
    }

    // Reached the top of the hierarchy without finding the user.
    return false;
  }
}