import { z } from 'zod';

/**
 * @description A Zod schema for a standard string UUID.
 * This is the base schema for all unique identifiers in the system,
 * ensuring consistency and format validation for primary keys and foreign keys.
 * Corresponds to requirements for unique entity identification across the system.
 */
export const idSchema = z.string().uuid({ message: 'Invalid UUID format' });

/**
 * @description A Zod schema specifically for tenant identifiers.
 * While functionally identical to idSchema, it is exported separately for semantic clarity
 * and to enforce the concept of a Tenant ID throughout the domain models.
 * Directly supports the multi-tenancy architecture (REQ-1-002, REQ-1-021).
 */
export const tenantIdSchema = idSchema.describe(
  'A unique identifier for a tenant.',
);

/**
 * @description A Zod schema to validate objects that mimic Firestore's Timestamp class
 * when they are serialized (e.g., in Cloud Function triggers or API responses).
 * Firestore timestamps are objects with `_seconds` and `_nanoseconds` properties.
 * This ensures that timestamp data retrieved from the database can be validated at runtime.
 */
export const firestoreTimestampSchema = z.object(
  {
    _seconds: z.number().int(),
    _nanoseconds: z.number().int().gte(0).lt(1_000_000_000),
  },
  {
    description:
      "Represents a Firestore Timestamp object with '_seconds' and '_nanoseconds' properties.",
  },
);