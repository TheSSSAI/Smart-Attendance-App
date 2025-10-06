import { Firestore, Timestamp } from "firebase-admin/firestore";
import { ITenantConfigRepository } from "../../../domain/attendance/repositories/ITenantConfigRepository";
import { TenantConfiguration } from "../../../domain/tenants/entities/TenantConfiguration";
import { DataPersistenceError } from "../../../domain/common/errors/DataPersistenceError";

type TenantDocument = {
  name: string;
  status: string;
  subscriptionPlanId: string;
  config?: {
    timezone?: string;
    autoCheckoutEnabled?: boolean;
    autoCheckoutTime?: string; // "HH:mm"
    approvalEscalationDays?: number;
  };
};

export class FirestoreTenantConfigRepository implements ITenantConfigRepository {
  private static readonly COLLECTION_NAME = "tenants";

  constructor(private readonly db: Firestore) {}

  /**
   * Finds a tenant's configuration by its ID.
   * @param tenantId - The ID of the tenant.
   * @returns The TenantConfiguration entity or null if not found.
   */
  async findById(tenantId: string): Promise<TenantConfiguration | null> {
    try {
      const docRef = this.db
        .collection(FirestoreTenantConfigRepository.COLLECTION_NAME)
        .doc(tenantId);

      const snapshot = await docRef.get();

      if (!snapshot.exists) {
        return null;
      }

      return this.toDomain(snapshot.id, snapshot.data() as TenantDocument);
    } catch (error) {
      console.error(
        `Error fetching tenant configuration by ID: ${tenantId}`,
        error,
      );
      throw new DataPersistenceError(
        "Failed to fetch tenant configuration from Firestore.",
      );
    }
  }

  /**
   * Finds all tenant configurations where the auto-checkout feature is enabled.
   * Required for REQ-1-045 (Auto-Checkout).
   * @returns An array of TenantConfiguration entities.
   */
  async findAllWithAutoCheckoutEnabled(): Promise<TenantConfiguration[]> {
    try {
      const querySnapshot = await this.db
        .collection(FirestoreTenantConfigRepository.COLLECTION_NAME)
        .where("config.autoCheckoutEnabled", "==", true)
        .get();

      if (querySnapshot.empty) {
        return [];
      }

      return querySnapshot.docs.map((doc) =>
        this.toDomain(doc.id, doc.data() as TenantDocument),
      );
    } catch (error) {
      console.error(
        "Error fetching tenants with auto-checkout enabled",
        error,
      );
      throw new DataPersistenceError(
        "Failed to fetch tenant configurations.",
      );
    }
  }

  /**
   * Maps a Firestore tenant document to a TenantConfiguration domain entity.
   * @param id - The tenant ID.
   * @param data - The Firestore document data.
   * @returns A TenantConfiguration entity.
   */
  private toDomain(id: string, data: TenantDocument): TenantConfiguration {
    // Provide default values for configurations that may not be set.
    return new TenantConfiguration({
      tenantId: id,
      timezone: data.config?.timezone ?? "UTC",
      autoCheckoutEnabled: data.config?.autoCheckoutEnabled ?? false,
      autoCheckoutTime: data.config?.autoCheckoutTime ?? "17:00",
      approvalEscalationDays: data.config?.approvalEscalationDays,
    });
  }
}