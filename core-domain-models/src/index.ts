/**
 * @file This is the main entry point for the core-domain-models library.
 * It serves as a barrel file, re-exporting all public schemas and types
 * from the various domain modules. This provides a single, consolidated
 * API surface for all consuming backend services, simplifying imports
 * and ensuring a clear public contract for the library.
 *
 * This file should only contain export statements. No business logic
 * or other declarations are permitted here.
 *
 * @version 1.0.0
 * @since 1.0.0
 * @author Your Name <your.email@example.com>
 * @copyright [Year] Your Company
 * @license MIT
 */

// Export all shared schemas and types.
// These are foundational primitives and common types used across multiple domains.
export * from './domains/shared';

// Export all schemas and types related to the Tenant domain.
// This includes the core Tenant entity, its configuration, and integrations.
export * from './domains/tenant';

// Export all schemas and types related to the User domain.
// This includes the User entity, roles, and statuses.
export * from './domains/user';

// Export all schemas and types related to the Team domain.
// This defines the structure for organizational teams.
export * from './domains/team';

// Export all schemas and types related to the Attendance domain.
// This includes the core AttendanceRecord entity, its statuses, and flags.
export * from './domains/attendance';

// Export all schemas and types related to the Event domain.
// This defines the structure for calendar events and assignments.
export * from './domains/event';

// Export all schemas and types related to the Audit domain.
// This defines the structure for immutable audit log entries.
export * from './domains/audit';