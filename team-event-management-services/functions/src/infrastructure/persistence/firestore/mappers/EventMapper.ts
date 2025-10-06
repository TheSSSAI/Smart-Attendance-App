import { Event } from "../../../../domain/entities/Event";
import * as admin from "firebase-admin";

type Timestamp = admin.firestore.Timestamp;
type EventDocumentData = admin.firestore.DocumentData;

/**
 * @class EventMapper
 * @description A static class responsible for mapping between the Event domain entity and its Firestore document representation.
 * It handles data transformations, such as converting between Firestore Timestamps and JavaScript Date objects.
 */
export class EventMapper {
  /**
   * Maps a Firestore document to an Event domain entity.
   * @param {string} id - The document ID from Firestore.
   * @param {EventDocumentData} data - The document data from Firestore.
   * @returns {Event} An Event domain entity instance.
   */
  public static toDomain(id: string, data: EventDocumentData): Event {
    // Validate required fields
    if (!data.title || typeof data.title !== "string") {
      throw new Error(`Event document ${id} is missing a valid 'title' field.`);
    }
    if (!data.startTime || !(data.startTime instanceof admin.firestore.Timestamp)) {
      throw new Error(`Event document ${id} is missing a valid 'startTime' timestamp.`);
    }
    if (!data.endTime || !(data.endTime instanceof admin.firestore.Timestamp)) {
      throw new Error(`Event document ${id} is missing a valid 'endTime' timestamp.`);
    }
    if (!data.createdByUserId || typeof data.createdByUserId !== "string") {
      throw new Error(`Event document ${id} is missing a valid 'createdByUserId' field.`);
    }

    // Handle optional and array fields with defaults for robustness
    const description = typeof data.description === "string" ? data.description : null;
    const recurrenceRule = typeof data.recurrenceRule === "string" ? data.recurrenceRule : null;
    const assignedUserIds = Array.isArray(data.assignedUserIds) ? data.assignedUserIds : [];
    const assignedTeamIds = Array.isArray(data.assignedTeamIds) ? data.assignedTeamIds : [];

    const event = new Event({
      id,
      title: data.title,
      description,
      startTime: (data.startTime as Timestamp).toDate(), // Convert Firestore Timestamp to JS Date
      endTime: (data.endTime as Timestamp).toDate(), // Convert Firestore Timestamp to JS Date
      assignedUserIds,
      assignedTeamIds,
      createdByUserId: data.createdByUserId,
      recurrenceRule,
    });

    return event;
  }

  /**
   * Maps an Event domain entity to a plain object for Firestore persistence.
   * The 'id' property is excluded as it's the document key in Firestore.
   * It handles converting JavaScript Date objects back to Firestore Timestamps.
   * @param {Event} event - The Event domain entity instance.
   * @returns {object} A plain object suitable for writing to Firestore.
   */
  public static toPersistence(event: Event): {
    title: string;
    description: string | null;
    startTime: Timestamp;
    endTime: Timestamp;
    assignedUserIds: string[];
    assignedTeamIds: string[];
    createdByUserId: string;
    recurrenceRule: string | null;
    } {
    return {
      title: event.title,
      description: event.description,
      startTime: admin.firestore.Timestamp.fromDate(event.startTime), // Convert JS Date to Firestore Timestamp
      endTime: admin.firestore.Timestamp.fromDate(event.endTime), // Convert JS Date to Firestore Timestamp
      assignedUserIds: event.assignedUserIds,
      assignedTeamIds: event.assignedTeamIds,
      createdByUserId: event.createdByUserId,
      recurrenceRule: event.recurrenceRule,
    };
  }
}