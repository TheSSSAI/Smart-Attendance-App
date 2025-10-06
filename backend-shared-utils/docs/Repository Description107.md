# 1 Id

REPO-LIB-BACKEND-002

# 2 Name

backend-shared-utils

# 3 Description

A reusable library containing common utilities and cross-cutting concerns for all backend Cloud Functions. This component was extracted from the 'attendance-app-backend' to consolidate shared logic that would otherwise be duplicated across the new microservice repositories. It includes standardized modules for structured logging (wrapping Google Cloud Logging), error handling and reporting, context management (e.g., extracting tenantId and userId from request contexts), and clients for interacting with external services like Google Secret Manager. Its purpose is to provide a consistent operational foundation for all backend services, simplifying development and ensuring uniform logging and error handling practices across the board. It is intended to be a dependency for all backend service repositories.

# 4 Type

🔹 Utility Library

# 5 Namespace

com.attendance-app.backend.shared

# 6 Output Path

libs/backend-shared-utils

# 7 Framework

N/A

# 8 Language

TypeScript

# 9 Technology

Node.js, TypeScript

# 10 Thirdparty Libraries

- firebase-functions
- firebase-admin

# 11 Layer Ids

- cross-cutting-layer

# 12 Dependencies

- REPO-LIB-CORE-001

# 13 Requirements

- {'requirementId': 'REQ-1-076'}

# 14 Generate Tests

✅ Yes

# 15 Generate Documentation

✅ Yes

# 16 Architecture Style

N/A

# 17 Architecture Map

- monitoring-and-logging-011
- secret-manager-client-007

# 18 Components Map

*No items available*

# 19 Requirements Map

- REQ-1-076

# 20 Decomposition Rationale

## 20.1 Operation Type

NEW_DECOMPOSED

## 20.2 Source Repository

REPO-BACKEND-002

## 20.3 Decomposition Reasoning

Centralizes all cross-cutting concerns (logging, error handling) to ensure operational consistency across all microservices. This avoids code duplication and makes it easier to implement system-wide changes to these concerns.

## 20.4 Extracted Responsibilities

- Standardized structured logger.
- Centralized error handling and reporting logic.
- Firebase context utility functions.
- Wrapper for Google Secret Manager client.

## 20.5 Reusability Scope

- Consumed by every backend microservice repository.

## 20.6 Development Benefits

- Speeds up development by providing ready-to-use solutions for common tasks.
- Ensures consistent logging and monitoring, simplifying ops.

# 21.0 Dependency Contracts

*No data available*

# 22.0 Exposed Contracts

## 22.1 Public Interfaces

- {'interface': 'ILogger', 'methods': ['info(message: string, context: object)', 'error(message: string, error: Error, context: object)'], 'events': [], 'properties': [], 'consumers': ['REPO-SVC-IDENTITY-003', 'REPO-SVC-ATTENDANCE-004', 'REPO-SVC-TEAM-005', 'REPO-SVC-REPORTING-006']}

# 23.0 Integration Patterns

*No data available*

# 24.0 Technology Guidance

| Property | Value |
|----------|-------|
| Framework Specific | All functions should be pure and stateless, design... |
| Performance Considerations | Utilities should be lightweight to minimize cold s... |
| Security Considerations | Ensure secrets are never logged. |
| Testing Approach | 100% unit test coverage is required for this libra... |

# 25.0 Scope Boundaries

## 25.1 Must Implement

- A structured JSON logger.
- A universal error handler.

## 25.2 Must Not Implement

- Any business-domain-specific logic.

## 25.3 Extension Points

- New utility modules can be added as needed.

## 25.4 Validation Rules

*No items available*

