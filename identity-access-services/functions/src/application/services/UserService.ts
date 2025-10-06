import * as functions from "firebase-functions";
import { CompleteRegistrationDto } from "@/application/dtos/CompleteRegistrationDto";
import { UserInvitationDto } from "@/application/dtos/UserInvitationDto";
import { IAuditLogService } from "@/domain/interfaces/IAuditLogService";
import { IAuthService } from "@/domain/interfaces/IAuthService";
import { IEmailService } from "@/domain/interfaces/IEmailService";
import { IUserRepository } from "@/domain/interfaces/IUserRepository";
import { IUserService } from "@/domain/interfaces/IUserService";
import { HttpsError } from "firebase-functions/v2/https";
import { User } from "@/domain/entities/User";
import { AuditLog } from "@/domain/entities/AuditLog";
import { randomBytes } from "crypto";

export class UserService implements IUserService {
  constructor(
    private readonly userRepository: IUserRepository,
    private readonly authService: IAuthService,
    private readonly emailService: IEmailService,
    private readonly auditLogService: IAuditLogService
  ) {}

  async inviteNewUser(data: UserInvitationDto, tenantId: string, adminId: string, orgName: string): Promise<void> {
    functions.logger.info(`Admin ${adminId} is inviting user ${data.email} to tenant ${tenantId}.`);

    const existingUser = await this.userRepository.findByEmailInTenant(data.email, tenantId);
    if (existingUser) {
      throw new HttpsError("already-exists", `A user with email ${data.email} already exists in this organization.`);
    }

    const invitationToken = randomBytes(32).toString("hex");
    const invitationExpiry = new Date();
    invitationExpiry.setHours(invitationExpiry.getHours() + 24);

    // This ID is temporary until the user registers and an Auth UID is created.
    // For simplicity in this model, we'll let Firestore generate an ID.
    // In a real-world scenario, you might pre-generate a UUID.
    const invitedUser = new User(
      "", // Firestore will generate an ID for this doc
      tenantId,
      "Invited User",
      data.email,
      data.role,
      "invited",
      null, // supervisorId can be set later
      [], // teamIds
      invitationToken,
      invitationExpiry
    );

    const { id: temporaryUserId } = await this.userRepository.create(invitedUser);
    functions.logger.info(`Created 'invited' user document ${temporaryUserId} for ${data.email}.`);

    try {
      await this.emailService.sendInvitationEmail(data.email, invitationToken, orgName);
      functions.logger.info(`Successfully sent invitation email to ${data.email}.`);
    } catch (error) {
      functions.logger.error("Failed to send invitation email. User remains in 'invited' state.", {
        email: data.email,
        error,
      });
      // We don't throw here, allowing the admin to resend the invitation later.
      // The user record is updated to reflect the delivery failure.
      await this.userRepository.update(temporaryUserId, { invitationStatus: "delivery_failed" });
    }

    const auditLog = new AuditLog(
      "",
      adminId,
      "user.invite",
      temporaryUserId,
      "User",
      `Admin invited ${data.email} with role ${data.role}.`
    );
    await this.auditLogService.log(tenantId, auditLog);
  }

  async completeUserRegistration(data: CompleteRegistrationDto): Promise<{ userId: string }> {
    functions.logger.info(`Attempting to complete registration with token.`);

    const userToActivate = await this.userRepository.findByInvitationToken(data.token);

    if (!userToActivate || !userToActivate.invitationExpiry) {
      throw new HttpsError("not-found", "This invitation link is invalid or has already been used.");
    }

    if (new Date() > userToActivate.invitationExpiry) {
      throw new HttpsError("deadline-exceeded", "This invitation link has expired. Please contact your administrator.");
    }

    if (userToActivate.status !== "invited") {
      throw new HttpsError("failed-precondition", "This invitation has already been used.");
    }

    let authUserUid: string | null = null;
    try {
      // Create the user in Firebase Auth. Password policy is enforced by `beforeCreate` trigger.
      const { uid } = await this.authService.createUser({
        email: userToActivate.email,
        password: data.password,
        displayName: userToActivate.name,
      });
      authUserUid = uid;

      // Update Firestore user document: set status, clear token, and crucially, set the permanent Auth UID
      await this.userRepository.update(userToActivate.id, {
        status: "active",
        userId: authUserUid, // Set the permanent Auth UID
        invitationToken: null,
        invitationExpiry: null,
        invitationStatus: null,
      });

      // Set custom claims for the new user
      await this.authService.setCustomClaims(authUserUid, {
        tenantId: userToActivate.tenantId,
        role: userToActivate.role,
      });

      const auditLog = new AuditLog(
        "",
        authUserUid,
        "user.activate",
        authUserUid,
        "User",
        `User ${userToActivate.email} completed registration and activated their account.`
      );
      await this.auditLogService.log(userToActivate.tenantId, auditLog);

      return { userId: authUserUid };
    } catch (error: any) {
      functions.logger.error("Failed to complete user registration.", { error, email: userToActivate.email });
      if (authUserUid) {
        // Rollback Auth user creation if Firestore update fails
        await this.authService.deleteUser(authUserUid);
      }
      if (error instanceof HttpsError) throw error;
      throw new HttpsError("internal", "An unexpected error occurred during account activation.");
    }
  }

  async deactivateUser(userId: string, tenantId: string, adminId: string): Promise<void> {
    functions.logger.info(`Admin ${adminId} is deactivating user ${userId} in tenant ${tenantId}.`);

    const user = await this.userRepository.findById(userId);

    if (!user || user.tenantId !== tenantId) {
      throw new HttpsError("not-found", `User not found in this tenant.`);
    }

    if (user.role === "Supervisor") {
      const subordinates = await this.userRepository.findActiveSubordinates(userId, tenantId);
      if (subordinates.length > 0) {
        throw new HttpsError(
          "failed-precondition",
          "This supervisor has active subordinates. Please reassign them before deactivating."
        );
      }
    }

    await this.userRepository.update(userId, { status: "deactivated", deactivatedAt: new Date() });
    await this.authService.revokeRefreshTokens(userId);
    await this.authService.disableUser(userId);

    const auditLog = new AuditLog(
      "",
      adminId,
      "user.deactivate",
      userId,
      "User",
      `Admin deactivated user ${user.email}.`
    );
    await this.auditLogService.log(tenantId, auditLog);
  }

  async updateUserSupervisor(userId: string, newSupervisorId: string | null, tenantId: string, adminId: string): Promise<void> {
    functions.logger.info(
      `Admin ${adminId} is updating supervisor for user ${userId} to ${newSupervisorId || "none"}.`
    );

    const user = await this.userRepository.findById(userId);
    if (!user || user.tenantId !== tenantId) {
      throw new HttpsError("not-found", "User not found.");
    }

    if (newSupervisorId) {
      if (userId === newSupervisorId) {
        throw new HttpsError("invalid-argument", "A user cannot be their own supervisor.");
      }

      // Circular dependency check
      let currentSupervisorId: string | null = newSupervisorId;
      const MAX_DEPTH = 20; // Safety break for deep/infinite hierarchies
      for (let i = 0; i < MAX_DEPTH; i++) {
        if (!currentSupervisorId) break;
        if (currentSupervisorId === userId) {
          throw new HttpsError("invalid-argument", "This assignment would create a circular reporting structure.");
        }
        const supervisor = await this.userRepository.findById(currentSupervisorId);
        currentSupervisorId = supervisor?.supervisorId ?? null;
      }
    }

    await this.userRepository.update(userId, { supervisorId: newSupervisorId });

    const auditLog = new AuditLog(
      "",
      adminId,
      "user.update.supervisor",
      userId,
      "User",
      `Admin changed supervisor for user ${user.email}.`,
      { oldValue: user.supervisorId, newValue: newSupervisorId }
    );
    await this.auditLogService.log(tenantId, auditLog);
  }
}