import { IEventRepository } from "@/domain/repositories/IEventRepository";
import { Event } from "@/domain/entities/Event";
import { EventMapper } from "@/infrastructure/persistence/firestore/mappers/EventMapper";
import * as admin from "firebase-admin";
import { injectable } from "inversify";
import "reflect-metadata";

@injectable()
export class FirestoreEventRepository implements IEventRepository {
  private readonly _firestore: admin.firestore.Firestore;
  private readonly _collectionName = "events";
  private readonly _tenantsCollectionName = "tenants";

  public constructor() {
    this._firestore = admin.firestore();
  }

  /**
   * Retrieves an event by its ID within a specific tenant.
   * @param eventId The unique ID of the event.
   * @param tenantId The tenant context for the query.
   * @returns An Event entity or null if not found.
   */
  async findById(eventId: string, tenantId: string): Promise<Event | null> {
    const docRef = this._firestore
      .collection(this._tenantsCollectionName)
      .doc(tenantId)
      .collection(this._collectionName)
      .doc(eventId);
    const docSnap = await docRef.get();

    if (!docSnap.exists) {
      return null;
    }
    return EventMapper.toDomain(docSnap);
  }

  /**
   * Adds a save (create or update) operation for an Event entity to a Firestore WriteBatch.
   * This method does not commit the batch.
   * @param event The Event entity to save.
   * @param batch The Firestore WriteBatch to add the operation to.
   */
  save(event: Event, batch: admin.firestore.WriteBatch): void {
    const docRef = this._firestore
      .collection(this._tenantsCollectionName)
      .doc(event.tenantId)
      .collection(this._collectionName)
      .doc(event.id);

    const persistenceModel = EventMapper.toPersistence(event);
    batch.set(docRef, persistenceModel, { merge: true });
  }

  /**
   * Adds a delete operation for an event to a Firestore WriteBatch.
   * This method does not commit the batch.
   * @param eventId The ID of the event to delete.
   * @param tenantId The tenant context for the operation.
   * @param batch The Firestore WriteBatch to add the operation to.
   */
  delete(
    eventId: string,
    tenantId: string,
    batch: admin.firestore.WriteBatch
  ): void {
    const docRef = this._firestore
      .collection(this._tenantsCollectionName)
      .doc(tenantId)
      .collection(this._collectionName)
      .doc(eventId);
    batch.delete(docRef);
  }

  /**
   * Saves multiple event instances using a batch write.
   * This is useful for creating recurring event instances.
   * @param events An array of Event entities to save.
   */
  async saveMany(events: Event[]): Promise<void> {
    if (events.length === 0) {
      return;
    }

    const batch = this._firestore.batch();
    events.forEach((event) => this.save(event, batch));
    await batch.commit();
  }
}