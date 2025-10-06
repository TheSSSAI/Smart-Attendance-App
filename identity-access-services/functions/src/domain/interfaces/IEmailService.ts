/**
 * @fileoverview Defines the contract for an Email service, abstracting the underlying email provider (e.g., SendGrid).
 * This interface allows the application to send emails without being tightly coupled to a specific implementation.
 */

export interface IEmailService {
  /**
   * Sends an invitation email to a new user.
   * @param to The recipient's email address.
   * @param inviterName The name of the person who sent the invitation (the Admin).
   * @param organizationName The name of the organization the user is being invited to.
   * @param registrationLink The unique, time-limited link for the user to complete their registration.
   * @returns A Promise that resolves when the email has been successfully sent.
   * @throws Will throw an error if the email fails to send.
   * @see REQ-1-036
   * @see US-005
   */
  sendInvitationEmail(
    to: string,
    inviterName: string,
    organizationName: string,
    registrationLink: string
  ): Promise<void>;

  /**
   * Sends a notification email to an Admin about a pending tenant deletion.
   * @param to The Admin's email address.
   * @param organizationName The name of the organization scheduled for deletion.
   * @param deletionDate The exact date and time of the permanent deletion.
   * @returns A Promise that resolves when the email has been sent.
   * @see US-024
   */
  sendTenantDeletionNotification(
    to: string,
    organizationName: string,
    deletionDate: Date
  ): Promise<void>;
}