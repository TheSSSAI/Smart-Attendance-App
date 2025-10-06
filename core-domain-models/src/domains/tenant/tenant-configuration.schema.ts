import { z } from 'zod';

/**
 * @description Zod schema for the password policy configuration of a tenant.
 * Corresponds to requirements REQ-1-031 and user story US-073.
 */
const passwordPolicySchema = z
  .object({
    minLength: z.number().int().min(8, 'Minimum length cannot be less than 8.'),
    requireUppercase: z.boolean(),
    requireLowercase: z.boolean(),
    requireNumber: z.boolean(),
    requireSpecialChar: z.boolean(),
  })
  .strict();

/**
 * @description Zod schema for the default working hours configuration.
 * Corresponds to user story US-072.
 */
const workingHoursSchema = z
  .object({
    start: z.string().regex(/^([01]\d|2[0-3]):([0-5]\d)$/, 'Invalid start time format. Must be HH:mm.'),
    end: z.string().regex(/^([01]\d|2[0-3]):([0-5]\d)$/, 'Invalid end time format. Must be HH:mm.'),
    days: z.array(z.number().int().min(0).max(6)).min(1, 'At least one working day must be selected.'), // 0 = Sunday, 6 = Saturday
  })
  .strict();

/**
 * @description Zod schema for data retention periods.
 * Corresponds to user story US-074.
 */
const dataRetentionPeriodsSchema = z
  .object({
    attendanceRecordsInDays: z.number().int().positive('Retention period must be a positive number of days.'),
    auditLogsInDays: z.number().int().positive('Retention period must be a positive number of days.'),
  })
  .strict();

/**
 * @description A comprehensive Zod schema for all tenant-specific configuration settings.
 * This schema defines the structure and validation rules for the settings an Admin can
 * configure for their organization, as required by REQ-1-061 and related user stories.
 */
export const tenantConfigurationSchema = z
  .object({
    /**
     * The IANA timezone string for the tenant (e.g., 'America/New_York').
     * Required by REQ-1-061 and user story US-069.
     */
    timezone: z.string().nonempty('Timezone is required.'),

    /**
     * The time in HH:mm format for automatic check-outs.
     * Corresponds to user story US-070 and REQ-1-045. Optional.
     */
    autoCheckoutTime: z
      .string()
      .regex(/^([01]\d|2[0-3]):([0-5]\d)$/, 'Invalid time format. Must be HH:mm.')
      .optional(),

    /**
     * The number of days after which a pending approval is escalated.
     * Corresponds to user story US-071 and REQ-1-051. Must be a positive integer. Optional.
     */
    approvalEscalationPeriodInDays: z
      .number()
      .int('Escalation period must be a whole number of days.')
      .positive('Escalation period must be a positive number of days.')
      .optional(),

    /**
     * The default working hours for reporting purposes like late arrivals.
     * Corresponds to user story US-072. Optional.
     */
    defaultWorkingHours: workingHoursSchema.optional(),

    /**
     * The password complexity policy for users in the tenant.
     * Corresponds to user story US-073 and REQ-1-031. Optional.
     */
    passwordPolicy: passwordPolicySchema.optional(),

    /**
     * Data retention policies for different types of records.
     * Corresponds to user story US-074. Optional.
     */
    dataRetentionPeriods: dataRetentionPeriodsSchema.optional(),
  })
  .strict();

/**
 * @description The TypeScript type inferred from the `tenantConfigurationSchema`.
 * Provides static type safety for tenant configuration objects throughout the application.
 */
export type TenantConfiguration = z.infer<typeof tenantConfigurationSchema>;