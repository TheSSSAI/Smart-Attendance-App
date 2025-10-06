import { inject, injectable } from "tsyringe";
import { Event } from "../../../domain/entities/Event";
import { IUserRepository } from "../../../domain/repositories/IUserRepository";
import { IFcmService } from "../../../infrastructure/services/FirebaseFcmService"; // Assuming interface is defined here
import { ILogger } from "../../../shared/services/ILogger"; // Assuming a shared logger interface

@injectable()
export class SendEventNotification {
  constructor(
    @inject("IUserRepository") private userRepository: IUserRepository,
    @inject("IFcmService") private fcmService: IFcmService,
    @inject("ILogger") private logger: ILogger,
  ) {}

  async execute(event: Event): Promise<void> {
    if (!event || (!event.assignedUserIds.length && !event.assignedTeamIds.length)) {
      this.logger.info(`SendEventNotification: Event ${event?.id} has no assignments. Skipping.`, { eventId: event?.id });
      return;
    }

    const { tenantId, assignedUserIds, assignedTeamIds } = event;
    const recipientIds = new Set<string>(assignedUserIds);

    try {
      if (assignedTeamIds.length > 0) {
        const teamMembers = await this.userRepository.findUsersByTeamIds(assignedTeamIds, tenantId);
        teamMembers.forEach((member) => recipientIds.add(member.id));
      }

      if (recipientIds.size === 0) {
        this.logger.info(`SendEventNotification: No active recipients found for event ${event.id}.`, { eventId: event.id });
        return;
      }

      const finalUserIds = Array.from(recipientIds);
      const users = await this.userRepository.findUsersByIds(finalUserIds, tenantId);

      const activeUsersWithTokens = users.filter((user) => user.status === "active" && user.fcmTokens && user.fcmTokens.length > 0);

      if (activeUsersWithTokens.length === 0) {
        this.logger.info(`SendEventNotification: No active users with FCM tokens found for event ${event.id}.`, {
          eventId: event.id,
          totalRecipients: finalUserIds.length,
        });
        return;
      }

      const allTokens = activeUsersWithTokens.flatMap((user) => user.fcmTokens);
      const uniqueTokens = [...new Set(allTokens)];

      const payload = {
        notification: {
          title: "New Event Assigned",
          body: `You have been assigned to a new event: ${event.title}`,
        },
        data: {
          eventId: event.id,
          click_action: "FLUTTER_NOTIFICATION_CLICK", // For mobile client to handle navigation
          screen: "calendar",
        },
      };

      this.logger.info(`Sending notifications for event ${event.id} to ${uniqueTokens.length} tokens.`, {
        eventId: event.id,
        userCount: activeUsersWithTokens.length,
      });

      await this.fcmService.sendToMultipleDevices(uniqueTokens, payload);
    } catch (error) {
      this.logger.error(`Failed to send notifications for event ${event.id}`, error as Error, { eventId: event.id });
      // We don't re-throw here to prevent the trigger from retrying for non-transient errors.
    }
  }
}