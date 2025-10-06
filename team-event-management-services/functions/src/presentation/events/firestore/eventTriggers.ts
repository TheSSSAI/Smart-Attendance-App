import * as functions from "firebase-functions";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { diContainer } from "../../../config/diContainer";
import { SendEventNotification } from "../../../application/use-cases/notifications/SendEventNotification";
import { EventMapper } from "../../../infrastructure/persistence/firestore/mappers/EventMapper";
import { Event as DomainEvent } from "../../../domain/entities/Event";

const logger = functions.logger;

/**
 * Firestore trigger that fires when a new event document is created.
 * It orchestrates sending push notifications to all assigned users.
 * This function is designed to be idempotent and fail gracefully by logging errors
 * instead of re-throwing, to prevent repeated executions for non-transient failures.
 */
export const onEventCreated = onDocumentCreated(
  "/tenants/{tenantId}/events/{eventId}",
  async (event) => {
    const useCaseToken = "SendEventNotificationUseCase";
    const snapshot = event.data;

    if (!snapshot) {
      logger.log(
        "onEventCreated trigger fired with no data. This can happen on document deletion.",
        { params: event.params },
      );
      return;
    }

    const data = snapshot.data();
    logger.info("New event created, processing for notifications.", {
      tenantId: event.params.tenantId,
      eventId: event.params.eventId,
    });

    try {
      // Map Firestore data to a rich domain entity
      const domainEvent: DomainEvent = EventMapper.toDomain(
        snapshot.id,
        data,
      );

      // We only send notifications for new, non-recurring-instance events
      // to avoid spamming users if a large recurring series is created.
      // Notifications for recurring events should be handled differently,
      // perhaps as a summary or through client-side logic.
      if (domainEvent.recurrenceId) {
        logger.info(
          "Event is an instance of a recurring series. Skipping notification.",
          { eventId: domainEvent.id },
        );
        return;
      }
      
      if (!domainEvent.assignedUserIds?.length && !domainEvent.assignedTeamIds?.length) {
        logger.info("Event has no assigned users or teams. Skipping notification.", {
          eventId: domainEvent.id,
        });
        return;
      }

      // Resolve and execute the use case
      const sendEventNotificationUseCase =
        diContainer.resolve<SendEventNotification>(useCaseToken);
      await sendEventNotificationUseCase.execute({
        event: domainEvent,
        tenantId: event.params.tenantId,
      });

      logger.info("Successfully processed notifications for event.", {
        eventId: event.params.eventId,
      });
    } catch (error) {
      logger.error(`Error processing notifications for event ${event.params.eventId}:`, {
        error,
        tenantId: event.params.tenantId,
      });
      // Do not re-throw error to prevent the function from retrying indefinitely
      // on non-transient errors (like a data modeling issue).
    }
  },
);