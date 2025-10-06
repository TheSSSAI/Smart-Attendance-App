import { Event } from "../entities/Event";
import { WriteBatch } from "firebase-admin/firestore";

/**
 * Interface for the Event repository.
 * Defines the contract for data access operations related to the Event aggregate.
 * This abstraction is crucial for decoupling event management logic from the
 * underlying persistence technology.
 */
export interface IEventRepository {
  /**
   * Finds an Event by its unique identifier within a specific tenant.
   * @param eventId - The unique identifier of the event.
   * @param tenantId - The identifier of the tenant to which the event belongs.
   * @returns A Promise that resolves to the Event entity if found, otherwise null.
   */
  findById(eventId: string, tenantId: string): Promise<Event | null>;

  /**
   * Retrieves all events within a given date range that are assigned to a specific user,
   * either directly or through their team memberships.
   * @param userId - The ID of the user for whom to find events.
   * @param teamIds - An array of team IDs the user is a member of.
   * @param startDate - The start of the date range (inclusive).
   * @param endDate - The end of the date range (inclusive).
   * @param tenantId - The identifier of the tenant.
   * @returns A Promise that resolves to an array of Event entities matching the criteria.
   */
  findForUser(userId: string, teamIds: string[], startDate: Date, endDate: Date, tenantId: string): Promise<Event[]>;

  /**
   * Saves a single Event entity (creates a new one or updates an existing one).
   * This operation can be part of a larger transaction controlled by a WriteBatch.
   * @param event - The Event entity to save.
   * @param batch - An optional Firestore WriteBatch to add this operation to.
   * @returns A Promise that resolves when the save operation is completed or added to the batch.
   */
  save(event: Event, batch?: WriteBatch): Promise<void>;

  /**
   * Saves multiple Event entities in a single atomic operation. This is essential for
   * efficiently creating instances of a recurring event.
   * @param events - An array of Event entities to create.
   * @param tenantId - The tenant context for the operation.
   * @param batch - The Firestore WriteBatch to add the operations to. This is typically required
   * for batch operations to ensure atomicity.
   * @returns A Promise that resolves when all save operations are added to the batch.
   */
  saveAll(events: Event[], tenantId: string, batch: WriteBatch): Promise<void>;

  /**
   * Deletes an Event by its unique identifier.
   * @param eventId - The unique identifier of the event to delete.
   * @param tenantId - The identifier of the tenant to which the event belongs.
   * @param batch - An optional Firestore WriteBatch to add this operation to.
   * @returns A Promise that resolves when the delete operation is completed or added to the batch.
   */
  delete(eventId: string, tenantId: string, batch?: WriteBatch): Promise<void>;

  /**
   * Deletes all events that share a common recurrence ID.
   * This is used when a recurring event series is modified or deleted.
   * @param recurrenceId - The unique identifier for the recurring event series.
   * @param tenantId - The identifier of the tenant.
   * @param batch - An optional Firestore WriteBatch to perform the deletions within a transaction.
   * @returns A Promise that resolves on completion.
   */
  deleteByRecurrenceId(recurrenceId: string, tenantId: string, batch?: WriteBatch): Promise<void>;
}