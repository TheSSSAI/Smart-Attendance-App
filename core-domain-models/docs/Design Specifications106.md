# 1 Analysis Metadata

| Property | Value |
|----------|-------|
| Analysis Timestamp | 2023-10-27T10:00:00Z |
| Repository Component Id | core-domain-models |
| Analysis Completeness Score | 100 |
| Critical Findings Count | 0 |
| Analysis Methodology | Systematic analysis of cached context (requirement... |

# 2 Repository Analysis

## 2.1 Repository Definition

### 2.1.1 Scope Boundaries

- Defines TypeScript types and Zod schemas for all core domain entities (e.g., Tenant, User, Team, AttendanceRecord, Event, AuditLog).
- Acts as the single source of truth for data contracts across all backend services, ensuring type safety and runtime validation.
- Strictly excludes any business logic, database access, or framework-specific implementations. It is a pure data contract library.

### 2.1.2 Technology Stack

- TypeScript
- Zod

### 2.1.3 Architectural Constraints

- Must remain dependency-free of any application logic, database, or framework-specific libraries to comply with Clean Architecture principles.
- All models must be designed for efficient serialization/deserialization to support a serverless (Firebase Cloud Functions) environment.
- Schemas must be the primary source of truth, with TypeScript types inferred from them to eliminate drift between validation and static types.

### 2.1.4 Dependency Relationships

- {'dependency_type': 'Consumed By', 'target_component': 'All backend microservices (e.g., Application Services Layer)', 'integration_pattern': 'NPM Package Dependency (Compile-Time)', 'reasoning': 'This library provides the essential data contracts (types and validation schemas) that all backend services will import to handle data, validate API inputs/outputs, and interact with the persistence layer in a type-safe manner.'}

### 2.1.5 Analysis Insights

The 'core-domain-models' repository is the cornerstone of the system's data architecture, fulfilling the 'Entities' layer of Clean Architecture. Its schema-first design using Zod is optimal, ensuring runtime validation and static type safety are perfectly synchronized. This approach minimizes data integrity issues and significantly improves maintainability by centralizing all data contracts.

# 3.0.0 Requirements Mapping

## 3.1.0 Functional Requirements

### 3.1.1 Requirement Id

#### 3.1.1.1 Requirement Id

REQ-1-002

#### 3.1.1.2 Requirement Description

The system shall be architected as a multi-tenant platform with hierarchical organizational structures (Supervisor-to-Subordinate).

#### 3.1.1.3 Implementation Implications

- Requires 'Tenant' and 'User' entities.
- The 'User' model must include a self-referencing 'supervisorId' and a 'tenantId' to enforce multi-tenancy.

#### 3.1.1.4 Required Components

- UserSchema
- TenantSchema

#### 3.1.1.5 Analysis Reasoning

This core requirement directly defines the fundamental 'User' and 'Tenant' models and their relationship, which are central to the entire system's structure.

### 3.1.2.0 Requirement Id

#### 3.1.2.1 Requirement Id

REQ-1-003

#### 3.1.2.2 Requirement Description

The system shall implement a Role-Based Access Control (RBAC) model defining 'Admin', 'Supervisor', and 'Subordinate' roles.

#### 3.1.2.3 Implementation Implications

- The 'User' model must contain a 'role' property.
- A 'RoleEnum' schema should be defined to ensure type safety and restrict role values.

#### 3.1.2.4 Required Components

- UserSchema
- RoleEnumSchema

#### 3.1.2.5 Analysis Reasoning

This security requirement necessitates a 'role' attribute on the 'User' model, which will be used for authorization throughout the system.

### 3.1.3.0 Requirement Id

#### 3.1.3.1 Requirement Id

REQ-1-004

#### 3.1.3.2 Requirement Description

The system's mobile application shall allow users to mark attendance by 'check-in' and 'check-out', capturing precise GPS coordinates.

#### 3.1.3.3 Implementation Implications

- Requires an 'AttendanceRecord' entity.
- The model must include 'checkInTime', 'checkOutTime', 'checkInGps', and 'checkOutGps' properties.
- A reusable 'GpsCoordinatesSchema' should be created.

#### 3.1.3.4 Required Components

- AttendanceRecordSchema
- GpsCoordinatesSchema

#### 3.1.3.5 Analysis Reasoning

This requirement defines the primary data structure for the application's core feature, attendance tracking.

### 3.1.4.0 Requirement Id

#### 3.1.4.1 Requirement Id

REQ-1-006

#### 3.1.4.2 Requirement Description

The system shall provide a workflow for users to request corrections to their attendance records, with all stages immutably logged for auditing.

#### 3.1.4.3 Implementation Implications

- The 'AttendanceRecord' model needs fields for correction requests (e.g., 'requestedCheckInTime', 'correctionJustification') and a 'correction_pending' status.
- Requires an 'AuditLog' entity to store immutable records of changes, including old values, new values, and justification.

#### 3.1.4.4 Required Components

- AttendanceRecordSchema
- AuditLogSchema

#### 3.1.4.5 Analysis Reasoning

This requirement introduces complexity to the 'AttendanceRecord' state and explicitly necessitates the creation of the 'AuditLog' model for compliance and accountability.

### 3.1.5.0 Requirement Id

#### 3.1.5.1 Requirement Id

REQ-1-073

#### 3.1.5.2 Requirement Description

The system's data model in Firestore shall be structured with a root '/tenants/{tenantId}' collection and key sub-collections for users, teams, attendance, etc.

#### 3.1.5.3 Implementation Implications

- This requirement provides a blueprint for all major entities to be modeled.
- Confirms the need for 'Tenant', 'User', 'Team', 'AttendanceRecord', 'Event', 'AuditLog', 'TenantConfiguration', and 'GoogleSheetIntegration' models.

#### 3.1.5.4 Required Components

- All core domain schemas

#### 3.1.5.5 Analysis Reasoning

This technical requirement is a direct specification of the data model, serving as a primary source for defining the schemas in this repository.

## 3.2.0.0 Non Functional Requirements

### 3.2.1.0 Requirement Type

#### 3.2.1.1 Requirement Type

Security

#### 3.2.1.2 Requirement Specification

Enforce strict multi-tenant data segregation using Firestore Security Rules and 'tenantId' custom claims (REQ-1-021, REQ-1-064).

#### 3.2.1.3 Implementation Impact

All major domain models that store tenant-specific data must include a non-optional 'tenantId' field. This field will be crucial for writing security rules.

#### 3.2.1.4 Design Constraints

- The 'tenantId' property must be a required string (UUID or similar).
- Schemas for tenant-owned data must enforce the presence of 'tenantId'.

#### 3.2.1.5 Analysis Reasoning

This core security NFR directly translates into a data modeling constraint. The 'tenantId' field is the primary mechanism for data isolation, and its presence must be enforced at the schema level.

### 3.2.2.0 Requirement Type

#### 3.2.2.1 Requirement Type

Maintainability

#### 3.2.2.2 Requirement Specification

The Flutter application codebase must be structured following a clean architecture pattern to ensure separation of concerns (REQ-1-072).

#### 3.2.2.3 Implementation Impact

The existence of this separate 'core-domain-models' library is a direct implementation of this principle. The models must remain free of business logic and external dependencies.

#### 3.2.2.4 Design Constraints

- Models must only contain data properties and validation rules (via Zod).
- No dependencies on frameworks, databases, or UI libraries are permitted within this repository.

#### 3.2.2.5 Analysis Reasoning

This NFR justifies the architectural decision to create this repository, reinforcing its scope as the independent 'Entities' layer of the system.

## 3.3.0.0 Requirements Analysis Summary

The requirements provide a clear and consistent blueprint for the system's data models. Key entities such as Tenant, User, Team, and AttendanceRecord are well-defined through multiple functional requirements. Security and architectural NFRs reinforce the need for a multi-tenant design (via 'tenantId') and a clean separation of concerns, which this centralized model library directly addresses. All models will be derived from a combination of explicit requirements (like REQ-1-073) and the comprehensive database ERD.

# 4.0.0.0 Architecture Analysis

## 4.1.0.0 Architectural Patterns

### 4.1.1.0 Pattern Name

#### 4.1.1.1 Pattern Name

Clean Architecture

#### 4.1.1.2 Pattern Application

This repository embodies the innermost 'Entities' layer of Clean Architecture. It contains the application-independent data structures and validation rules.

#### 4.1.1.3 Required Components

- All domain model schemas

#### 4.1.1.4 Implementation Strategy

Implement as a standalone, framework-agnostic NPM package with zero dependencies on other application layers. Use TypeScript types and Zod schemas for pure data contract definitions.

#### 4.1.1.5 Analysis Reasoning

Centralizing domain models as specified in REQ-1-072 is a direct application of Clean Architecture, promoting separation of concerns, testability, and maintainability.

### 4.1.2.0 Pattern Name

#### 4.1.2.1 Pattern Name

Multi-Tenancy

#### 4.1.2.2 Pattern Application

The data models are designed to support logical data isolation for multiple tenants.

#### 4.1.2.3 Required Components

- TenantSchema
- UserSchema
- TeamSchema
- AttendanceRecordSchema
- EventSchema
- AuditLogSchema

#### 4.1.2.4 Implementation Strategy

Enforce the inclusion of a non-nullable 'tenantId' property on all schemas representing tenant-owned data, as confirmed by REQ-1-021 and the database ERD.

#### 4.1.2.5 Analysis Reasoning

The Multi-Tenancy pattern is a core architectural requirement (REQ-1-002). The inclusion of 'tenantId' in the domain models is the foundational step to enabling data segregation at the persistence and application layers.

## 4.2.0.0 Integration Points

- {'integration_type': 'Package Consumption', 'target_components': ['Application Services Layer (Backend Cloud Functions)', 'Data Migration Tools'], 'communication_pattern': 'Compile-Time Import', 'interface_requirements': ["The repository must expose a clear public API via its 'package.json' 'exports' field and root 'index.ts' barrel file.", 'All exported members must be Zod schemas and their inferred TypeScript types.'], 'analysis_reasoning': "This repository's primary purpose is to provide a shared, type-safe data contract for all backend services. The integration point is the consumption of this contract as a standard NPM package."}

## 4.3.0.0 Layering Strategy

| Property | Value |
|----------|-------|
| Layer Organization | This repository constitutes the central 'Domain Mo... |
| Component Placement | It is placed at the core of the architecture, with... |
| Analysis Reasoning | This layering strategy adheres strictly to the Cle... |

# 5.0.0.0 Database Analysis

## 5.1.0.0 Entity Mappings

### 5.1.1.0 Entity Name

#### 5.1.1.1 Entity Name

User

#### 5.1.1.2 Database Table

/tenants/{tenantId}/users/{userId}

#### 5.1.1.3 Required Properties

- 'userId': string (Firebase Auth UID)
- 'tenantId': string (FK to Tenant)
- 'email': string (unique within tenant)
- 'role': enum ('Admin', 'Supervisor', 'Subordinate')
- 'status': enum ('invited', 'active', 'deactivated')
- 'supervisorId': string (nullable, self-referencing)
- 'teamIds': array of strings

#### 5.1.1.4 Relationship Mappings

- Many-to-One with Tenant
- Many-to-One (self-referencing) with User (Supervisor)
- Many-to-Many with Team

#### 5.1.1.5 Access Patterns

- Queried by email for authentication.
- Queried by 'supervisorId' to find subordinates.
- Queried by 'teamIds' to find team members.

#### 5.1.1.6 Analysis Reasoning

The User model is central to RBAC and the organizational hierarchy. The properties are derived from REQ-1-002, REQ-1-003, and the ERD, supporting key application workflows.

### 5.1.2.0 Entity Name

#### 5.1.2.1 Entity Name

AttendanceRecord

#### 5.1.2.2 Database Table

/tenants/{tenantId}/attendance/{attendanceRecordId}

#### 5.1.2.3 Required Properties

- 'userId': string (FK to User)
- 'tenantId': string (FK to Tenant)
- 'supervisorId': string (denormalized FK to Supervisor)
- 'checkInTime': timestamp
- 'checkOutTime': nullable timestamp
- 'checkInGps': GpsCoordinates object
- 'checkOutGps': nullable GpsCoordinates object
- 'status': enum ('pending', 'approved', 'rejected', 'correction_pending')
- 'flags': array of strings (e.g., 'isOfflineEntry', 'clock_discrepancy')

#### 5.1.2.4 Relationship Mappings

- Many-to-One with User
- Many-to-One with Event (optional)

#### 5.1.2.5 Access Patterns

- Queried by 'userId' and date range for history.
- Queried by 'supervisorId' and 'status' for approval queues.

#### 5.1.2.6 Analysis Reasoning

This model captures the core attendance data as per REQ-1-004. It is denormalized with 'supervisorId' and 'tenantId' to support efficient, targeted queries required by the Supervisor and Admin roles, which is a best practice for Firestore.

### 5.1.3.0 Entity Name

#### 5.1.3.1 Entity Name

AuditLog

#### 5.1.3.2 Database Table

/tenants/{tenantId}/auditLog/{auditLogId}

#### 5.1.3.3 Required Properties

- 'actingUserId': string (FK to User)
- 'tenantId': string (FK to Tenant)
- 'actionType': string (e.g., 'user.deactivate', 'attendance.direct_edit')
- 'timestamp': server timestamp
- 'targetEntity': string (e.g., 'user', 'attendanceRecord')
- 'targetEntityId': string
- 'details': object (containing oldValue, newValue, justification, etc.)

#### 5.1.3.4 Relationship Mappings

- Logs actions performed by Users on other entities.

#### 5.1.3.5 Access Patterns

- Queried by 'actingUserId', 'targetEntityId', or date range for auditing purposes.

#### 5.1.3.6 Analysis Reasoning

The AuditLog model is designed to be a generic, immutable record of critical system events as required by REQ-1-006, REQ-1-016, and REQ-1-028. The flexible 'details' object allows it to capture context from various types of actions.

## 5.2.0.0 Data Access Requirements

### 5.2.1.0 Operation Type

#### 5.2.1.1 Operation Type

Validation

#### 5.2.1.2 Required Methods

- 'Schema.parse(data)': To validate incoming data (e.g., from an API request) and throw an error if it doesn't match the schema.
- 'Schema.safeParse(data)': To validate data and receive a result object containing either the data or an error, without throwing.

#### 5.2.1.3 Performance Constraints

Validation should be synchronous and have negligible performance impact.

#### 5.2.1.4 Analysis Reasoning

This repository's primary function is to provide schemas for runtime data validation. Zod's parsing methods are the core mechanism for this.

### 5.2.2.0 Operation Type

#### 5.2.2.1 Operation Type

Type Inference

#### 5.2.2.2 Required Methods

- 'z.infer<typeof Schema>': A TypeScript utility to extract the static type from a Zod schema.

#### 5.2.2.3 Performance Constraints

This is a compile-time operation with no runtime performance cost.

#### 5.2.2.4 Analysis Reasoning

The schema-first approach relies on inferring TypeScript types directly from the Zod schemas to ensure perfect alignment and eliminate manual type definition.

## 5.3.0.0 Persistence Strategy

| Property | Value |
|----------|-------|
| Orm Configuration | No ORM is used. This library provides schemas for ... |
| Migration Requirements | Schema evolution will be managed by versioning the... |
| Analysis Reasoning | The serverless architecture with direct Firestore ... |

# 6.0.0.0 Sequence Analysis

## 6.1.0.0 Interaction Patterns

### 6.1.1.0 Sequence Name

#### 6.1.1.1 Sequence Name

New Organization Registration (SEQ-265)

#### 6.1.1.2 Repository Role

Provides the data contracts for the registration payload and the resulting 'Tenant' and 'User' entities.

#### 6.1.1.3 Required Interfaces

- TenantSchema
- UserSchema
- RoleEnumSchema
- UserStatusEnumSchema

#### 6.1.1.4 Method Specifications

- {'method_name': 'TenantSchema.parse()', 'interaction_context': 'Used in the Cloud Function to validate the data before creating the tenant document.', 'parameter_analysis': "Receives an object containing 'name', 'tenantId', etc.", 'return_type_analysis': "Returns a fully typed 'Tenant' object or throws a ZodError.", 'analysis_reasoning': 'Ensures data integrity at the entry point of tenant creation.'}

#### 6.1.1.5 Analysis Reasoning

This sequence demonstrates the critical role of the model library in defining the contracts for the system's primary onboarding workflow.

### 6.1.2.0 Sequence Name

#### 6.1.2.1 Sequence Name

Attendance Correction Approval (SEQ-278)

#### 6.1.2.2 Repository Role

Provides schemas for validating the state transitions of 'AttendanceRecord' and for creating the 'AuditLog' entry.

#### 6.1.2.3 Required Interfaces

- AttendanceRecordSchema
- AttendanceStatusEnumSchema
- AuditLogSchema

#### 6.1.2.4 Method Specifications

- {'method_name': 'AuditLogSchema.parse()', 'interaction_context': 'Used in the Cloud Function to construct and validate the audit log object before committing it to Firestore.', 'parameter_analysis': "Receives an object with 'actingUserId', 'actionType', 'details', etc.", 'return_type_analysis': "Returns a fully typed 'AuditLog' object.", 'analysis_reasoning': 'Guarantees that all audit log entries conform to a strict, consistent schema, which is vital for compliance and reporting.'}

#### 6.1.2.5 Analysis Reasoning

This sequence shows how models are used to enforce data consistency during a complex, multi-document transactional update.

## 6.2.0.0 Communication Protocols

- {'protocol_type': 'N/A', 'implementation_requirements': 'This repository does not implement any runtime communication protocols. It is a compile-time library dependency.', 'analysis_reasoning': 'The role of this library is to define the data structures, not to transport them.'}

# 7.0.0.0 Critical Analysis Findings

- {'finding_category': 'Architectural Adherence', 'finding_description': "The repository's strict adherence to being a dependency-free model library is critical. Any introduction of business logic or external service dependencies (e.g., Firestore SDK) into this library would violate the Clean Architecture principles and compromise system maintainability.", 'implementation_impact': 'Developers must be disciplined to keep this library pure. All data manipulation and side effects must occur in the consuming services, not in the models themselves.', 'priority_level': 'High', 'analysis_reasoning': 'This is a foundational principle for the entire backend architecture. Deviating from it would create tight coupling and undermine the benefits of the chosen patterns.'}

# 8.0.0.0 Analysis Traceability

## 8.1.0.0 Cached Context Utilization

Analysis was performed by systematically processing all provided context artifacts. Requirements were scanned to identify entities and properties. Database ERDs (ID 53, 54) were used as the primary structural blueprint. The Architecture specification confirmed the repository's role. Sequence diagrams validated the data flow and the use of these models as contracts between services.

## 8.2.0.0 Analysis Decision Trail

- Decision: Adopt a 'schema-first' approach using Zod. Reasoning: This eliminates code duplication and ensures runtime validation is always synchronized with static TypeScript types.
- Decision: Structure models into domain-specific folders ('src/domains'). Reasoning: This aligns with domain-driven design principles, improving clarity and maintainability as the system grows.
- Decision: Enforce 'tenantId' on all tenant-owned data models. Reasoning: Directly implements the multi-tenancy requirement (REQ-1-002, REQ-1-021) and is essential for data security.

## 8.3.0.0 Assumption Validations

- Assumption: The provided ERDs accurately represent the desired Firestore schema. This was validated against functional requirements like REQ-1-073, which confirmed the collection structure.
- Assumption: TypeScript and Zod are the definitive technologies. This was confirmed by the repository's description in the cached context.

## 8.4.0.0 Cross Reference Checks

- Verified that every entity in the Database ERD has a corresponding model definition.
- Cross-referenced properties identified in functional requirements against the ERD to ensure completeness (e.g., adding 'flags' array to 'AttendanceRecord' based on REQ-1-044/045).
- Checked that data objects used in Sequence Diagrams have corresponding schemas defined.

