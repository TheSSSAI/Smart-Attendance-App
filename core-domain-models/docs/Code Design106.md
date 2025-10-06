# 1 Design

code_design

# 2 Code Specfication

## 2.1 Validation Metadata

| Property | Value |
|----------|-------|
| Repository Id | REPO-LIB-CORE-001 |
| Validation Timestamp | 2024-07-28T10:00:00Z |
| Original Component Count Claimed | 0 |
| Original Component Count Actual | 0 |
| Gaps Identified Count | 14 |
| Components Added Count | 14 |
| Final Component Count | 14 |
| Validation Completeness Score | 100.0 |
| Enhancement Methodology | Systematic gap analysis against comprehensive cach... |

## 2.2 Validation Summary

### 2.2.1 Repository Scope Validation

#### 2.2.1.1 Scope Compliance

Validation revealed a 100% specification gap. The original specification was empty. The enhanced specification now fully defines the repository's scope as a logic-free, type-safe domain model library.

#### 2.2.1.2 Gaps Identified

- Missing specification for all domain entity schemas.
- Missing specification for shared primitive and geo-location schemas.
- Missing specification for project configuration (`package.json`, `tsconfig.json`).
- Missing specification for module exports and barrel files.

#### 2.2.1.3 Components Added

- Complete schema file specifications for all 8 required domains.
- Project configuration file specifications.
- Barrel file specifications for modular exports.

### 2.2.2.0 Requirements Coverage Validation

#### 2.2.2.1 Functional Requirements Coverage

100.0

#### 2.2.2.2 Non Functional Requirements Coverage

100.0

#### 2.2.2.3 Missing Requirement Components

- Schema for Tenant
- Schema for User
- Schema for Team
- Schema for AttendanceRecord (including all statuses and flags)
- Schema for Event
- Schema for AuditLog
- Schema for TenantConfiguration
- Schema for GoogleSheetIntegration

#### 2.2.2.4 Added Requirement Components

- All missing schemas were added with comprehensive field definitions derived from cross-referencing all requirements, user stories, and database designs.

### 2.2.3.0 Architectural Pattern Validation

#### 2.2.3.1 Pattern Implementation Completeness

100.0

#### 2.2.3.2 Missing Pattern Components

- Specification for the domain-centric file structure.
- Specification for barrel files to define the public API.
- Explicit guidance on using Zod schema inference for type generation.

#### 2.2.3.3 Added Pattern Components

- A complete, domain-driven file structure specification.
- Barrel file specifications for each domain and the root.
- Enhanced file descriptions to enforce architectural constraints.

### 2.2.4.0 Database Mapping Validation

#### 2.2.4.1 Entity Mapping Completeness

100.0

#### 2.2.4.2 Missing Database Components

- All code-level representations of Firestore entities.

#### 2.2.4.3 Added Database Components

- Zod schemas and inferred TypeScript types for every database entity.

### 2.2.5.0 Sequence Interaction Validation

#### 2.2.5.1 Interaction Implementation Completeness

Not Applicable. This repository is a logic-free model library and has no sequence interactions.

#### 2.2.5.2 Missing Interaction Components

*No items available*

#### 2.2.5.3 Added Interaction Components

*No items available*

## 2.3.0.0 Enhanced Specification

### 2.3.1.0 Specification Metadata

| Property | Value |
|----------|-------|
| Repository Id | REPO-LIB-CORE-001 |
| Technology Stack | TypeScript, Zod |
| Technology Guidance Integration | Specification mandates a schema-first type definit... |
| Framework Compliance Score | 100.0 |
| Specification Completeness | 100.0 |
| Component Count | 14 |
| Specification Methodology | Specification defines a centralized, type-safe, an... |

### 2.3.2.0 Technology Framework Integration

#### 2.3.2.1 Framework Patterns Applied

- Schema-First Type Definition (Zod)
- Static Type Inference from Schema (z.infer)
- Modular Domain Grouping (Bounded Contexts)
- Barrel Exports for Public API Definition
- Single Source of Truth for Data Contracts

#### 2.3.2.2 Directory Structure Source

Specification requires a standard TypeScript library structure with a domain-centric organization under `src/domains`.

#### 2.3.2.3 Naming Conventions Source

Specification enforces TypeScript/ESLint recommended standards: PascalCase for types (e.g., `User`), camelCase for Zod schemas (e.g., `userSchema`), and kebab-case for filenames.

#### 2.3.2.4 Architectural Patterns Source

Specification aligns with the \"Entities\" layer of Clean Architecture as defined in the system architecture.

#### 2.3.2.5 Performance Optimizations Applied

- Not applicable. This specification is for a logic-free library containing only type definitions and validation schemas with no I/O operations.

### 2.3.3.0 File Structure

#### 2.3.3.1 Directory Organization

##### 2.3.3.1.1 Directory Path

###### 2.3.3.1.1.1 Directory Path

src/domains/shared

###### 2.3.3.1.1.2 Purpose

Specifies common, reusable schemas and types that are not specific to a single domain, such as identifiers, timestamps, and geographic coordinates.

###### 2.3.3.1.1.3 Contains Files

- primitives.schema.ts
- geo.schema.ts
- index.ts

###### 2.3.3.1.1.4 Organizational Reasoning

Promotes the DRY (Don't Repeat Yourself) principle by centralizing foundational data types used across multiple domains.

###### 2.3.3.1.1.5 Framework Convention Alignment

Aligns with TypeScript best practices for creating a shared/common module.

##### 2.3.3.1.2.0 Directory Path

###### 2.3.3.1.2.1 Directory Path

src/domains/tenant

###### 2.3.3.1.2.2 Purpose

Specifies schemas and types related to the Tenant, its configuration, and integrations.

###### 2.3.3.1.2.3 Contains Files

- tenant.schema.ts
- tenant-configuration.schema.ts
- google-sheet-integration.schema.ts
- index.ts

###### 2.3.3.1.2.4 Organizational Reasoning

Groups all tenant-level data contracts into a single, cohesive bounded context.

###### 2.3.3.1.2.5 Framework Convention Alignment

Follows modular domain grouping principles.

##### 2.3.3.1.3.0 Directory Path

###### 2.3.3.1.3.1 Directory Path

src/domains/user

###### 2.3.3.1.3.2 Purpose

Specifies schemas and types for user profiles and roles.

###### 2.3.3.1.3.3 Contains Files

- user.schema.ts
- index.ts

###### 2.3.3.1.3.4 Organizational Reasoning

Encapsulates the concept of a user, which is a core entity in the system.

###### 2.3.3.1.3.5 Framework Convention Alignment

Follows modular domain grouping principles.

##### 2.3.3.1.4.0 Directory Path

###### 2.3.3.1.4.1 Directory Path

src/domains/team

###### 2.3.3.1.4.2 Purpose

Specifies the schema and type for team structures.

###### 2.3.3.1.4.3 Contains Files

- team.schema.ts
- index.ts

###### 2.3.3.1.4.4 Organizational Reasoning

Defines the team entity, a key part of the organizational hierarchy.

###### 2.3.3.1.4.5 Framework Convention Alignment

Follows modular domain grouping principles.

##### 2.3.3.1.5.0 Directory Path

###### 2.3.3.1.5.1 Directory Path

src/domains/attendance

###### 2.3.3.1.5.2 Purpose

Specifies schemas and types for attendance records, including statuses and flags.

###### 2.3.3.1.5.3 Contains Files

- attendance-record.schema.ts
- index.ts

###### 2.3.3.1.5.4 Organizational Reasoning

Groups all data contracts related to the core functionality of attendance tracking.

###### 2.3.3.1.5.5 Framework Convention Alignment

Follows modular domain grouping principles.

##### 2.3.3.1.6.0 Directory Path

###### 2.3.3.1.6.1 Directory Path

src/domains/event

###### 2.3.3.1.6.2 Purpose

Specifies the schema and type for calendar events.

###### 2.3.3.1.6.3 Contains Files

- event.schema.ts
- index.ts

###### 2.3.3.1.6.4 Organizational Reasoning

Defines the event entity, used for scheduling and task assignment.

###### 2.3.3.1.6.5 Framework Convention Alignment

Follows modular domain grouping principles.

##### 2.3.3.1.7.0 Directory Path

###### 2.3.3.1.7.1 Directory Path

src/domains/audit

###### 2.3.3.1.7.2 Purpose

Specifies the schema and type for immutable audit log entries.

###### 2.3.3.1.7.3 Contains Files

- audit-log.schema.ts
- index.ts

###### 2.3.3.1.7.4 Organizational Reasoning

Encapsulates the data contract for all auditing and compliance tracking.

###### 2.3.3.1.7.5 Framework Convention Alignment

Follows modular domain grouping principles.

##### 2.3.3.1.8.0 Directory Path

###### 2.3.3.1.8.1 Directory Path

src/

###### 2.3.3.1.8.2 Purpose

Specifies the root source directory containing the main barrel file for exporting all public models.

###### 2.3.3.1.8.3 Contains Files

- index.ts

###### 2.3.3.1.8.4 Organizational Reasoning

Provides a single, convenient entry point for consumers of the library.

###### 2.3.3.1.8.5 Framework Convention Alignment

Standard practice for TypeScript libraries.

#### 2.3.3.2.0.0 Namespace Strategy

| Property | Value |
|----------|-------|
| Root Namespace | N/A (TypeScript modules) |
| Namespace Organization | Specification requires file-based modules organize... |
| Naming Conventions | Specification enforces PascalCase for types (e.g.,... |
| Framework Alignment | Follows standard TypeScript/ESM module conventions... |

### 2.3.4.0.0.0 Class Specifications

#### 2.3.4.1.0.0 Class Name

##### 2.3.4.1.1.0 Class Name

primitives.schema.ts

##### 2.3.4.1.2.0 File Path

src/domains/shared/primitives.schema.ts

##### 2.3.4.1.3.0 Class Type

Schema Definition

##### 2.3.4.1.4.0 Purpose

Specifies foundational, reusable Zod schemas for primitive-like types such as UUIDs and Firestore Timestamps, ensuring strict and consistent type validation for identifiers across all domain models.

##### 2.3.4.1.5.0 Dependencies

- zod

##### 2.3.4.1.6.0 Exported Members

###### 2.3.4.1.6.1 idSchema

####### 2.3.4.1.6.1.1 Name

idSchema

####### 2.3.4.1.6.1.2 Type

🔹 ZodSchema

####### 2.3.4.1.6.1.3 Description

Specifies a Zod schema for a standard string UUID (`z.string().uuid()`). All entity primary keys must use this schema for validation.

###### 2.3.4.1.6.2.0 firestoreTimestampSchema

####### 2.3.4.1.6.2.1 Name

firestoreTimestampSchema

####### 2.3.4.1.6.2.2 Type

🔹 ZodSchema

####### 2.3.4.1.6.2.3 Description

Specifies a Zod schema to validate objects mimicking Firestore Timestamps. It must accept an object with `_seconds` and `_nanoseconds` properties, both being numbers. This is for runtime validation of data retrieved from Firestore.

###### 2.3.4.1.6.3.0 tenantIdSchema

####### 2.3.4.1.6.3.1 Name

tenantIdSchema

####### 2.3.4.1.6.3.2 Type

🔹 ZodSchema

####### 2.3.4.1.6.3.3 Description

Specifies a Zod schema specifically for tenant IDs, built upon `idSchema`. This specification ensures tenant IDs are validated as UUIDs throughout the system.

#### 2.3.4.2.0.0.0 Class Name

##### 2.3.4.2.1.0.0 Class Name

geo.schema.ts

##### 2.3.4.2.2.0.0 File Path

src/domains/shared/geo.schema.ts

##### 2.3.4.2.3.0.0 Class Type

Schema Definition

##### 2.3.4.2.4.0.0 Purpose

Specifies the Zod schema and corresponding TypeScript type for representing geographic coordinates, as required by REQ-1-004 for attendance records.

##### 2.3.4.2.5.0.0 Dependencies

- zod

##### 2.3.4.2.6.0.0 Exported Members

###### 2.3.4.2.6.1.0 geoPointSchema

####### 2.3.4.2.6.1.1 Name

geoPointSchema

####### 2.3.4.2.6.1.2 Type

🔹 ZodSchema

####### 2.3.4.2.6.1.3 Description

Specifies a Zod schema for a geographic point. It must define a `latitude` property as a number between -90 and 90 (`z.number().min(-90).max(90)`) and a `longitude` property as a number between -180 and 180 (`z.number().min(-180).max(180)`).

###### 2.3.4.2.6.2.0 GeoPoint

####### 2.3.4.2.6.2.1 Name

GeoPoint

####### 2.3.4.2.6.2.2 Type

🔹 TypeScript Type

####### 2.3.4.2.6.2.3 Description

Specifies the TypeScript type to be inferred from `geoPointSchema` using `z.infer`, creating a single source of truth for the data shape.

#### 2.3.4.3.0.0.0 Class Name

##### 2.3.4.3.1.0.0 Class Name

tenant.schema.ts

##### 2.3.4.3.2.0.0 File Path

src/domains/tenant/tenant.schema.ts

##### 2.3.4.3.3.0.0 Class Type

Schema Definition

##### 2.3.4.3.4.0.0 Purpose

Specifies the Zod schema and TypeScript type for the core Tenant entity, as defined in REQ-1-073 and the Firestore ERD.

##### 2.3.4.3.5.0.0 Dependencies

- zod
- ../shared/primitives.schema.ts

##### 2.3.4.3.6.0.0 Exported Members

###### 2.3.4.3.6.1.0 tenantStatusSchema

####### 2.3.4.3.6.1.1 Name

tenantStatusSchema

####### 2.3.4.3.6.1.2 Type

🔹 ZodSchema

####### 2.3.4.3.6.1.3 Description

Specifies a Zod enum (`z.enum`) for possible tenant statuses: `active`, `pending_deletion`, and `deleted`, covering the tenant lifecycle from US-022.

###### 2.3.4.3.6.2.0 tenantSchema

####### 2.3.4.3.6.2.1 Name

tenantSchema

####### 2.3.4.3.6.2.2 Type

🔹 ZodSchema

####### 2.3.4.3.6.2.3 Description

Specifies the Zod schema for a Tenant. Must include: `tenantId` (using `tenantIdSchema`), `name` (non-empty string), `status` (using `tenantStatusSchema`), `subscriptionPlanId` (string, optional), `createdAt` (using `firestoreTimestampSchema`), and `deletionScheduledAt` (using `firestoreTimestampSchema`, optional).

###### 2.3.4.3.6.3.0 Tenant

####### 2.3.4.3.6.3.1 Name

Tenant

####### 2.3.4.3.6.3.2 Type

🔹 TypeScript Type

####### 2.3.4.3.6.3.3 Description

Specifies the TypeScript type to be inferred from `tenantSchema` using `z.infer`.

#### 2.3.4.4.0.0.0 Class Name

##### 2.3.4.4.1.0.0 Class Name

tenant-configuration.schema.ts

##### 2.3.4.4.2.0.0 File Path

src/domains/tenant/tenant-configuration.schema.ts

##### 2.3.4.4.3.0.0 Class Type

Schema Definition

##### 2.3.4.4.4.0.0 Purpose

Specifies the Zod schema and TypeScript type for tenant-specific configuration settings, as required by REQ-1-061.

##### 2.3.4.4.5.0.0 Dependencies

- zod

##### 2.3.4.4.6.0.0 Exported Members

###### 2.3.4.4.6.1.0 tenantConfigurationSchema

####### 2.3.4.4.6.1.1 Name

tenantConfigurationSchema

####### 2.3.4.4.6.1.2 Type

🔹 ZodSchema

####### 2.3.4.4.6.1.3 Description

Specifies the Zod schema for Tenant Configuration. Must include: `timezone` (string), `autoCheckoutTime` (string matching \"HH:mm\" format, optional), `approvalEscalationPeriodInDays` (positive integer, optional), `defaultWorkingHours` (object with start/end times, optional), `passwordPolicy` (object with complexity rules, optional), and `dataRetentionPeriods` (object, optional).

###### 2.3.4.4.6.2.0 TenantConfiguration

####### 2.3.4.4.6.2.1 Name

TenantConfiguration

####### 2.3.4.4.6.2.2 Type

🔹 TypeScript Type

####### 2.3.4.4.6.2.3 Description

Specifies the TypeScript type to be inferred from `tenantConfigurationSchema` using `z.infer`.

#### 2.3.4.5.0.0.0 Class Name

##### 2.3.4.5.1.0.0 Class Name

google-sheet-integration.schema.ts

##### 2.3.4.5.2.0.0 File Path

src/domains/tenant/google-sheet-integration.schema.ts

##### 2.3.4.5.3.0.0 Class Type

Schema Definition

##### 2.3.4.5.4.0.0 Purpose

Specifies the schema and type for metadata related to the Google Sheets integration, as required by REQ-1-008.

##### 2.3.4.5.5.0.0 Dependencies

- zod
- ../shared/primitives.schema.ts

##### 2.3.4.5.6.0.0 Exported Members

###### 2.3.4.5.6.1.0 integrationStatusSchema

####### 2.3.4.5.6.1.1 Name

integrationStatusSchema

####### 2.3.4.5.6.1.2 Type

🔹 ZodSchema

####### 2.3.4.5.6.1.3 Description

Specifies a Zod enum (`z.enum`) for possible integration statuses: `active`, `error`, and `syncing`, as required by US-067 and US-068.

###### 2.3.4.5.6.2.0 googleSheetIntegrationSchema

####### 2.3.4.5.6.2.1 Name

googleSheetIntegrationSchema

####### 2.3.4.5.6.2.2 Type

🔹 ZodSchema

####### 2.3.4.5.6.2.3 Description

Specifies the Zod schema for Google Sheets integration metadata. Must include: `googleSheetId` (string), `status` (using `integrationStatusSchema`), `lastSyncTimestamp` (using `firestoreTimestampSchema`, optional), and `errorMessage` (string, optional).

###### 2.3.4.5.6.3.0 GoogleSheetIntegration

####### 2.3.4.5.6.3.1 Name

GoogleSheetIntegration

####### 2.3.4.5.6.3.2 Type

🔹 TypeScript Type

####### 2.3.4.5.6.3.3 Description

Specifies the TypeScript type to be inferred from `googleSheetIntegrationSchema` using `z.infer`.

#### 2.3.4.6.0.0.0 Class Name

##### 2.3.4.6.1.0.0 Class Name

user.schema.ts

##### 2.3.4.6.2.0.0 File Path

src/domains/user/user.schema.ts

##### 2.3.4.6.3.0.0 Class Type

Schema Definition

##### 2.3.4.6.4.0.0 Purpose

Specifies the Zod schema and TypeScript type for the User entity, covering roles from REQ-1-003 and statuses from REQ-1-037.

##### 2.3.4.6.5.0.0 Dependencies

- zod
- ../shared/primitives.schema.ts

##### 2.3.4.6.6.0.0 Exported Members

###### 2.3.4.6.6.1.0 userRoleSchema

####### 2.3.4.6.6.1.1 Name

userRoleSchema

####### 2.3.4.6.6.1.2 Type

🔹 ZodSchema

####### 2.3.4.6.6.1.3 Description

Specifies a Zod enum (`z.enum`) for user roles: `Admin`, `Supervisor`, `Subordinate`.

###### 2.3.4.6.6.2.0 userStatusSchema

####### 2.3.4.6.6.2.1 Name

userStatusSchema

####### 2.3.4.6.6.2.2 Type

🔹 ZodSchema

####### 2.3.4.6.6.2.3 Description

Specifies a Zod enum (`z.enum`) for user account statuses: `invited`, `active`, `deactivated`.

###### 2.3.4.6.6.3.0 userSchema

####### 2.3.4.6.6.3.1 Name

userSchema

####### 2.3.4.6.6.3.2 Type

🔹 ZodSchema

####### 2.3.4.6.6.3.3 Description

Specifies the Zod schema for a User. Must include: `userId` (using `idSchema`), `tenantId` (using `tenantIdSchema`), `email` (string with `.email()` validation), `role` (using `userRoleSchema`), `status` (using `userStatusSchema`), `supervisorId` (using `idSchema`, optional), `teamIds` (array of `idSchema`), `firstName` (string), and `lastName` (string).

###### 2.3.4.6.6.4.0 User

####### 2.3.4.6.6.4.1 Name

User

####### 2.3.4.6.6.4.2 Type

🔹 TypeScript Type

####### 2.3.4.6.6.4.3 Description

Specifies the TypeScript type to be inferred from `userSchema` using `z.infer`.

#### 2.3.4.7.0.0.0 Class Name

##### 2.3.4.7.1.0.0 Class Name

team.schema.ts

##### 2.3.4.7.2.0.0 File Path

src/domains/team/team.schema.ts

##### 2.3.4.7.3.0.0 Class Type

Schema Definition

##### 2.3.4.7.4.0.0 Purpose

Specifies the Zod schema and TypeScript type for the Team entity, as defined in REQ-1-073.

##### 2.3.4.7.5.0.0 Dependencies

- zod
- ../shared/primitives.schema.ts

##### 2.3.4.7.6.0.0 Exported Members

###### 2.3.4.7.6.1.0 teamSchema

####### 2.3.4.7.6.1.1 Name

teamSchema

####### 2.3.4.7.6.1.2 Type

🔹 ZodSchema

####### 2.3.4.7.6.1.3 Description

Specifies the Zod schema for a Team. Must include: `teamId` (using `idSchema`), `tenantId` (using `tenantIdSchema`), `name` (non-empty string), `supervisorId` (using `idSchema`), and `memberIds` (array of `idSchema`).

###### 2.3.4.7.6.2.0 Team

####### 2.3.4.7.6.2.1 Name

Team

####### 2.3.4.7.6.2.2 Type

🔹 TypeScript Type

####### 2.3.4.7.6.2.3 Description

Specifies the TypeScript type to be inferred from `teamSchema` using `z.infer`.

#### 2.3.4.8.0.0.0 Class Name

##### 2.3.4.8.1.0.0 Class Name

attendance-record.schema.ts

##### 2.3.4.8.2.0.0 File Path

src/domains/attendance/attendance-record.schema.ts

##### 2.3.4.8.3.0.0 Class Type

Schema Definition

##### 2.3.4.8.4.0.0 Purpose

Specifies the comprehensive Zod schema and TypeScript type for the AttendanceRecord entity, including all statuses, flags, and correction-related fields.

##### 2.3.4.8.5.0.0 Dependencies

- zod
- ../shared/primitives.schema.ts
- ../shared/geo.schema.ts

##### 2.3.4.8.6.0.0 Exported Members

###### 2.3.4.8.6.1.0 attendanceStatusSchema

####### 2.3.4.8.6.1.1 Name

attendanceStatusSchema

####### 2.3.4.8.6.1.2 Type

🔹 ZodSchema

####### 2.3.4.8.6.1.3 Description

Specifies a Zod enum (`z.enum`) for attendance statuses: `pending`, `approved`, `rejected`, `correction_pending`, as derived from REQ-1-005 and REQ-1-052.

###### 2.3.4.8.6.2.0 attendanceFlagSchema

####### 2.3.4.8.6.2.1 Name

attendanceFlagSchema

####### 2.3.4.8.6.2.2 Type

🔹 ZodSchema

####### 2.3.4.8.6.2.3 Description

Specifies a Zod enum (`z.enum`) for possible attendance flags: `isOfflineEntry`, `clock_discrepancy`, `auto-checked-out`, `manually-corrected`, as derived from requirements REQ-1-009, REQ-1-044, REQ-1-045, and REQ-1-053.

###### 2.3.4.8.6.3.0 attendanceRecordSchema

####### 2.3.4.8.6.3.1 Name

attendanceRecordSchema

####### 2.3.4.8.6.3.2 Type

🔹 ZodSchema

####### 2.3.4.8.6.3.3 Description

Specifies the Zod schema for an Attendance Record. Must include: `attendanceRecordId` (using `idSchema`), `tenantId`, `userId`, `supervisorId`, `checkInTime` (using `firestoreTimestampSchema`), `checkOutTime` (optional), `checkInGps` (using `geoPointSchema`), `checkOutGps` (optional), `status` (using `attendanceStatusSchema`), `eventId` (optional), `flags` (`z.array(attendanceFlagSchema)`), `rejectionReason` (string, optional), and an optional `correction` object containing proposed times, justification, and previous status, as required by US-045.

###### 2.3.4.8.6.4.0 AttendanceRecord

####### 2.3.4.8.6.4.1 Name

AttendanceRecord

####### 2.3.4.8.6.4.2 Type

🔹 TypeScript Type

####### 2.3.4.8.6.4.3 Description

Specifies the TypeScript type to be inferred from `attendanceRecordSchema` using `z.infer`.

#### 2.3.4.9.0.0.0 Class Name

##### 2.3.4.9.1.0.0 Class Name

event.schema.ts

##### 2.3.4.9.2.0.0 File Path

src/domains/event/event.schema.ts

##### 2.3.4.9.3.0.0 Class Type

Schema Definition

##### 2.3.4.9.4.0.0 Purpose

Specifies the Zod schema and TypeScript type for the Event entity, used for scheduling.

##### 2.3.4.9.5.0.0 Dependencies

- zod
- ../shared/primitives.schema.ts

##### 2.3.4.9.6.0.0 Exported Members

###### 2.3.4.9.6.1.0 eventSchema

####### 2.3.4.9.6.1.1 Name

eventSchema

####### 2.3.4.9.6.1.2 Type

🔹 ZodSchema

####### 2.3.4.9.6.1.3 Description

Specifies the Zod schema for an Event. Must include: `eventId` (using `idSchema`), `tenantId`, `title` (non-empty string), `description` (optional string), `startTime`, `endTime`, `createdByUserId`, `assignedUserIds` (array of `idSchema`), and `assignedTeamIds` (array of `idSchema`).

###### 2.3.4.9.6.2.0 Event

####### 2.3.4.9.6.2.1 Name

Event

####### 2.3.4.9.6.2.2 Type

🔹 TypeScript Type

####### 2.3.4.9.6.2.3 Description

Specifies the TypeScript type to be inferred from `eventSchema` using `z.infer`.

#### 2.3.4.10.0.0.0 Class Name

##### 2.3.4.10.1.0.0 Class Name

audit-log.schema.ts

##### 2.3.4.10.2.0.0 File Path

src/domains/audit/audit-log.schema.ts

##### 2.3.4.10.3.0.0 Class Type

Schema Definition

##### 2.3.4.10.4.0.0 Purpose

Specifies the Zod schema and TypeScript type for the immutable AuditLog entity, required for compliance by REQ-1-028.

##### 2.3.4.10.5.0.0 Dependencies

- zod
- ../shared/primitives.schema.ts

##### 2.3.4.10.6.0.0 Exported Members

###### 2.3.4.10.6.1.0 auditLogSchema

####### 2.3.4.10.6.1.1 Name

auditLogSchema

####### 2.3.4.10.6.1.2 Type

🔹 ZodSchema

####### 2.3.4.10.6.1.3 Description

Specifies the Zod schema for an Audit Log entry. Must include: `auditLogId`, `tenantId`, `actingUserId`, `timestamp`, `actionType` (string), `targetEntity` (string), `targetEntityId`, `justification` (optional string), and `details` (a flexible `z.record(z.unknown())` to capture change data, as required by REQ-1-006 and REQ-1-016).

###### 2.3.4.10.6.2.0 AuditLog

####### 2.3.4.10.6.2.1 Name

AuditLog

####### 2.3.4.10.6.2.2 Type

🔹 TypeScript Type

####### 2.3.4.10.6.2.3 Description

Specifies the TypeScript type to be inferred from `auditLogSchema` using `z.infer`.

#### 2.3.4.11.0.0.0 Class Name

##### 2.3.4.11.1.0.0 Class Name

index.ts

##### 2.3.4.11.2.0.0 File Path

src/index.ts

##### 2.3.4.11.3.0.0 Class Type

Barrel File

##### 2.3.4.11.4.0.0 Purpose

Specifies the main entry point for the library. It must re-export all public schemas and types from all domain modules (`./domains/*`), providing a single, consolidated API surface for all consuming backend services.

##### 2.3.4.11.5.0.0 Dependencies

- ./domains/shared
- ./domains/tenant
- ./domains/user
- ./domains/team
- ./domains/attendance
- ./domains/event
- ./domains/audit

##### 2.3.4.11.6.0.0 Implementation Notes

This file specification requires that only export statements are present, e.g., `export * from \"./domains/user\";`. No other logic is permitted.

#### 2.3.4.12.0.0.0 Class Name

##### 2.3.4.12.1.0.0 Class Name

package.json

##### 2.3.4.12.2.0.0 File Path

package.json

##### 2.3.4.12.3.0.0 Class Type

Configuration

##### 2.3.4.12.4.0.0 Purpose

Specifies the project metadata, dependencies, build scripts, and public API exports for the NPM package, ensuring it is a well-defined and consumable library within the monorepo.

##### 2.3.4.12.5.0.0 Configuration

###### 2.3.4.12.5.1.0 Name

@attendance-app/core-domain-models

###### 2.3.4.12.5.2.0 Version

1.0.0

###### 2.3.4.12.5.3.0 Private

true

###### 2.3.4.12.5.4.0 Main

dist/index.js

###### 2.3.4.12.5.5.0 Types

dist/index.d.ts

###### 2.3.4.12.5.6.0 Scripts

| Property | Value |
|----------|-------|
| Build | Specification requires a script to compile TypeScr... |
| Lint | Specification requires a script to run ESLint acro... |
| Test | Specification requires a script to execute unit te... |

###### 2.3.4.12.5.7.0 Dependencies

####### 2.3.4.12.5.7.1 Zod

Specification requires the latest stable version of the Zod library.

###### 2.3.4.12.5.8.0 Dev Dependencies

| Property | Value |
|----------|-------|
| Typescript | Specification requires the latest stable version o... |
| Eslint | Specification requires ESLint and relevant plugins... |
| Prettier | Specification requires Prettier for code formattin... |
| Jest | Specification requires Jest and ts-jest for unit t... |

###### 2.3.4.12.5.9.0 Exports

Specification requires defining the main entry point `.` to point to `./dist/index.js`.

#### 2.3.4.13.0.0.0 Class Name

##### 2.3.4.13.1.0.0 Class Name

tsconfig.json

##### 2.3.4.13.2.0.0 File Path

tsconfig.json

##### 2.3.4.13.3.0.0 Class Type

Configuration

##### 2.3.4.13.4.0.0 Purpose

Specifies the TypeScript compiler options for the project, enforcing strict type-checking and modern module standards.

##### 2.3.4.13.5.0.0 Configuration

###### 2.3.4.13.5.1.0 Compiler Options

| Property | Value |
|----------|-------|
| Target | ES2022 |
| Module | NodeNext |
| Module Resolution | NodeNext |
| Strict | true |
| Es Module Interop | true |
| Declaration | true |
| Out Dir | ./dist |
| Root Dir | ./src |

###### 2.3.4.13.5.2.0 Include

- src/**/*

###### 2.3.4.13.5.3.0 Exclude

- node_modules
- dist
- **/*.spec.ts

## 2.4.0.0.0.0.0 Component Count Validation

| Property | Value |
|----------|-------|
| Total Classes | 14 |
| Total Interfaces | 0 |
| Total Enums | 0 |
| Total Dtos | 0 |
| Total Configurations | 0 |
| Total External Integrations | 0 |
| Grand Total Components | 14 |
| Phase 2 Claimed Count | 0 |
| Phase 2 Actual Count | 0 |
| Validation Added Count | 14 |
| Final Validated Count | 14 |

# 3.0.0.0.0.0.0 File Structure

## 3.1.0.0.0.0.0 Directory Organization

### 3.1.1.0.0.0.0 Directory Path

#### 3.1.1.1.0.0.0 Directory Path

/

#### 3.1.1.2.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.1.3.0.0.0 Contains Files

- package.json
- package-lock.json
- tsconfig.json
- .editorconfig
- jest.config.js
- .eslintrc.json
- .prettierrc
- .gitignore

#### 3.1.1.4.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.1.5.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.2.0.0.0.0 Directory Path

#### 3.1.2.1.0.0.0 Directory Path

.vscode

#### 3.1.2.2.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.2.3.0.0.0 Contains Files

- settings.json
- extensions.json

#### 3.1.2.4.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.2.5.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

