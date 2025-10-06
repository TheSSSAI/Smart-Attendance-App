import * as admin from "firebase-admin";
import { IUserRepository } from "../../domain/interfaces/IUserRepository";
import { User } from "../../domain/entities/User";
import { injectable } from "tsyringe";
import { AppError } from "../../domain/errors/AppError";
import { ErrorCode } from "../../domain/errors/ErrorCode";

@injectable()
export class FirestoreUserRepository implements IUserRepository {
  private readonly db: admin.firestore.Firestore;
  private readonly usersCollection = "users";
  private static readonly MAX_HIERARCHY_DEPTH = 20; // Safety limit

  constructor() {
    if (!admin.apps.length) {
      admin.initializeApp();
    }
    this.db = admin.firestore();
  }

  /**
   * Converts a Firestore document snapshot into a User domain entity.
   * @param doc The Firestore document snapshot.
   * @returns A User entity or null if the document is invalid.
   */
  private docToUser(doc: admin.firestore.DocumentSnapshot): User | null {
    if (!doc.exists) {
      return null;
    }
    const data = doc.data() as any;
    return {
      id: doc.id,
      tenantId: data.tenantId,
      email: data.email,
      name: data.name,
      role: data.role,
      status: data.status,
      supervisorId: data.supervisorId || null,
      teamIds: data.teamIds || [],
      createdAt: data.createdAt?.toDate(),
      updatedAt: data.updatedAt?.toDate(),
      invitationToken: data.invitationToken || null,
      deactivatedAt: data.deactivatedAt?.toDate(),
    };
  }

  /**
   * Finds a user by their unique ID (which is also their Firebase Auth UID).
   * @param id The user's ID.
   * @returns A promise resolving to the User entity or null if not found.
   */
  async findById(id: string): Promise<User | null> {
    try {
      const doc = await this.db.collection(this.usersCollection).doc(id).get();
      return this.docToUser(doc);
    } catch (error) {
      throw new AppError(ErrorCode.DatabaseError, "Failed to find user by ID.", error);
    }
  }

  /**
   * Finds a user by their email within a specific tenant.
   * This is crucial for enforcing email uniqueness per tenant.
   * @param email The user's email.
   * @param tenantId The tenant's ID.
   * @returns A promise resolving to the User entity or null if not found.
   */
  async findByEmailInTenant(email: string, tenantId: string): Promise<User | null> {
    try {
      const snapshot = await this.db.collection(this.usersCollection)
        .where("email", "==", email)
        .where("tenantId", "==", tenantId)
        .limit(1)
        .get();

      if (snapshot.empty) {
        return null;
      }
      return this.docToUser(snapshot.docs[0]);
    } catch (error) {
      throw new AppError(ErrorCode.DatabaseError, "Failed to find user by email in tenant.", error);
    }
  }

  /**
   * Finds all active subordinates for a given supervisor within a tenant.
   * @param supervisorId The supervisor's user ID.
   * @param tenantId The tenant's ID.
   * @returns A promise resolving to an array of User entities.
   */
  async findActiveSubordinates(supervisorId: string, tenantId: string): Promise<User[]> {
    try {
      const snapshot = await this.db.collection(this.usersCollection)
        .where("supervisorId", "==", supervisorId)
        .where("tenantId", "==", tenantId)
        .where("status", "==", "active")
        .get();

      if (snapshot.empty) {
        return [];
      }

      return snapshot.docs.map((doc) => this.docToUser(doc)).filter((u): u is User => u !== null);
    } catch (error) {
      throw new AppError(ErrorCode.DatabaseError, "Failed to find active subordinates.", error);
    }
  }

  /**
   * Finds a user by their invitation token.
   * @param token The invitation token.
   * @returns A promise resolving to the User entity or null if not found.
   */
  async findByInvitationToken(token: string): Promise<User | null> {
    try {
      const snapshot = await this.db.collection(this.usersCollection)
        .where("invitationToken.token", "==", token)
        .limit(1)
        .get();

      if (snapshot.empty) {
        return null;
      }
      return this.docToUser(snapshot.docs[0]);
    } catch (error) {
      throw new AppError(ErrorCode.DatabaseError, "Failed to find user by invitation token.", error);
    }
  }

  /**
   * Creates a new user document in Firestore.
   * @param user The User entity to create.
   * @returns A promise that resolves on successful creation.
   */
  async create(user: User): Promise<void> {
    const { id, ...data } = user;
    const now = admin.firestore.FieldValue.serverTimestamp();
    try {
      await this.db.collection(this.usersCollection).doc(id).set({
        ...data,
        createdAt: now,
        updatedAt: now,
      });
    } catch (error) {
      throw new AppError(ErrorCode.DatabaseError, "Failed to create user.", error);
    }
  }

  /**
   * Updates an existing user document.
   * @param id The ID of the user to update.
   * @param data A partial object of the user's data to update.
   * @returns A promise that resolves on successful update.
   */
  async update(id: string, data: Partial<Omit<User, "id">>): Promise<void> {
    const docRef = this.db.collection(this.usersCollection).doc(id);
    try {
      await docRef.update({
        ...data,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (error: any) {
      if (error.code === "not-found") {
        throw new AppError(ErrorCode.UserNotFound, `User with ID ${id} not found for update.`);
      }
      throw new AppError(ErrorCode.DatabaseError, "Failed to update user.", error);
    }
  }

  /**
   * Traverses the supervisor hierarchy upwards from a given user ID to detect circular dependencies.
   * @param startingUserId The user ID from which to start traversing up.
   * @param targetId The user ID we are looking for in the hierarchy chain.
   * @returns A promise resolving to true if a circular dependency is detected, false otherwise.
   */
  async hierarchyContains(startingUserId: string, targetId: string): Promise<boolean> {
    let currentUserId: string | null = startingUserId;
    let depth = 0;

    while (currentUserId && depth < FirestoreUserRepository.MAX_HIERARCHY_DEPTH) {
      if (currentUserId === targetId) {
        return true; // Circular dependency found
      }

      try {
        const currentUser = await this.findById(currentUserId);
        currentUserId = currentUser?.supervisorId || null;
        depth++;
      } catch (error) {
        throw new AppError(ErrorCode.DatabaseError, "Failed during hierarchy traversal.", error);
      }
    }

    if (depth >= FirestoreUserRepository.MAX_HIERARCHY_DEPTH) {
      throw new AppError(ErrorCode.HierarchyTooDeep, "Maximum hierarchy depth reached during validation. Please check for misconfigurations.");
    }

    return false;
  }

  /**
   * Finds all deactivated users eligible for anonymization.
   * @param retentionDays The number of days a user must be deactivated before anonymization.
   * @returns A promise resolving to an array of User entities.
   */
  async findDeactivatedForAnonymization(retentionDays: number): Promise<User[]> {
    try {
      const now = new Date();
      const retentionDate = new Date(now.setDate(now.getDate() - retentionDays));

      const snapshot = await this.db.collection(this.usersCollection)
        .where("status", "==", "deactivated")
        .where("deactivatedAt", "<=", retentionDate)
        .get();

      if (snapshot.empty) {
        return [];
      }

      return snapshot.docs.map((doc) => this.docToUser(doc)).filter((u): u is User => u !== null);
    } catch (error) {
      throw new AppError(ErrorCode.DatabaseError, "Failed to find deactivated users for anonymization.", error);
    }
  }

  /**
   * Retrieves all users within a given tenant. Used for cascading deletes.
   * @param tenantId The ID of the tenant.
   * @returns A promise resolving to an array of User entities.
   */
  async findByTenantId(tenantId: string): Promise<User[]> {
    try {
      const snapshot = await this.db.collection(this.usersCollection)
        .where("tenantId", "==", tenantId)
        .get();

      if (snapshot.empty) {
        return [];
      }
      return snapshot.docs.map((doc) => this.docToUser(doc)).filter((u): u is User => u !== null);
    } catch (error) {
      throw new AppError(ErrorCode.DatabaseError, "Failed to find users by tenant ID.", error);
    }
  }
}