import { IAuditLogService } from "@/application/services/IAuditLogService";
import { AuthContext } from "@/domain/auth/AuthContext";
import * as admin from "firebase-admin";
import { injectable } from "inversify";
import "reflect-metadata";

@injectable()
export class FirestoreAuditLogService implements IAuditLogService {
  private readonly _firestore: admin.firestore.Firestore;
  private readonly _collectionName = "auditLog";
  private readonly _tenantsCollectionName = "tenants";

  public constructor() {
    this._firestore = admin.firestore();
  }

  /**
   * Logs a critical action to the immutable audit log for a specific tenant.
   * This operation can be added to an existing WriteBatch.
   * @param action The type of action performed (e.g., 'team.create').
   * @param authContext The authentication context of the user performing the action.
   * @param details An object containing relevant details, such as target entity and changes.
   * @param batch An optional Firestore WriteBatch to add this operation to.
   */
  async log(
    action: string,
    authContext: AuthContext,
    details: {
      targetEntity: string;
      targetEntityId: string;
      change?: { oldValue: unknown; newValue: unknown };
      justification?: string;
    },
    batch?: admin.firestore.WriteBatch
  ): Promise<void> {
    const logEntry = {
      actionType: action,
      actingUserId: authContext.uid,
      actingUserEmail: authContext.email, // Denormalize for easier auditing
      tenantId: authContext.tenantId,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      ...details,
    };

    const logRef = this._firestore
      .collection(this._tenantsCollectionName)
      .doc(authContext.tenantId)
      .collection(this._collectionName)
      .doc();

    if (batch) {
      batch.set(logRef, logEntry);
    } else {
      await logRef.set(logEntry);
    }
  }
}