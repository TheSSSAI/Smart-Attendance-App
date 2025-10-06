# 1 Id

REPO-LIB-CORE-001

# 2 Name

core-domain-models

# 3 Description

This is a foundational, cross-cutting library that contains the TypeScript type definitions (interfaces) and data validation schemas (e.g., Zod schemas) for all core data entities within the system, such as User, Tenant, Team, AttendanceRecord, and Event. Extracted from the original 'attendance-app-backend', this repository serves as the single source of truth for the data contracts. It ensures that all backend services and the data migration tools operate on consistent, validated data structures. By centralizing the data models, it decouples the business logic in various microservices from the raw data structure, facilitating easier maintenance and evolution of the application's data schema. It has no business logic and is designed to be a lightweight, highly reusable NPM package dependency for all other backend repositories.

# 4 Type

🔹 Model Library

# 5 Namespace

com.attendance-app.core.domain

# 6 Output Path

libs/core-domain-models

# 7 Framework

N/A

# 8 Language

TypeScript

# 9 Technology

TypeScript, Zod

# 10 Thirdparty Libraries

- zod

# 11 Layer Ids

- domain-layer

# 12 Dependencies

*No items available*

# 13 Requirements

- {'requirementId': 'REQ-DAT-001'}

# 14 Generate Tests

✅ Yes

# 15 Generate Documentation

✅ Yes

# 16 Architecture Style

N/A

# 17 Architecture Map

- firestore-service-005

# 18 Components Map

*No items available*

# 19 Requirements Map

- REQ-DAT-001

# 20 Decomposition Rationale

## 20.1 Operation Type

NEW_DECOMPOSED

## 20.2 Source Repository

REPO-BACKEND-002

## 20.3 Decomposition Reasoning

Extracted to enforce the Don't Repeat Yourself (DRY) principle for data contracts across multiple backend microservices. It establishes a canonical data model, preventing inconsistencies and ensuring all parts of the backend operate on the same data shapes. This separation is critical for a microservice architecture to function reliably.

## 20.4 Extracted Responsibilities

- Canonical data entity definitions (TypeScript interfaces)
- Data validation schemas and logic

## 20.5 Reusability Scope

- Consumed by all backend microservice repositories.
- Used by any data migration or scripting tools.

## 20.6 Development Benefits

- Provides a single source of truth for the data model.
- Reduces code duplication and risk of contract drift between services.

# 21.0 Dependency Contracts

*No data available*

# 22.0 Exposed Contracts

## 22.1 Public Interfaces

- {'interface': 'IUser', 'methods': [], 'events': [], 'properties': ['userId: string', 'email: string', "role: 'Admin' | 'Supervisor' | 'Subordinate'"], 'consumers': ['REPO-SVC-IDENTITY-003', 'REPO-SVC-ATTENDANCE-004', 'REPO-SVC-TEAM-005', 'REPO-SVC-REPORTING-006']}

# 23.0 Integration Patterns

*No data available*

# 24.0 Technology Guidance

| Property | Value |
|----------|-------|
| Framework Specific | This library should remain logic-free and only con... |
| Performance Considerations | N/A |
| Security Considerations | Validation schemas must be comprehensive to protec... |
| Testing Approach | Unit test all validation schemas with valid and in... |

# 25.0 Scope Boundaries

## 25.1 Must Implement

- TypeScript interfaces for all Firestore collections.
- Zod schemas for data validation.

## 25.2 Must Not Implement

- Database access logic.
- Business rules or application logic.

## 25.3 Extension Points

- New entity models can be added as the system grows.

## 25.4 Validation Rules

- Enforce all constraints defined in REQ-DAT-001.

