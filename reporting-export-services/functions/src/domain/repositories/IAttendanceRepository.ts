/**
 * @fileoverview Defines the IAttendanceRepository interface.
 * This file specifies the contract for data access operations related to attendance records.
 * It adheres to the Dependency Inversion Principle, allowing the application layer
 * to depend on this abstraction rather than a concrete implementation like Firestore.
 *
 * @see REQ-1-059, REQ-1-069
 */

/**
 * Represents the basic structure of a GPS coordinate point.
 */
export interface GpsPoint {
  latitude: number;
  longitude: number;
}

/**
 * Represents an enriched attendance record combined with user details.
 * This structure contains all necessary fields for the Google Sheets export
 * as specified in REQ-1-059.
 */
export interface EnrichedAttendanceRecord {
  recordId: string;
  userName: string;
  userEmail: string;
  checkInTime: Date;
  checkInGps: GpsPoint | null;
  checkOutTime: Date | null;
  checkOutGps: GpsPoint | null;
  status: string;
  notes: string | null;
}

/**
 * Represents the result of a paginated query for attendance records.
 */
export interface PaginatedAttendanceResult {
  /** The batch of enriched attendance records fetched. */
  records: EnrichedAttendanceRecord[];
  /** A cursor pointing to the last document in the batch, to be used for fetching the next page. */
  nextCursor?: any;
  /** Indicates if there are more records to fetch after this batch. */
  hasMore: boolean;
}

/**
 * Interface for the Attendance Repository, defining the contract for retrieving
 * attendance data from the persistence layer.
 */
export interface IAttendanceRepository {
  /**
   * Finds all approved attendance records for a specific tenant that have a
   * check-in time after a given timestamp. This method supports pagination
   * to handle large datasets efficiently.
   *
   * @param tenantId The ID of the tenant whose records are to be fetched.
   * @param since The timestamp after which to find records. Acts as a cursor.
   * @param options An object containing pagination parameters.
   * @param options.limit The maximum number of records to return in this batch.
   * @param options.startAfter An optional cursor from a previous query to fetch the next page.
   * @returns A Promise that resolves to a `PaginatedAttendanceResult` object,
   *          containing the records for the current page and a cursor for the next.
   * @see REQ-1-059
   */
  findApprovedRecordsSince(
    tenantId: string,
    since: Date,
    options: { limit: number; startAfter?: any },
  ): Promise<PaginatedAttendanceResult>;
}