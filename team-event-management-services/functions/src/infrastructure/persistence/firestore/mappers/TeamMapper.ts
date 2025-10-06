import { Team } from "../../../../domain/entities/Team";
import * as admin from "firebase-admin";

type TeamDocumentData = admin.firestore.DocumentData;

/**
 * @class TeamMapper
 * @description A static class responsible for mapping between the Team domain entity and its Firestore document representation.
 * This isolates the domain model from the persistence model.
 */
export class TeamMapper {
  /**
   * Maps a Firestore document to a Team domain entity.
   * @param {string} id - The document ID from Firestore.
   * @param {TeamDocumentData} data - The document data from Firestore.
   * @returns {Team} A Team domain entity instance.
   */
  public static toDomain(id: string, data: TeamDocumentData): Team {
    // Defensive programming: ensure required fields exist and have correct types.
    if (!data.name || typeof data.name !== "string") {
      throw new Error(`Team document ${id} is missing a valid 'name' field.`);
    }
    if (!data.supervisorId || typeof data.supervisorId !== "string") {
      throw new Error(`Team document ${id} is missing a valid 'supervisorId' field.`);
    }

    // Default memberIds to an empty array if not present or not an array.
    const memberIds = Array.isArray(data.memberIds) ? data.memberIds : [];

    // The domain entity's constructor is the source of truth for validation and creation.
    const team = new Team({
      id,
      name: data.name,
      supervisorId: data.supervisorId,
      memberIds,
    });

    return team;
  }

  /**
   * Maps a Team domain entity to a plain object for Firestore persistence.
   * The 'id' property is excluded as it's the document key in Firestore.
   * @param {Team} team - The Team domain entity instance.
   * @returns {Omit<Team, 'id'>} A plain object suitable for writing to Firestore.
   */
  public static toPersistence(team: Team): {
    name: string;
    supervisorId: string;
    memberIds: string[];
    } {
    return {
      name: team.name,
      supervisorId: team.supervisorId,
      memberIds: team.memberIds,
    };
  }
}