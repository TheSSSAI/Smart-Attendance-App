import { IAttendanceRepository } from "../../domain/repositories/IAttendanceRepository";
import { db } from "../../config/firebase";
import { logger } from "firebase-functions/v2";
import {
  Query,
  DocumentData,
  QueryDocumentSnapshot,
} from "firebase-admin/firestore";

// Implicitly defined entities based on requirements and data design.
// In a full DDD setup, these would be in the domain layer.

/**
 * Represents a user entity, containing minimal data needed for enrichment.
 */
export interface User {
  id: string;
  name: string;
  email: string;
}

/**
 * Represents an attendance record entity.
 */
export interface AttendanceRecord {
  id: string;
  tenantId: string;
  userId: string;
  checkInTime: Date;
  checkOutTime?: Date;
  status: "pending" | "approved" | "rejected";
  // Enriched data
  userName?: string;
  userEmail?: string;
  // Other properties from Firestore doc
  [key: string]: any;
}

/**
 * Firestore-based implementation of the IAttendanceRepository.
 * This class encapsulates all Firestore-specific logic for accessing and
 * managing attendance and related user data.
 */
export class FirestoreAttendanceRepository implements IAttendanceRepository {
  private readonly attendanceCollection = "attendance";
  private readonly usersCollection = "users";

  /**
   * Finds approved attendance records for a given tenant created after a specific timestamp.
   * Implements pagination using cursors for scalable data fetching.
   *
   * @param {string} tenantId - The ID of the tenant.
   * @param {Date} timestamp - The timestamp to query records after.
   * @param {number} limit - The maximum number of records to return.
   * @returns {Promise<AttendanceRecord[]>} A promise that resolves to an array of attendance records.
   */
  public async findApprovedRecordsSince(
    tenantId: string,
    timestamp: Date,
    limit: number,
  ): Promise<AttendanceRecord[]> {
    const collectionPath = `tenants/${tenantId}/${this.attendanceCollection}`;
    logger.info(
      `Finding approved records for tenant ${tenantId} since ${timestamp.toISOString()} with limit ${limit} in collection ${collectionPath}`,
    );
    try {
      let query: Query<DocumentData> = db
        .collection(collectionPath)
        .where("status", "==", "approved")
        .where("checkInTime", ">", timestamp)
        .orderBy("checkInTime", "asc")
        .limit(limit);

      const snapshot = await query.get();

      if (snapshot.empty) {
        logger.info(`No new approved records found for tenant ${tenantId}.`);
        return [];
      }

      const records = snapshot.docs.map(this.toAttendanceRecord);
      logger.info(
        `Found ${records.length} new approved records for tenant ${tenantId}.`,
      );

      return records;
    } catch (error) {
      logger.error(
        `Error fetching approved attendance records for tenant ${tenantId}:`,
        error,
      );
      // In a real application, throw a custom DataLayerError
      throw error;
    }
  }

  /**
   * Fetches multiple user documents by their IDs for a given tenant.
   * This is used to enrich attendance data with user names and emails.
   *
   * @param {string} tenantId - The ID of the tenant.
   * @param {string[]} userIds - An array of user IDs to fetch.
   * @returns {Promise<User[]>} A promise that resolves to an array of user objects.
   */
  public async getUsersByIds(
    tenantId: string,
    userIds: string[],
  ): Promise<User[]> {
    if (userIds.length === 0) {
      return [];
    }
    logger.info(
      `Fetching ${userIds.length} users for tenant ${tenantId}...`,
    );

    try {
      // Deduplicate userIds to avoid unnecessary reads
      const uniqueUserIds = [...new Set(userIds)];
      const userRefs = uniqueUserIds.map((id) =>
        db.collection(`tenants/${tenantId}/${this.usersCollection}`).doc(id),
      );

      const userDocs = await db.getAll(...userRefs);
      const users: User[] = [];

      for (const doc of userDocs) {
        if (doc.exists) {
          users.push(this.toUser(doc));
        } else {
          logger.warn(
            `User document with ID ${doc.id} not found for tenant ${tenantId}.`,
          );
        }
      }

      logger.info(`Successfully fetched ${users.length} user documents.`);
      return users;
    } catch (error) {
      logger.error(`Error fetching users by IDs for tenant ${tenantId}:`, error);
      throw error;
    }
  }

  /**
   * Maps a Firestore document snapshot to an AttendanceRecord domain entity.
   * @param {QueryDocumentSnapshot} doc - The Firestore document snapshot.
   * @returns {AttendanceRecord} The mapped attendance record.
   */
  private toAttendanceRecord(doc: QueryDocumentSnapshot): AttendanceRecord {
    const data = doc.data();
    return {
      id: doc.id,
      tenantId: data.tenantId,
      userId: data.userId,
      checkInTime: data.checkInTime.toDate(),
      checkOutTime: data.checkOutTime ? data.checkOutTime.toDate() : undefined,
      status: data.status,
      checkInGps: data.checkInGps,
      checkOutGps: data.checkOutGps,
      // Other potential fields
      notes: data.notes,
      flags: data.flags || [],
    };
  }

  /**
   * Maps a Firestore document snapshot to a User domain entity.
   * @param {QueryDocumentSnapshot} doc - The Firestore document snapshot.
   * @returns {User} The mapped user.
   */
  private toUser(doc: QueryDocumentSnapshot): User {
    const data = doc.data();
    return {
      id: doc.id,
      // User name might be stored as firstName/lastName or a single name field
      name: data.name || `${data.firstName || ""} ${data.lastName || ""}`.trim(),
      email: data.email,
    };
  }
}