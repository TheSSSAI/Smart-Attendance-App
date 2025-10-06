import * as admin from "firebase-admin";
import { ITenantRepository } from "../../domain/interfaces/ITenantRepository";
import { Tenant } from "../../domain/entities/Tenant";
import { injectable } from "tsyringe";
import { AppError } from "../../domain/errors/AppError";
import { ErrorCode } from "../../domain/errors/ErrorCode";

@injectable()
export class FirestoreTenantRepository implements ITenantRepository {
  private readonly db: admin.firestore.Firestore;
  private readonly tenantsCollection = "tenants";

  constructor() {
    if (!admin.apps.length) {
      admin.initializeApp();
    }
    this.db = admin.firestore();
  }

  /**
   * Converts a Firestore document snapshot into a Tenant domain entity.
   * @param doc The Firestore document snapshot.
   * @returns A Tenant entity or null if the document is invalid.
   */
  private docToTenant(doc: admin.firestore.DocumentSnapshot): Tenant | null {
    if (!doc.exists) {
      return null;
    }
    const data = doc.data() as any; // Allow any for flexible mapping
    return {
      id: doc.id,
      name: data.name,
      status: data.status,
      subscriptionPlanId: data.subscriptionPlanId,
      createdAt: data.createdAt?.toDate(),
      updatedAt: data.updatedAt?.toDate(),
      deletionScheduledAt: data.deletionScheduledAt?.toDate(),
      normalizedName: data.normalizedName,
    };
  }

  /**
   * Finds a tenant by its unique ID.
   * @param id The tenant's ID.
   * @returns A promise resolving to the Tenant entity or null if not found.
   */
  async findById(id: string): Promise<Tenant | null> {
    try {
      const doc = await this.db.collection(this.tenantsCollection).doc(id).get();
      return this.docToTenant(doc);
    } catch (error) {
      throw new AppError(ErrorCode.DatabaseError, "Failed to find tenant by ID.", error);
    }
  }

  /**
   * Finds a tenant by its name (case-insensitive).
   * Relies on a 'normalizedName' field for efficient querying.
   * @param name The organization name to search for.
   * @returns A promise resolving to the Tenant entity or null if not found.
   */
  async findByName(name: string): Promise<Tenant | null> {
    const normalizedName = name.toLowerCase();
    try {
      const snapshot = await this.db.collection(this.tenantsCollection).where("normalizedName", "==", normalizedName).limit(1).get();
      if (snapshot.empty) {
        return null;
      }
      return this.docToTenant(snapshot.docs[0]);
    } catch (error) {
      throw new AppError(ErrorCode.DatabaseError, "Failed to find tenant by name.", error);
    }
  }

  /**
   * Creates a new tenant document in Firestore.
   * @param tenant The Tenant entity to create.
   * @returns A promise that resolves on successful creation.
   */
  async create(tenant: Tenant): Promise<void> {
    const { id, ...data } = tenant;
    const now = admin.firestore.FieldValue.serverTimestamp();
    const docData = {
      ...data,
      normalizedName: tenant.name.toLowerCase(),
      createdAt: now,
      updatedAt: now,
    };
    try {
      await this.db.collection(this.tenantsCollection).doc(id).set(docData);
    } catch (error) {
      throw new AppError(ErrorCode.DatabaseError, "Failed to create tenant.", error);
    }
  }

  /**
   * Updates an existing tenant document.
   * @param id The ID of the tenant to update.
   * @param data A partial object of the tenant's data to update.
   * @returns A promise that resolves on successful update.
   */
  async update(id: string, data: Partial<Omit<Tenant, "id">>): Promise<void> {
    const docRef = this.db.collection(this.tenantsCollection).doc(id);
    const updateData: { [key: string]: any } = {
      ...data,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    // Ensure normalizedName is updated if name is changed
    if (data.name) {
      updateData.normalizedName = data.name.toLowerCase();
    }
    try {
      await docRef.update(updateData);
    } catch (error: any) {
      if (error.code === "not-found") {
        throw new AppError(ErrorCode.TenantNotFound, `Tenant with ID ${id} not found for update.`);
      }
      throw new AppError(ErrorCode.DatabaseError, "Failed to update tenant.", error);
    }
  }

  /**
   * Retrieves all tenants that are pending deletion and whose grace period has expired.
   * @returns A promise resolving to an array of Tenant entities.
   */
  async findTenantsForDeletion(): Promise<Tenant[]> {
    try {
      const now = new Date();
      const snapshot = await this.db.collection(this.tenantsCollection)
        .where("status", "==", "pending_deletion")
        .where("deletionScheduledAt", "<=", now)
        .get();

      if (snapshot.empty) {
        return [];
      }

      return snapshot.docs.map((doc) => this.docToTenant(doc)).filter((t): t is Tenant => t !== null);
    } catch (error) {
      throw new AppError(ErrorCode.DatabaseError, "Failed to find tenants for deletion.", error);
    }
  }

  /**
   * Permanently deletes a tenant and all its associated data.
   * This is a placeholder for a more complex cascading delete operation.
   * The actual implementation would involve a batched delete across multiple collections.
   * @param id The ID of the tenant to delete.
   * @returns A promise that resolves on successful deletion.
   */
  async delete(id: string): Promise<void> {
    // NOTE: A true cascading delete is complex and must be handled carefully,
    // often with a dedicated Cloud Function that uses batched writes.
    // This is a simplified version for the repository interface.
    try {
      // In a real scenario, you'd trigger a function to delete sub-collections like users, teams, etc.
      // For example: await deleteCollection(this.db, `tenants/${id}/users`, 100);
      await this.db.collection(this.tenantsCollection).doc(id).delete();
    } catch (error) {
      throw new AppError(ErrorCode.DatabaseError, `Failed to delete tenant with ID ${id}.`, error);
    }
  }
}