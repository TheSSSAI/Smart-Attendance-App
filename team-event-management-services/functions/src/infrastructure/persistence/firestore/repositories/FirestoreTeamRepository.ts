import { ITeamRepository } from "@/domain/repositories/ITeamRepository";
import { Team } from "@/domain/entities/Team";
import { User } from "@/domain/entities/User";
import { TeamMapper } from "@/infrastructure/persistence/firestore/mappers/TeamMapper";
import * as admin from "firebase-admin";
import { injectable } from "inversify";
import "reflect-metadata";

@injectable()
export class FirestoreTeamRepository implements ITeamRepository {
  private readonly _firestore: admin.firestore.Firestore;
  private readonly _collectionName = "teams";
  private readonly _tenantsCollectionName = "tenants";

  public constructor() {
    this._firestore = admin.firestore();
  }

  /**
   * Retrieves a team by its ID within a specific tenant.
   * @param teamId The unique ID of the team.
   * @param tenantId The tenant context for the query.
   * @returns A Team entity or null if not found.
   */
  async findById(teamId: string, tenantId: string): Promise<Team | null> {
    const docRef = this._firestore
      .collection(this._tenantsCollectionName)
      .doc(tenantId)
      .collection(this._collectionName)
      .doc(teamId);

    const docSnap = await docRef.get();

    if (!docSnap.exists) {
      return null;
    }

    return TeamMapper.toDomain(docSnap);
  }

  /**
   * Retrieves a team by its name within a specific tenant for uniqueness checks.
   * The check is case-insensitive.
   * @param name The name of the team to find.
   * @param tenantId The tenant context for the query.
   * @returns A Team entity or null if not found.
   */
  async findByName(name: string, tenantId: string): Promise<Team | null> {
    const normalizedName = name.toLowerCase();
    const querySnapshot = await this._firestore
      .collection(this._tenantsCollectionName)
      .doc(tenantId)
      .collection(this._collectionName)
      .where("normalizedName", "==", normalizedName)
      .limit(1)
      .get();

    if (querySnapshot.empty) {
      return null;
    }

    const docSnap = querySnapshot.docs[0];
    return TeamMapper.toDomain(docSnap);
  }

  /**
   * Finds all teams supervised by a specific user within a tenant.
   * @param supervisorId The ID of the supervisor.
   * @param tenantId The tenant context for the query.
   * @returns An array of Team entities.
   */
  async findBySupervisorId(
    supervisorId: string,
    tenantId: string
  ): Promise<Team[]> {
    const querySnapshot = await this._firestore
      .collection(this._tenantsCollectionName)
      .doc(tenantId)
      .collection(this._collectionName)
      .where("supervisorId", "==", supervisorId)
      .get();

    if (querySnapshot.empty) {
      return [];
    }

    return querySnapshot.docs.map((doc) => TeamMapper.toDomain(doc));
  }

  /**
   * Adds a save (create or update) operation for a Team entity to a Firestore WriteBatch.
   * This method does not commit the batch.
   * @param team The Team entity to save.
   * @param batch The Firestore WriteBatch to add the operation to.
   */
  save(team: Team, batch: admin.firestore.WriteBatch): void {
    const docRef = this._firestore
      .collection(this._tenantsCollectionName)
      .doc(team.tenantId)
      .collection(this._collectionName)
      .doc(team.id);

    const persistenceModel = TeamMapper.toPersistence(team);
    batch.set(docRef, persistenceModel, { merge: true });
  }

  /**
   * Adds a delete operation for a team to a Firestore WriteBatch.
   * This method does not commit the batch.
   * @param teamId The ID of the team to delete.
   * @param tenantId The tenant context for the operation.
   * @param batch The Firestore WriteBatch to add the operation to.
   */
  delete(
    teamId: string,
    tenantId: string,
    batch: admin.firestore.WriteBatch
  ): void {
    const docRef = this._firestore
      .collection(this._tenantsCollectionName)
      .doc(tenantId)
      .collection(this._collectionName)
      .doc(teamId);
    batch.delete(docRef);
  }

  /**
   * Manages team membership by atomically updating both the team and user documents.
   * This uses a transaction to ensure data consistency.
   * @param teamId The ID of the team to modify.
   * @param userId The ID of the user to add or remove.
   * @param tenantId The tenant context for the operation.
   * @param action The action to perform ('add' or 'remove').
   */
  async manageMembership(
    teamId: string,
    userId: string,
    tenantId: string,
    action: "add" | "remove"
  ): Promise<void> {
    const teamDocRef = this._firestore
      .collection(this._tenantsCollectionName)
      .doc(tenantId)
      .collection(this._collectionName)
      .doc(teamId);
    const userDocRef = this._firestore
      .collection(this._tenantsCollectionName)
      .doc(tenantId)
      .collection("users")
      .doc(userId);

    await this._firestore.runTransaction(async (transaction) => {
      const teamDoc = await transaction.get(teamDocRef);
      const userDoc = await transaction.get(userDocRef);

      if (!teamDoc.exists) {
        throw new Error(`Team with ID ${teamId} not found.`);
      }
      if (!userDoc.exists) {
        throw new Error(`User with ID ${userId} not found.`);
      }

      const teamData = teamDoc.data() as admin.firestore.DocumentData;
      const memberIds: string[] = teamData.memberIds || [];
      const userData = userDoc.data() as admin.firestore.DocumentData;
      const teamIds: string[] = userData.teamIds || [];

      if (action === "add") {
        // Add member to team if not already present
        if (!memberIds.includes(userId)) {
          transaction.update(teamDocRef, {
            memberIds: admin.firestore.FieldValue.arrayUnion(userId),
          });
        }
        // Add team to user if not already present
        if (!teamIds.includes(teamId)) {
          transaction.update(userDocRef, {
            teamIds: admin.firestore.FieldValue.arrayUnion(teamId),
          });
        }
      } else if (action === "remove") {
        // Remove member from team if present
        if (memberIds.includes(userId)) {
          transaction.update(teamDocRef, {
            memberIds: admin.firestore.FieldValue.arrayRemove(userId),
          });
        }
        // Remove team from user if present
        if (teamIds.includes(teamId)) {
          transaction.update(userDocRef, {
            teamIds: admin.firestore.FieldValue.arrayRemove(teamId),
          });
        }
      }
    });
  }
}