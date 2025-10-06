# 1 Id

REPO-SVC-REPORTING-006

# 2 Name

reporting-export-services

# 3 Description

This microservice is responsible for the 'Reporting and Data Export' bounded context. Decomposed from the 'attendance-app-backend', its sole purpose is to handle asynchronous, data-intensive operations. This includes running scheduled batch jobs to export approved attendance records to Google Sheets, managing the OAuth credentials and error states for that integration, and potentially providing aggregated data for the Admin reporting dashboard. By isolating these heavy, non-interactive tasks, it prevents them from impacting the performance of the primary transactional services. This service is a prime example of separating concerns based on technical characteristics (batch vs. real-time) as well as business function.

# 4 Type

🔹 Application Services

# 5 Namespace

com.attendance-app.services.reporting

# 6 Output Path

services/reporting-export

# 7 Framework

Firebase Cloud Functions

# 8 Language

TypeScript

# 9 Technology

Cloud Functions, Cloud Scheduler, Google Sheets API

# 10 Thirdparty Libraries

- googleapis

# 11 Layer Ids

- application-services-layer

# 12 Dependencies

- REPO-LIB-CORE-001
- REPO-LIB-BACKEND-002

# 13 Requirements

## 13.1 Requirement Id

### 13.1.1 Requirement Id

REQ-FUN-012

## 13.2.0 Requirement Id

### 13.2.1 Requirement Id

REQ-FUN-013

## 13.3.0 Requirement Id

### 13.3.1 Requirement Id

REQ-REP-001

# 14.0.0 Generate Tests

✅ Yes

# 15.0.0 Generate Documentation

✅ Yes

# 16.0.0 Architecture Style

Serverless

# 17.0.0 Architecture Map

- scheduled-task-functions-009
- integration-clients-008

# 18.0.0 Components Map

*No items available*

# 19.0.0 Requirements Map

- REQ-FUN-012
- REQ-FUN-013
- REQ-REP-001

# 20.0.0 Decomposition Rationale

## 20.1.0 Operation Type

NEW_DECOMPOSED

## 20.2.0 Source Repository

REPO-BACKEND-002

## 20.3.0 Decomposition Reasoning

Isolates batch processing and third-party data integration (Google Sheets) from the real-time transactional services. This separation prevents long-running export jobs from consuming resources or affecting the performance of critical user-facing functions like check-in.

## 20.4.0 Extracted Responsibilities

- Scheduled export of attendance data to Google Sheets.
- Management of Google OAuth tokens and integration state.
- Error handling and recovery for the export process.
- Aggregation logic for admin dashboard reports.

## 20.5.0 Reusability Scope

- Domain-specific to this application.

## 20.6.0 Development Benefits

- Decouples the application from the potential instability of a third-party API.
- Allows data export and reporting features to be versioned and deployed independently.

# 21.0.0 Dependency Contracts

*No data available*

# 22.0.0 Exposed Contracts

## 22.1.0 Public Interfaces

- {'interface': 'Scheduled Handlers', 'methods': ['runGoogleSheetsExport()'], 'events': [], 'properties': [], 'consumers': ['Google Cloud Scheduler']}

# 23.0.0 Integration Patterns

| Property | Value |
|----------|-------|
| Dependency Injection | N/A |
| Event Communication | N/A - Primarily time-driven (scheduled). |
| Data Flow | Reads from the AttendanceRecord collection; writes... |
| Error Handling | Implements specific retry logic for API calls and ... |
| Async Patterns | Batch processing pattern. |

# 24.0.0 Technology Guidance

| Property | Value |
|----------|-------|
| Framework Specific | Use a scheduled Cloud Function with a long timeout... |
| Performance Considerations | Implement cursors or timestamp-based querying to o... |
| Security Considerations | Securely store and handle OAuth refresh tokens usi... |
| Testing Approach | Mock the Google Sheets API for integration tests. |

# 25.0.0 Scope Boundaries

## 25.1.0 Must Implement

- All logic related to exporting data and generating aggregated reports.

## 25.2.0 Must Not Implement

- Real-time attendance processing.
- User management.

## 25.3.0 Extension Points

- Can be extended to support other export destinations (e.g., CSV, other BI tools).

## 25.4.0 Validation Rules

- Validate target sheet schema before writing data.

