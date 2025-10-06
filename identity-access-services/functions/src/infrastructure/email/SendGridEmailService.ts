import * as sgMail from "@sendgrid/mail";
import { IEmailService } from "../../domain/interfaces/IEmailService";
import { environment } from "../../config/environment";
import { AppError } from "../../domain/errors/AppError";
import { ErrorCode } from "../../domain/errors/ErrorCode";
import { injectable } from "tsyringe";

@injectable()
export class SendGridEmailService implements IEmailService {
  private isInitialized = false;

  constructor() {
    this.initialize();
  }

  private initialize(): void {
    const apiKey = environment.sendgrid.apiKey;
    if (!apiKey) {
      console.error("SendGrid API key is not configured. Email service will be disabled.");
      this.isInitialized = false;
      return;
    }
    sgMail.setApiKey(apiKey);
    this.isInitialized = true;
  }

  /**
   * Sends a user invitation email using a SendGrid template.
   * @param toEmail The recipient's email address.
   * @param orgName The name of the organization the user is being invited to.
   * @param registrationLink The unique, time-limited registration link for the user.
   * @returns A promise that resolves when the email is successfully sent.
   * @throws {AppError} if the email service is not initialized or fails to send the email.
   */
  async sendInvitationEmail(toEmail: string, orgName: string, registrationLink: string): Promise<void> {
    if (!this.isInitialized) {
      throw new AppError(ErrorCode.EmailServiceNotConfigured, "Email service is not configured. Cannot send invitation.");
    }
    if (!environment.sendgrid.invitationTemplateId) {
      throw new AppError(ErrorCode.EmailTemplateMissing, "Invitation email template ID is not configured.");
    }

    const msg = {
      to: toEmail,
      from: {
        email: environment.sendgrid.fromEmail,
        name: environment.sendgrid.fromName,
      },
      templateId: environment.sendgrid.invitationTemplateId,
      dynamicTemplateData: {
        org_name: orgName,
        registration_link: registrationLink,
        // Any other variables required by the SendGrid template
      },
    };

    try {
      await sgMail.send(msg);
      console.log(`Invitation email sent to ${toEmail}`);
    } catch (error: any) {
      console.error("SendGrid API Error:", JSON.stringify(error.response?.body || error, null, 2));
      // We log the error but don't re-throw as a critical AppError.
      // The user invitation process should succeed even if the email fails to send.
      // The system should have a way to re-send invitations.
      throw new AppError(ErrorCode.EmailServiceError, "Failed to send invitation email.", error);
    }
  }

  /**
   * Sends a tenant deletion confirmation email.
   * @param toEmail The admin's email address.
   * @param orgName The name of the organization being deleted.
   * @param deletionDate The exact date of permanent deletion.
   * @returns A promise that resolves when the email is sent.
   */
  async sendTenantDeletionNotice(toEmail: string, orgName: string, deletionDate: string): Promise<void> {
    if (!this.isInitialized || !environment.sendgrid.tenantDeletionTemplateId) {
      console.warn("Cannot send tenant deletion notice: service or template ID not configured.");
      return; // Non-critical failure
    }

    const msg = {
      to: toEmail,
      from: {
        email: environment.sendgrid.fromEmail,
        name: environment.sendgrid.fromName,
      },
      templateId: environment.sendgrid.tenantDeletionTemplateId,
      dynamicTemplateData: {
        org_name: orgName,
        deletion_date: deletionDate,
      },
    };

    try {
      await sgMail.send(msg);
      console.log(`Tenant deletion notice sent to ${toEmail}`);
    } catch (error) {
      console.error("Failed to send tenant deletion notice email.", error);
      // Log and continue, as this is a notification, not a transactional failure.
    }
  }
}