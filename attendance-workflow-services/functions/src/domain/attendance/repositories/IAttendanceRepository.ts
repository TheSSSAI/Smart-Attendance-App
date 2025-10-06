import { GeoPoint, Timestamp } from "firebase-admin/firestore";

/**
 * Represents the status of an attendance record.
 */
export type AttendanceStatus = "pending" | "approved" | "rejected" | "correction_pending";

/**
 * Represents an attendance record entity.
 * This is the core domain entity for the attendance bounded context.
 */
export interface AttendanceRecord {
  id: string;
  tenantId: string;
  userId: string;
  supervisorId: string;
  checkInTime: Timestamp;
  checkInGps: GeoPoint;
  checkInClientTimestamp: Timestamp;
  checkOutTime: Timestamp | null;
  checkOutGps: GeoPoint | null;
  checkOutClientTimestamp: Timestamp | null;
  status: AttendanceStatus;
  statusBeforeCorrection?: AttendanceStatus;
  rejectionReason?: string;
  eventId?: string;
  flags: string[];
  // Fields for pending correction
  correction?: {
    requestedBy: string;
    requestedAt: Timestamp;
    justification: string;
    newCheckInTime?: Timestamp;
    newCheckOutTime?: Timestamp;
  };
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

/**
 * An abstraction over the underlying database transaction object.
 * This ensures that the application layer can orchestrate transactions
 * without being coupled to a specific database technology (e.g., Firestore).
 */
export interface ITransaction {
  // The implementation will hold the actual transaction object, e.g., Firestore.Transaction
  // This is intentionally left as an opaque interface in the domain layer.
}

/**
 * Defines the contract for a repository that manages persistence for AttendanceRecord entities.
 * It abstracts the data access logic from the application's business logic, adhering to Clean Architecture principles.
 */
export interface IAttendanceRepository {
  /**
   * Executes a series of repository operations within a single atomic transaction.
   * @param updateFunction A function that receives a transaction object and performs transactional reads and writes.
   * @returns A promise that resolves with the result of the update function.
   */
  runInTransaction<T>(updateFunction: (transaction: ITransaction) => Promise<T>): Promise<T>;

  /**
   * Retrieves a single attendance record by its ID within a specific tenant.
   * @param tenantId The ID of the tenant.
   * @param recordId The unique ID of the attendance record.
   * @param transaction Optional transaction object to ensure transactional reads.
   * @returns A promise that resolves to the AttendanceRecord or null if not found.
   */
  findById(tenantId: string, recordId: string, transaction?: ITransaction): Promise<AttendanceRecord | null>;

  /**
   * Finds all open attendance records for a given tenant on a specific date.
   * "Open" means a record has a checkInTime but a null checkOutTime.
   * This is primarily used by the auto-checkout scheduled job.
   * @param tenantId The ID of the tenant to query within.
   * @param forDate The calendar date for which to find open records.
   * @returns A promise that resolves to an array of open AttendanceRecords.
   */
  findOpenRecordsForTenant(tenantId: string, forDate: Date): Promise<AttendanceRecord[]>;

  /**
   * Finds all attendance records with a 'pending' status that were created before a specified timestamp.
   * This is used by the approval escalation scheduled job.
   * @param tenantId The ID of the tenant.
   * @param olderThan The timestamp to find records created before this date.
   * @returns A promise that resolves to an array of overdue pending AttendanceRecords.
   */
  findOverduePendingRecords(tenantId: string, olderThan: Date): Promise<AttendanceRecord[]>;

  /**
   * Persists an AttendanceRecord entity to the database.
   * Can be used for both creating a new record and updating an existing one.
   * @param record The AttendanceRecord entity to save.
   * @param transaction Optional transaction object to perform the save within an atomic operation.
   * @returns A promise that resolves when the operation is complete.
   */
  save(record: AttendanceRecord, transaction?: ITransaction): Promise<void>;
}