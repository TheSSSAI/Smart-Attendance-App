import { IUserRepository } from "@/domain/repositories/IUserRepository";
import { injectable, inject } from "inversify";
import * as admin from "firebase-admin";
import "reflect-metadata";

export interface FcmPayload {
  title: string;
  body: string;
  data?: { [key: string]: string };
}

export interface IFcmService {
  sendNotificationToUser(
    userId: string,
    tenantId: string,
    payload: FcmPayload
  ): Promise<void>;
  sendNotificationToUsers(
    userIds: string[],
    tenantId: string,
    payload: FcmPayload
  ): Promise<void>;
}

@injectable()
export class FirebaseFcmService implements IFcmService {
  private readonly _messaging: admin.messaging.Messaging;
  private readonly _userRepository: IUserRepository;

  public constructor(
    @inject("IUserRepository") userRepository: IUserRepository
  ) {
    this._messaging = admin.messaging();
    this._userRepository = userRepository;
  }

  /**
   * Sends a push notification to a single user.
   * @param userId The ID of the user to notify.
   * @param tenantId The tenant context for the user.
   * @param payload The notification payload.
   */
  async sendNotificationToUser(
    userId: string,
    tenantId: string,
    payload: FcmPayload
  ): Promise<void> {
    await this.sendNotificationToUsers([userId], tenantId, payload);
  }

  /**
   * Sends a push notification to multiple users.
   * Fetches FCM tokens for the users and sends notifications in batches.
   * @param userIds An array of user IDs to notify.
   * @param tenantId The tenant context for the users.
   * @param payload The notification payload.
   */
  async sendNotificationToUsers(
    userIds: string[],
    tenantId: string,
    payload: FcmPayload
  ): Promise<void> {
    if (userIds.length === 0) {
      return;
    }

    const users = await this._userRepository.findByIds(userIds, tenantId);
    const allTokens: string[] = users.flatMap((user) => user.fcmTokens || []);
    const uniqueTokens = [...new Set(allTokens)];

    if (uniqueTokens.length === 0) {
      console.log("No FCM tokens found for the specified users.");
      return;
    }

    const message: admin.messaging.MulticastMessage = {
      notification: {
        title: payload.title,
        body: payload.body,
      },
      data: payload.data,
      tokens: uniqueTokens,
    };

    try {
      const response = await this._messaging.sendEachForMulticast(message);
      if (response.failureCount > 0) {
        console.warn(
          `${response.failureCount} notifications failed to send.`
        );
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            console.error(
              `Failed to send to token ${uniqueTokens[idx]}:`,
              resp.error
            );
            // Here you could implement logic to clean up invalid tokens
          }
        });
      }
    } catch (error) {
      console.error("Error sending FCM notifications:", error);
      // Re-throw as a more specific error if needed by the application layer
    }
  }
}