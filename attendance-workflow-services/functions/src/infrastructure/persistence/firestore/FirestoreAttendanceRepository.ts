import {
  Firestore,
  Timestamp,
  GeoPoint,
  FieldValue,
  Transaction,
  WriteBatch,
} from "firebase-admin/firestore";
import { IAttendanceRepository } from "../../../domain/attendance/repositories/IAttendanceRepository";
import { AttendanceRecord, AttendanceStatus } from "../../../domain/attendance/entities/AttendanceRecord";
import { User } from "../../../domain/users/entities/User";
import { DataPersistenceError } from "../../../domain/common/errors/DataPersistenceError";

// A private helper type for mapping to/from Firestore documents
type AttendanceDocument = {
  userId: string;
  tenantId: string;
  supervisorId: string;
  checkInTime: Timestamp;
  checkOutTime: Timestamp | null;
  checkInGps: GeoPoint;
  checkOutGps: GeoPoint | null;
  status: AttendanceStatus;
  notes: string | null;
  flags: string[];
  createdAt: Timestamp | FieldValue;
  updatedAt: Timestamp | FieldValue;
  eventId?: string;
  // Correction-related fields
  correction?: {
    requestedTime: Timestamp;
    requestedBy: string;
    justification: string;
    originalCheckInTime: Timestamp;
    originalCheckOutTime: Timestamp | null;
  };
  statusBeforeCorrection?: AttendanceStatus;
  rejectionReason?: string;
};

export class FirestoreAttendanceRepository implements IAttendanceRepository {
  private static readonly COLLECTION_NAME = "attendance";

  constructor(private readonly db: Firestore) {}

  /**
   * Finds an attendance record by its ID within a specific tenant.
   * @param tenantId - The ID of the tenant.
   * @param recordId - The ID of the attendance record.
   * @returns The AttendanceRecord entity or null if not found.
   */
  async findById(
    tenantId: string,
    recordId: string,
  ): Promise<AttendanceRecord | null> {
    try {
      const docRef = this.db
        .collection("tenants")
        .doc(tenantId)
        .collection(FirestoreAttendanceRepository.COLLECTION_NAME)
        .doc(recordId);

      const snapshot = await docRef.get();

      if (!snapshot.exists) {
        return null;
      }

      return this.toDomain(snapshot.id, snapshot.data() as AttendanceDocument);
    } catch (error) {
      // Log the specific error for debugging purposes
      console.error(
        `Error fetching attendance record by ID: ${recordId} for tenant: ${tenantId}`,
        error,
      );
      throw new DataPersistenceError(
        "Failed to fetch attendance record from Firestore.",
      );
    }
  }

  /**
   * Finds all open attendance records for a given tenant on a specific date.
   * Required for REQ-1-045 (Auto-Checkout).
   * @param tenantId - The ID of the tenant.
   * @param forDate - The date to check for open records.
   * @returns An array of AttendanceRecord entities.
   */
  async findOpenRecordsForTenant(
    tenantId: string,
    forDate: Date,
  ): Promise<AttendanceRecord[]> {
    // Note: This query requires a composite index on (tenantId, checkInTime, checkOutTime)
    try {
      const startOfDay = new Date(forDate);
      startOfDay.setHours(0, 0, 0, 0);
      const endOfDay = new Date(forDate);
      endOfDay.setHours(23, 59, 59, 999);

      const querySnapshot = await this.db
        .collectionGroup(FirestoreAttendanceRepository.COLLECTION_NAME)
        .where("tenantId", "==", tenantId)
        .where("checkInTime", ">=", Timestamp.fromDate(startOfDay))
        .where("checkInTime", "<=", Timestamp.fromDate(endOfDay))
        .where("checkOutTime", "==", null)
        .get();

      return querySnapshot.docs.map((doc) =>
        this.toDomain(doc.id, doc.data() as AttendanceDocument),
      );
    } catch (error) {
      console.error(
        `Error finding open records for tenant: ${tenantId}`,
        error,
      );
      throw new DataPersistenceError(
        "Failed to find open attendance records.",
      );
    }
  }

  /**
   * Finds all attendance records across all tenants that are in 'pending' status and older than a specified date.
   * Required for REQ-1-051 (Approval Escalation).
   * @param olderThan - The timestamp to compare against.
   * @returns An array of overdue AttendanceRecord entities.
   */
  async findOverduePendingRecords(
    olderThan: Date,
  ): Promise<AttendanceRecord[]> {
    // Note: This query requires a composite index on (status, createdAt)
    try {
      const querySnapshot = await this.db
        .collectionGroup(FirestoreAttendanceRepository.COLLECTION_NAME)
        .where("status", "==", "pending")
        .where("createdAt", "<", Timestamp.fromDate(olderThan))
        .get();

      return querySnapshot.docs.map((doc) =>
        this.toDomain(doc.id, doc.data() as AttendanceDocument),
      );
    } catch (error) {
      console.error(`Error finding overdue pending records`, error);
      throw new DataPersistenceError(
        "Failed to find overdue pending records.",
      );
    }
  }

  /**
   * Saves (creates or updates) an attendance record.
   * @param record - The AttendanceRecord entity to save.
   * @param transaction - An optional Firestore transaction to run this operation within.
   * @returns A promise that resolves when the save is complete.
   */
  async save(
    record: AttendanceRecord,
    transaction?: Transaction,
    batch?: WriteBatch,
  ): Promise<void> {
    try {
      const docRef = this.db
        .collection("tenants")
        .doc(record.tenantId)
        .collection(FirestoreAttendanceRepository.COLLECTION_NAME)
        .doc(record.id);

      const persistenceData = this.toPersistence(record);

      if (transaction) {
        transaction.set(docRef, persistenceData, { merge: true });
      } else if (batch) {
        batch.set(docRef, persistenceData, { merge: true });
      } else {
        await docRef.set(persistenceData, { merge: true });
      }
    } catch (error) {
      console.error(
        `Error saving attendance record: ${record.id} for tenant: ${record.tenantId}`,
        error,
      );
      throw new DataPersistenceError(
        "Failed to save attendance record to Firestore.",
      );
    }
  }

  /**
   * Maps a Firestore document to an AttendanceRecord domain entity.
   * @param id - The document ID.
   * @param data - The Firestore document data.
   * @returns An AttendanceRecord entity.
   */
  private toDomain(id: string, data: AttendanceDocument): AttendanceRecord {
    return new AttendanceRecord({
      id,
      userId: data.userId,
      tenantId: data.tenantId,
      supervisorId: data.supervisorId,
      checkInTime: data.checkInTime.toDate(),
      checkOutTime: data.checkOutTime ? data.checkOutTime.toDate() : null,
      checkInGps: {
        latitude: data.checkInGps.latitude,
        longitude: data.checkInGps.longitude,
      },
      checkOutGps: data.checkOutGps
        ? {
            latitude: data.checkOutGps.latitude,
            longitude: data.checkOutGps.longitude,
          }
        : null,
      status: data.status,
      notes: data.notes,
      flags: data.flags,
      createdAt: (data.createdAt as Timestamp).toDate(),
      updatedAt: (data.updatedAt as Timestamp).toDate(),
      eventId: data.eventId,
      correction: data.correction
        ? {
            requestedTime: data.correction.requestedTime.toDate(),
            requestedBy: data.correction.requestedBy,
            justification: data.correction.justification,
            originalCheckInTime: data.correction.originalCheckInTime.toDate(),
            originalCheckOutTime: data.correction.originalCheckOutTime
              ? data.correction.originalCheckOutTime.toDate()
              : null,
          }
        : undefined,
      statusBeforeCorrection: data.statusBeforeCorrection,
      rejectionReason: data.rejectionReason,
    });
  }

  /**
   * Maps an AttendanceRecord domain entity to a Firestore document.
   * @param record - The AttendanceRecord entity.
   * @returns A plain object for Firestore.
   */
  private toPersistence(record: AttendanceRecord): AttendanceDocument {
    const isNew = !record.createdAt;
    const data: Partial<AttendanceDocument> = {
      userId: record.userId,
      tenantId: record.tenantId,
      supervisorId: record.supervisorId,
      checkInTime: Timestamp.fromDate(record.checkInTime),
      checkOutTime: record.checkOutTime
        ? Timestamp.fromDate(record.checkOutTime)
        : null,
      checkInGps: new GeoPoint(
        record.checkInGps.latitude,
        record.checkInGps.longitude,
      ),
      checkOutGps: record.checkOutGps
        ? new GeoPoint(
            record.checkOutGps.latitude,
            record.checkOutGps.longitude,
          )
        : null,
      status: record.status,
      notes: record.notes ?? null,
      flags: record.flags ?? [],
      updatedAt: FieldValue.serverTimestamp(),
    };

    if (isNew) {
      data.createdAt = FieldValue.serverTimestamp();
    }
    if (record.eventId) {
      data.eventId = record.eventId;
    }
    if (record.correction) {
      data.correction = {
        ...record.correction,
        requestedTime: Timestamp.fromDate(record.correction.requestedTime),
        originalCheckInTime: Timestamp.fromDate(
          record.correction.originalCheckInTime,
        ),
        originalCheckOutTime: record.correction.originalCheckOutTime
          ? Timestamp.fromDate(record.correction.originalCheckOutTime)
          : null,
      };
    }
    if (record.statusBeforeCorrection) {
      data.statusBeforeCorrection = record.statusBeforeCorrection;
    }
    if (record.rejectionReason) {
      data.rejectionReason = record.rejectionReason;
    }

    return data as AttendanceDocument;
  }
}