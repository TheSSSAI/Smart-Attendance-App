import {
  Firestore,
  FieldValue,
  Timestamp,
  Transaction,
  WriteBatch,
} from "firebase-admin/firestore";
import { IAuditLogRepository } from "../../../domain/attendance/repositories/IAuditLogRepository";
import { AuditLog } from "../../../domain/audit/entities/AuditLog";
import { DataPersistenceError } from "../../../domain/common/errors/DataPersistenceError";

type AuditLogDocument = {
  actionType: string;
  actorUserId: string;
  tenantId: string;
  targetEntity: string;
  targetEntityId: string;
  timestamp: FieldValue;
  details: Record<string, any>;
  justification?: string;
};

export class FirestoreAuditLogRepository implements IAuditLogRepository {
  private static readonly COLLECTION_NAME = "auditLog";

  constructor(private readonly db: Firestore) {}

  /**
   * Creates a new audit log entry. This is a write-only operation from this service.
   * @param log - The AuditLog entity to create.
   * @param transaction - An optional Firestore transaction to run this operation within.
   * @returns A promise that resolves when the creation is complete.
   */
  async create(
    log: AuditLog,
    transactionOrBatch?: Transaction | WriteBatch,
  ): Promise<void> {
    try {
      const collectionRef = this.db
        .collection("tenants")
        .doc(log.tenantId)
        .collection(FirestoreAuditLogRepository.COLLECTION_NAME);
      const docRef = collectionRef.doc(); // Auto-generate ID

      const persistenceData = this.toPersistence(log);

      if (transactionOrBatch) {
        transactionOrBatch.set(docRef, persistenceData);
      } else {
        await docRef.set(persistenceData);
      }
    } catch (error) {
      console.error(
        `Error creating audit log for tenant: ${log.tenantId}`,
        error,
      );
      throw new DataPersistenceError("Failed to create audit log in Firestore.");
    }
  }

  /**
   * Maps an AuditLog domain entity to a Firestore document.
   * @param log - The AuditLog entity.
   * @returns A plain object for Firestore.
   */
  private toPersistence(log: AuditLog): AuditLogDocument {
    const data: AuditLogDocument = {
      actionType: log.actionType,
      actorUserId: log.actorUserId,
      tenantId: log.tenantId,
      targetEntity: log.targetEntity,
      targetEntityId: log.targetEntityId,
      timestamp: FieldValue.serverTimestamp(),
      details: log.details ?? {},
    };

    if (log.justification) {
      data.justification = log.justification;
    }

    return data;
  }

  // Reading audit logs is out of scope for the attendance-workflow-services.
  // We only implement the create method as required by the use cases in this bounded context.
  // A `toDomain` mapper is omitted for this reason.
}