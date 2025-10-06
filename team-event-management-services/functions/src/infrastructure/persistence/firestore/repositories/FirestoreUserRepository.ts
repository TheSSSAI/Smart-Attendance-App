import { IUserRepository } from "@/domain/repositories/IUserRepository";
import { User } from "@/domain/entities/User";
import * as admin from "firebase-admin";
import { injectable } from "inversify";
import "reflect-metadata";

// Basic mapper for User entity. In a more complex scenario, this would be in its own file.
class UserMapper {
  static toDomain(
    snapshot: admin.firestore.DocumentSnapshot
  ): User {
    const data = snapshot.data();
    if (!data) {
      throw new Error("Document data is missing");
    }
    return new User(
      snapshot.id,
      data.tenantId,
      data.email,
      data.role,
      data.status,
      data.name,
      data.supervisorId,
      data.teamIds,
      data.fcmTokens
    );
  }
}

@injectable()
export class FirestoreUserRepository implements IUserRepository {
  private readonly _firestore: admin.firestore.Firestore;
  private readonly _collectionName = "users";
  private readonly _tenantsCollectionName = "tenants";
  private readonly MAX_HIERARCHY_DEPTH = 15;

  public constructor() {
    this._firestore = admin.firestore();
  }

  /**
   * Retrieves a user by their ID within a specific tenant.
   * @param userId The unique ID of the user.
   * @param tenantId The tenant context for the query.
   * @returns A User entity or null if not found.
   */
  async findById(userId: string, tenantId: string): Promise<User | null> {
    const docRef = this._firestore
      .collection(this._tenantsCollectionName)
      .doc(tenantId)
      .collection(this._collectionName)
      .doc(userId);
    const docSnap = await docRef.get();

    if (!docSnap.exists) {
      return null;
    }
    return UserMapper.toDomain(docSnap);
  }

  /**
   * Retrieves multiple users by their IDs within a specific tenant.
   * @param userIds An array of user IDs to retrieve.
   * @param tenantId The tenant context for the query.
   * @returns An array of User entities.
   */
  async findByIds(userIds: string[], tenantId: string): Promise<User[]> {
    if (userIds.length === 0) {
      return [];
    }
    const collectionRef = this._firestore
      .collection(this._tenantsCollectionName)
      .doc(tenantId)
      .collection(this._collectionName);

    // Firestore `in` query is limited to 30 items
    const chunks = [];
    for (let i = 0; i < userIds.length; i += 30) {
      chunks.push(userIds.slice(i, i + 30));
    }

    const promises = chunks.map((chunk) =>
      collectionRef.where(admin.firestore.FieldPath.documentId(), "in", chunk).get()
    );

    const snapshotChunks = await Promise.all(promises);
    
    const users: User[] = [];
    snapshotChunks.forEach(snapshotChunk => {
        snapshotChunk.docs.forEach(doc => {
            users.push(UserMapper.toDomain(doc));
        })
    });
    
    return users;
  }

  /**
   * Retrieves a user by their email within a specific tenant.
   * @param email The email of the user.
   * @param tenantId The tenant context for the query.
   * @returns A User entity or null if not found.
   */
  async findByEmail(email: string, tenantId: string): Promise<User | null> {
    const querySnapshot = await this._firestore
      .collection(this._tenantsCollectionName)
      .doc(tenantId)
      .collection(this._collectionName)
      .where("email", "==", email)
      .limit(1)
      .get();
    
    if (querySnapshot.empty) {
        return null;
    }

    return UserMapper.toDomain(querySnapshot.docs[0]);
  }

  /**
   * Traverses the supervisor chain for a given user to detect circular dependencies.
   * @param startingUserId The ID of the user from whom to start the traversal upwards.
   * @param tenantId The tenant context for the query.
   * @returns An array of supervisor IDs in the chain.
   */
  async getSupervisorChain(
    startingUserId: string,
    tenantId: string
  ): Promise<string[]> {
    const chain: string[] = [];
    let currentUserId: string | null = startingUserId;
    let depth = 0;

    while (currentUserId && depth < this.MAX_HIERARCHY_DEPTH) {
      chain.push(currentUserId);
      const user = await this.findById(currentUserId, tenantId);
      if (!user || !user.supervisorId) {
        break;
      }
      currentUserId = user.supervisorId;
      depth++;
    }

    return chain;
  }

  /**
   * Adds a save operation for a User entity to a Firestore WriteBatch.
   * @param user The User entity to save.
   * @param batch The Firestore WriteBatch to add the operation to.
   */
  save(user: User, batch: admin.firestore.WriteBatch): void {
    const docRef = this._firestore
      .collection(this._tenantsCollectionName)
      .doc(user.tenantId)
      .collection(this._collectionName)
      .doc(user.id);
    // Mapper would be more robust here, but for simplicity:
    const data = {
        tenantId: user.tenantId,
        email: user.email,
        role: user.role,
        status: user.status,
        name: user.name,
        supervisorId: user.supervisorId || null,
        teamIds: user.teamIds || [],
        fcmTokens: user.fcmTokens || [],
    }
    batch.set(docRef, data, {merge: true});
  }
}