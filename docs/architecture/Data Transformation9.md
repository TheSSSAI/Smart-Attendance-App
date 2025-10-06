# 1 System Overview

## 1.1 Analysis Date

2025-06-13

## 1.2 Technology Stack

- Flutter
- Firebase (Firestore, Cloud Functions)
- TypeScript
- Google Sheets API
- SendGrid API

## 1.3 Service Interfaces

- Firestore API
- Google Cloud Functions Triggers (Auth, Firestore, Scheduler)
- Google Sheets API
- SendGrid API

## 1.4 Data Models

- Tenant
- User
- AttendanceRecord
- Team
- Event
- AuditLog
- DailyUserSummary

# 2.0 Data Mapping Strategy

## 2.1 Essential Mappings

### 2.1.1 Mapping Id

#### 2.1.1.1 Mapping Id

MAPPING-001

#### 2.1.1.2 Source

Firestore Document (Map)

#### 2.1.1.3 Target

Domain Entity (Dart/TypeScript Class)

#### 2.1.1.4 Transformation

nested

#### 2.1.1.5 Configuration

*No data available*

#### 2.1.1.6 Mapping Technique

Object-Constructor/Factory mapping

#### 2.1.1.7 Justification

Core requirement for the Clean Architecture (REQ-1-072) to decouple business logic from the Firestore data structure.

#### 2.1.1.8 Complexity

medium

### 2.1.2.0 Mapping Id

#### 2.1.2.1 Mapping Id

MAPPING-002

#### 2.1.2.2 Source

CSV Row (Array of Strings)

#### 2.1.2.3 Target

Firestore User and Team Documents

#### 2.1.2.4 Transformation

direct

#### 2.1.2.5 Configuration

##### 2.1.2.5.1 Csv Headers

- firstName
- lastName
- email
- role
- teamName
- supervisorEmail

#### 2.1.2.6.0 Mapping Technique

Positional or header-based mapping

#### 2.1.2.7.0 Justification

Required for the Admin data import tool to onboard new tenants (REQ-1-077).

#### 2.1.2.8.0 Complexity

medium

### 2.1.3.0.0 Mapping Id

#### 2.1.3.1.0 Mapping Id

MAPPING-003

#### 2.1.3.2.0 Source

Firestore AttendanceRecord

#### 2.1.3.3.0 Target

Google Sheet Row

#### 2.1.3.4.0 Transformation

flattened

#### 2.1.3.5.0 Configuration

##### 2.1.3.5.1 Target Columns

- Record ID
- User Name
- User Email
- Check-In Time
- Check-In GPS Latitude
- Check-In GPS Longitude
- Check-Out Time
- Check-Out GPS Latitude
- Check-Out GPS Longitude
- Status
- Notes

#### 2.1.3.6.0 Mapping Technique

Field-to-column mapping

#### 2.1.3.7.0 Justification

Core requirement for the automated data export feature (REQ-1-059).

#### 2.1.3.8.0 Complexity

simple

### 2.1.4.0.0 Mapping Id

#### 2.1.4.1.0 Mapping Id

MAPPING-004

#### 2.1.4.2.0 Source

User Document (PII fields)

#### 2.1.4.3.0 Target

Anonymized User Document

#### 2.1.4.4.0 Transformation

custom

#### 2.1.4.5.0 Configuration

##### 2.1.4.5.1 Fields To Anonymize

- firstName
- lastName
- email
- phoneNumber

##### 2.1.4.5.2 Replacement Value

ANONYMIZED_USER_12345

#### 2.1.4.6.0 Mapping Technique

Field replacement/hashing

#### 2.1.4.7.0 Justification

Required for the data retention policy for deactivated users (REQ-1-074).

#### 2.1.4.8.0 Complexity

medium

### 2.1.5.0.0 Mapping Id

#### 2.1.5.1.0 Mapping Id

MAPPING-005

#### 2.1.5.2.0 Source

Collection of AttendanceRecord documents

#### 2.1.5.3.0 Target

DailyUserSummary document

#### 2.1.5.4.0 Transformation

aggregation

#### 2.1.5.5.0 Configuration

##### 2.1.5.5.1 Group By

- userId
- date

##### 2.1.5.5.2 Aggregates

- SUM(totalHoursWorked)
- MIN(firstCheckIn)
- MAX(lastCheckOut)

#### 2.1.5.6.0 Mapping Technique

Batch aggregation query

#### 2.1.5.7.0 Justification

To populate the pre-aggregated DailyUserSummary table for efficient reporting, based on the DETABASE DESIGN.

#### 2.1.5.8.0 Complexity

complex

## 2.2.0.0.0 Object To Object Mappings

- {'sourceObject': 'Firestore AttendanceRecord Document', 'targetObject': 'Google Sheet Row', 'fieldMappings': [{'sourceField': 'attendanceRecordId', 'targetField': 'Record ID', 'transformation': 'Direct', 'dataTypeConversion': 'N/A'}, {'sourceField': 'userFullName', 'targetField': 'User Name', 'transformation': 'Direct', 'dataTypeConversion': 'N/A'}, {'sourceField': 'checkInTime', 'targetField': 'Check-In Time', 'transformation': 'Format as ISO 8601 String', 'dataTypeConversion': 'Firestore Timestamp to String'}, {'sourceField': 'checkInLatitude', 'targetField': 'Check-In GPS Latitude', 'transformation': 'Direct', 'dataTypeConversion': 'Decimal to String'}]}

## 2.3.0.0.0 Data Type Conversions

### 2.3.1.0.0 From

#### 2.3.1.1.0 From

Firestore Timestamp

#### 2.3.1.2.0 To

ISO 8601 String

#### 2.3.1.3.0 Conversion Method

toDate().toISOString()

#### 2.3.1.4.0 Validation Required

✅ Yes

### 2.3.2.0.0 From

#### 2.3.2.1.0 From

Firestore Geopoint/Decimal

#### 2.3.2.2.0 To

String

#### 2.3.2.3.0 Conversion Method

toString() with fixed precision

#### 2.3.2.4.0 Validation Required

❌ No

## 2.4.0.0.0 Bidirectional Mappings

*No items available*

# 3.0.0.0.0 Schema Validation Requirements

## 3.1.0.0.0 Field Level Validations

### 3.1.1.0.0 Field

#### 3.1.1.1.0 Field

User.email

#### 3.1.1.2.0 Rules

- required
- valid_email_format

#### 3.1.1.3.0 Priority

🚨 critical

#### 3.1.1.4.0 Error Message

A valid email address is required.

### 3.1.2.0.0 Field

#### 3.1.2.1.0 Field

User.password

#### 3.1.2.2.0 Rules

- required
- min_length:8
- contains_uppercase:1
- contains_lowercase:1
- contains_number:1
- contains_special_char:1

#### 3.1.2.3.0 Priority

🚨 critical

#### 3.1.2.4.0 Error Message

Password does not meet complexity requirements. (REQ-1-031)

### 3.1.3.0.0 Field

#### 3.1.3.1.0 Field

AttendanceCorrection.justification

#### 3.1.3.2.0 Rules

- required
- min_length:20

#### 3.1.3.3.0 Priority

🔴 high

#### 3.1.3.4.0 Error Message

A justification of at least 20 characters is required for manual edits. (REQ-1-030)

## 3.2.0.0.0 Cross Field Validations

- {'validationId': 'VALIDATE-EVENT-TIMES', 'fields': ['Event.startTime', 'Event.endTime'], 'rule': 'endTime must be after startTime', 'condition': 'Event.endTime is not null', 'errorHandling': 'Reject creation/update with specific error message.'}

## 3.3.0.0.0 Business Rule Validations

### 3.3.1.0.0 Rule Id

#### 3.3.1.1.0 Rule Id

RULE-UNIQUE-TENANT-NAME

#### 3.3.1.2.0 Description

Ensures that the chosen organization name is globally unique before creating the tenant.

#### 3.3.1.3.0 Fields

- Tenant.name

#### 3.3.1.4.0 Logic

Query the Tenant collection for an existing document with the same name.

#### 3.3.1.5.0 Priority

🚨 critical

### 3.3.2.0.0 Rule Id

#### 3.3.2.1.0 Rule Id

RULE-NO-CIRCULAR-HIERARCHY

#### 3.3.2.2.0 Description

Prevents a user from being their own supervisor, directly or indirectly.

#### 3.3.2.3.0 Fields

- User.supervisorId
- User.hierarchyPath

#### 3.3.2.4.0 Logic

Traverse the reporting chain upwards from the proposed new supervisor to ensure the user being modified is not in the path.

#### 3.3.2.5.0 Priority

🔴 high

## 3.4.0.0.0 Conditional Validations

- {'condition': 'Event.isRecurring is true', 'applicableFields': ['Event.recurrenceRule'], 'validationRules': ['required', 'valid_rrule_format']}

## 3.5.0.0.0 Validation Groups

- {'groupName': 'UserOnboardingCSV', 'validations': ['VALIDATE-CSV-HEADERS', 'VALIDATE-ROW-FIELD-TYPES', 'VALIDATE-ROW-BUSINESS-LOGIC'], 'executionOrder': 1, 'stopOnFirstFailure': False}

# 4.0.0.0.0 Transformation Pattern Evaluation

## 4.1.0.0.0 Selected Patterns

### 4.1.1.0.0 Pattern

#### 4.1.1.1.0 Pattern

adapter

#### 4.1.1.2.0 Use Case

Integrating with the Google Sheets API.

#### 4.1.1.3.0 Implementation

A TypeScript class in a Cloud Function that encapsulates API calls and transforms Firestore data into the format required by the Sheets API.

#### 4.1.1.4.0 Justification

Decouples the core business logic from the specifics of the external Google Sheets service.

### 4.1.2.0.0 Pattern

#### 4.1.2.1.0 Pattern

converter

#### 4.1.2.2.0 Use Case

Mapping between Firestore documents (Map<String, dynamic>) and strongly-typed Dart/TypeScript data models.

#### 4.1.2.3.0 Implementation

Factory constructors (`fromFirestore`) and instance methods (`toFirestore`) in data model classes.

#### 4.1.2.4.0 Justification

Essential for type safety and maintainability within a Clean Architecture.

### 4.1.3.0.0 Pattern

#### 4.1.3.1.0 Pattern

pipeline

#### 4.1.3.2.0 Use Case

Processing uploaded CSV files for user onboarding (REQ-1-077).

#### 4.1.3.3.0 Implementation

A Cloud Function triggered by a file upload to Cloud Storage, executing sequential steps: Parse CSV -> Validate Rows -> Transform to User/Team objects -> Batch write to Firestore -> Trigger Invitations.

#### 4.1.3.4.0 Justification

Provides a structured, manageable, and robust way to handle a multi-stage batch process.

## 4.2.0.0.0 Pipeline Processing

### 4.2.1.0.0 Required

✅ Yes

### 4.2.2.0.0 Stages

#### 4.2.2.1.0 Stage

##### 4.2.2.1.1 Stage

Parse

##### 4.2.2.1.2 Transformation

CSV to JSON array

##### 4.2.2.1.3 Dependencies

*No items available*

#### 4.2.2.2.0 Stage

##### 4.2.2.2.1 Stage

Validate

##### 4.2.2.2.2 Transformation

Apply business rules to each JSON object

##### 4.2.2.2.3 Dependencies

- Parse

#### 4.2.2.3.0 Stage

##### 4.2.2.3.1 Stage

Load

##### 4.2.2.3.2 Transformation

Batch write valid JSON objects to Firestore

##### 4.2.2.3.3 Dependencies

- Validate

### 4.2.3.0.0 Parallelization

❌ No

## 4.3.0.0.0 Processing Mode

### 4.3.1.0.0 Real Time

#### 4.3.1.1.0 Required

✅ Yes

#### 4.3.1.2.0 Scenarios

- Validating clock discrepancies on attendance record write (REQ-1-044).

#### 4.3.1.3.0 Latency Requirements

< 500ms

### 4.3.2.0.0 Batch

| Property | Value |
|----------|-------|
| Required | ✅ |
| Batch Size | 500 |
| Frequency | Daily or On-demand |

### 4.3.3.0.0 Streaming

| Property | Value |
|----------|-------|
| Required | ❌ |
| Streaming Framework | N/A |
| Windowing Strategy | N/A |

## 4.4.0.0.0 Canonical Data Model

### 4.4.1.0.0 Applicable

❌ No

### 4.4.2.0.0 Scope

*No items available*

### 4.4.3.0.0 Benefits

*No items available*

# 5.0.0.0.0 Version Handling Strategy

## 5.1.0.0.0 Schema Evolution

### 5.1.1.0.0 Strategy

Additive changes only

### 5.1.2.0.0 Versioning Scheme

Integer in document

### 5.1.3.0.0 Compatibility

| Property | Value |
|----------|-------|
| Backward | ✅ |
| Forward | ❌ |
| Reasoning | Consumers (client app, functions) must be tolerant... |

## 5.2.0.0.0 Transformation Versioning

| Property | Value |
|----------|-------|
| Mechanism | Versioned Cloud Functions |
| Version Identification | Deployment labels or function naming convention |
| Migration Strategy | Deploy new function version, update triggers, and ... |

## 5.3.0.0.0 Data Model Changes

| Property | Value |
|----------|-------|
| Migration Path | A dedicated, one-off Cloud Function will be writte... |
| Rollback Strategy | Restore from automated daily backup (REQ-1-071). |
| Validation Strategy | Run migration on staging environment first and ver... |

## 5.4.0.0.0 Schema Registry

| Property | Value |
|----------|-------|
| Required | ❌ |
| Technology | N/A |
| Governance | Schemas are managed implicitly within the TypeScri... |

# 6.0.0.0.0 Performance Optimization

## 6.1.0.0.0 Critical Requirements

### 6.1.1.0.0 Operation

#### 6.1.1.1.0 Operation

Attendance Check-in/out Sync

#### 6.1.1.2.0 Max Latency

500ms (p95)

#### 6.1.1.3.0 Throughput Target

N/A

#### 6.1.1.4.0 Justification

Core user interaction must feel responsive (REQ-1-067).

### 6.1.2.0.0 Operation

#### 6.1.2.1.0 Operation

Batch CSV Import

#### 6.1.2.2.0 Max Latency

540s (Cloud Function timeout)

#### 6.1.2.3.0 Throughput Target

1000 records per run

#### 6.1.2.4.0 Justification

Admin-facing tool must be able to handle reasonably sized imports without timing out.

## 6.2.0.0.0 Parallelization Opportunities

*No items available*

## 6.3.0.0.0 Caching Strategies

- {'cacheType': 'In-memory (client-side)', 'cacheScope': 'Per user session', 'evictionPolicy': 'Session end', 'applicableTransformations': ['TenantConfiguration mapping']}

## 6.4.0.0.0 Memory Optimization

### 6.4.1.0.0 Techniques

- Process CSV import row-by-row instead of loading the entire file into memory.

### 6.4.2.0.0 Thresholds

Default Cloud Function memory limits

### 6.4.3.0.0 Monitoring Required

✅ Yes

## 6.5.0.0.0 Lazy Evaluation

### 6.5.1.0.0 Applicable

❌ No

### 6.5.2.0.0 Scenarios

*No items available*

### 6.5.3.0.0 Implementation

N/A

## 6.6.0.0.0 Bulk Processing

### 6.6.1.0.0 Required

✅ Yes

### 6.6.2.0.0 Batch Sizes

#### 6.6.2.1.0 Optimal

500

#### 6.6.2.2.0 Maximum

500

### 6.6.3.0.0 Parallelism

1

# 7.0.0.0.0 Error Handling And Recovery

## 7.1.0.0.0 Error Handling Strategies

### 7.1.1.0.0 Error Type

#### 7.1.1.1.0 Error Type

CSV Row Validation Failure

#### 7.1.1.2.0 Strategy

Skip and Log

#### 7.1.1.3.0 Fallback Action

Continue processing the rest of the file and provide a summary of failed rows to the admin.

#### 7.1.1.4.0 Escalation Path

*No items available*

### 7.1.2.0.0 Error Type

#### 7.1.2.1.0 Error Type

Google Sheets API Permission Error

#### 7.1.2.2.0 Strategy

Fail Fast and Alert

#### 7.1.2.3.0 Fallback Action

Set integration status to 'error', halt the export, and notify the tenant Admin.

#### 7.1.2.4.0 Escalation Path

- Tenant Admin

## 7.2.0.0.0 Logging Requirements

### 7.2.1.0.0 Log Level

info

### 7.2.2.0.0 Included Data

- tenantId
- actingUserId
- sourceRecordId
- errorMessage
- stackTrace

### 7.2.3.0.0 Retention Period

30 days

### 7.2.4.0.0 Alerting

✅ Yes

## 7.3.0.0.0 Partial Success Handling

### 7.3.1.0.0 Strategy

Process valid data and report on invalid data.

### 7.3.2.0.0 Reporting Mechanism

A summary report/log generated at the end of the CSV import process.

### 7.3.3.0.0 Recovery Actions

- Admin corrects the failed rows in the CSV and re-uploads.

## 7.4.0.0.0 Circuit Breaking

- {'dependency': 'Google Sheets API', 'threshold': '5 consecutive failures', 'timeout': '10s', 'fallbackStrategy': 'Abort the batch job and retry on the next scheduled run (REQ-1-060).'}

## 7.5.0.0.0 Retry Strategies

- {'operation': 'Google Sheets Export (Batch)', 'maxRetries': 3, 'backoffStrategy': 'exponential', 'retryConditions': ['5xx API errors', 'Network timeouts']}

## 7.6.0.0.0 Error Notifications

- {'condition': 'Google Sheets export job fails after all retries.', 'recipients': ['Tenant Admin'], 'severity': 'high', 'channel': 'In-App/Web Dashboard Alert'}

# 8.0.0.0.0 Project Specific Transformations

## 8.1.0.0.0 CSV User and Team Import

### 8.1.1.0.0 Transformation Id

T-001

### 8.1.2.0.0 Name

CSV User and Team Import

### 8.1.3.0.0 Description

Transforms rows from an uploaded CSV file into User and Team documents in Firestore for tenant onboarding.

### 8.1.4.0.0 Source

#### 8.1.4.1.0 Service

Admin Web Dashboard (via Cloud Storage)

#### 8.1.4.2.0 Model

CSV File

#### 8.1.4.3.0 Fields

- firstName
- lastName
- email
- role
- teamName
- supervisorEmail

### 8.1.5.0.0 Target

#### 8.1.5.1.0 Service

Data & Persistence Layer

#### 8.1.5.2.0 Model

User, Team, UserTeamMembership

#### 8.1.5.3.0 Fields

- User.firstName
- User.email
- User.role
- Team.name

### 8.1.6.0.0 Transformation

#### 8.1.6.1.0 Type

🔹 custom

#### 8.1.6.2.0 Logic

A Cloud Function parses the CSV, validates each row for data integrity and business rules (e.g., valid role), maps fields to Firestore documents, and performs batch writes.

#### 8.1.6.3.0 Configuration

*No data available*

### 8.1.7.0.0 Frequency

on-demand

### 8.1.8.0.0 Criticality

high

### 8.1.9.0.0 Dependencies

- REQ-1-077

### 8.1.10.0.0 Validation

#### 8.1.10.1.0 Pre Transformation

- Verify CSV file headers.
- Validate data types and formats in each cell.

#### 8.1.10.2.0 Post Transformation

- Confirm document creation in Firestore.

### 8.1.11.0.0 Performance

| Property | Value |
|----------|-------|
| Expected Volume | Up to 1000 rows per file |
| Latency Requirement | < 9 minutes (Cloud Function timeout) |
| Optimization Strategy | Use Firestore batch writes to load data efficientl... |

## 8.2.0.0.0 Attendance Data Export to Google Sheets

### 8.2.1.0.0 Transformation Id

T-002

### 8.2.2.0.0 Name

Attendance Data Export to Google Sheets

### 8.2.3.0.0 Description

Transforms approved AttendanceRecord documents from Firestore into a flattened row format for automated export to a specified Google Sheet.

### 8.2.4.0.0 Source

#### 8.2.4.1.0 Service

Data & Persistence Layer

#### 8.2.4.2.0 Model

AttendanceRecord

#### 8.2.4.3.0 Fields

- checkInTime
- checkInLatitude
- checkOutTime
- status
- userFullName

### 8.2.5.0.0 Target

#### 8.2.5.1.0 Service

Integration Layer (Google Sheets API)

#### 8.2.5.2.0 Model

Sheet Row

#### 8.2.5.3.0 Fields

- Record ID
- User Name
- Check-In Time
- Status
- etc.

### 8.2.6.0.0 Transformation

#### 8.2.6.1.0 Type

🔹 flattened

#### 8.2.6.2.0 Logic

A scheduled Cloud Function queries for new approved records, formats each document into an array of values matching the target schema, and appends the rows to the sheet.

#### 8.2.6.3.0 Configuration

*No data available*

### 8.2.7.0.0 Frequency

batch

### 8.2.8.0.0 Criticality

medium

### 8.2.9.0.0 Dependencies

- REQ-1-059

### 8.2.10.0.0 Validation

#### 8.2.10.1.0 Pre Transformation

- Ensure record status is 'approved'.

#### 8.2.10.2.0 Post Transformation

- Verify successful API response from Google Sheets.

### 8.2.11.0.0 Performance

| Property | Value |
|----------|-------|
| Expected Volume | 10-10,000 records per day |
| Latency Requirement | < 9 minutes |
| Optimization Strategy | Query only for records since the last successful s... |

## 8.3.0.0.0 User Data Anonymization

### 8.3.1.0.0 Transformation Id

T-003

### 8.3.2.0.0 Name

User Data Anonymization

### 8.3.3.0.0 Description

Transforms a deactivated user's record by removing PII and replacing their ID in historical records to comply with data retention policies.

### 8.3.4.0.0 Source

#### 8.3.4.1.0 Service

Data & Persistence Layer

#### 8.3.4.2.0 Model

User

#### 8.3.4.3.0 Fields

- userId
- firstName
- lastName
- email
- status
- deactivatedAt

### 8.3.5.0.0 Target

#### 8.3.5.1.0 Service

Data & Persistence Layer

#### 8.3.5.2.0 Model

User, AttendanceRecord, AuditLog

#### 8.3.5.3.0 Fields

- User PII fields
- AttendanceRecord.userId
- AuditLog.actingUserId

### 8.3.6.0.0 Transformation

#### 8.3.6.1.0 Type

🔹 custom

#### 8.3.6.2.0 Logic

A scheduled Cloud Function identifies users deactivated for > 90 days. It then updates their User document to remove PII and queries other collections to replace their userId with an anonymized identifier.

#### 8.3.6.3.0 Configuration

*No data available*

### 8.3.7.0.0 Frequency

batch

### 8.3.8.0.0 Criticality

medium

### 8.3.9.0.0 Dependencies

- REQ-1-074

### 8.3.10.0.0 Validation

#### 8.3.10.1.0 Pre Transformation

- Verify user status is 'deactivated' and the deactivation date is over 90 days ago.

#### 8.3.10.2.0 Post Transformation

- Verify PII fields are cleared and references are updated.

### 8.3.11.0.0 Performance

| Property | Value |
|----------|-------|
| Expected Volume | Low, 0-100 users per day |
| Latency Requirement | < 9 minutes |
| Optimization Strategy | Batch updates and perform targeted queries to find... |

# 9.0.0.0.0 Implementation Priority

## 9.1.0.0.0 Component

### 9.1.1.0.0 Component

Core Model Mappings (Firestore to Domain)

### 9.1.2.0.0 Priority

🔴 high

### 9.1.3.0.0 Dependencies

*No items available*

### 9.1.4.0.0 Estimated Effort

Medium

### 9.1.5.0.0 Risk Level

low

## 9.2.0.0.0 Component

### 9.2.1.0.0 Component

Attendance Export to Google Sheets (T-002)

### 9.2.2.0.0 Priority

🔴 high

### 9.2.3.0.0 Dependencies

- Core Model Mappings

### 9.2.4.0.0 Estimated Effort

Medium

### 9.2.5.0.0 Risk Level

medium

## 9.3.0.0.0 Component

### 9.3.1.0.0 Component

CSV User Import (T-001)

### 9.3.2.0.0 Priority

🟡 medium

### 9.3.3.0.0 Dependencies

- Core Model Mappings

### 9.3.4.0.0 Estimated Effort

High

### 9.3.5.0.0 Risk Level

high

## 9.4.0.0.0 Component

### 9.4.1.0.0 Component

User Anonymization (T-003)

### 9.4.2.0.0 Priority

🟢 low

### 9.4.3.0.0 Dependencies

*No items available*

### 9.4.4.0.0 Estimated Effort

Medium

### 9.4.5.0.0 Risk Level

medium

# 10.0.0.0.0 Risk Assessment

## 10.1.0.0.0 Risk

### 10.1.1.0.0 Risk

Invalid data format or business rule violations in uploaded CSV file causes import process to fail entirely.

### 10.1.2.0.0 Impact

high

### 10.1.3.0.0 Probability

high

### 10.1.4.0.0 Mitigation

Implement robust row-level validation with partial success handling. Provide a downloadable report of all failed rows with clear error messages.

### 10.1.5.0.0 Contingency Plan

Admin manually corrects the CSV and re-uploads.

## 10.2.0.0.0 Risk

### 10.2.1.0.0 Risk

Changes in the Google Sheets API break the automated export functionality.

### 10.2.2.0.0 Impact

medium

### 10.2.3.0.0 Probability

low

### 10.2.4.0.0 Mitigation

Implement version pinning for the Google API client library and configure monitoring to alert on API error spikes.

### 10.2.5.0.0 Contingency Plan

Disable the feature, notify Admins, and update the Cloud Function code to support the new API version.

## 10.3.0.0.0 Risk

### 10.3.1.0.0 Risk

A large-scale data anonymization or aggregation job exceeds the Cloud Function execution time limit.

### 10.3.2.0.0 Impact

medium

### 10.3.3.0.0 Probability

medium

### 10.3.4.0.0 Mitigation

Design batch jobs to be pausable and resumable, for example by processing data in smaller chunks based on timestamps or cursors.

### 10.3.5.0.0 Contingency Plan

Manually trigger the job with a smaller scope/date range until the backlog is cleared.

# 11.0.0.0.0 Recommendations

## 11.1.0.0.0 Category

### 11.1.1.0.0 Category

🔹 Development

### 11.1.2.0.0 Recommendation

Utilize a data mapping/serialization library (e.g., json_serializable in Flutter, class-transformer in TypeScript) to automate and standardize the conversion between Firestore documents and typed objects.

### 11.1.3.0.0 Justification

Reduces boilerplate code, minimizes manual mapping errors, and improves maintainability, which is crucial for the Clean Architecture.

### 11.1.4.0.0 Priority

🔴 high

### 11.1.5.0.0 Implementation Notes

Define data classes with annotations that specify the mapping rules.

## 11.2.0.0.0 Category

### 11.2.1.0.0 Category

🔹 Testing

### 11.2.2.0.0 Recommendation

Create a dedicated suite of unit tests for all transformation logic, especially for the CSV import and Google Sheets export functions.

### 11.2.3.0.0 Justification

Transformations are critical points of failure. Isolating and testing this logic ensures data integrity and prevents regressions.

### 11.2.4.0.0 Priority

🔴 high

### 11.2.5.0.0 Implementation Notes

Use mock data and mock service interfaces to test the transformation functions in isolation.

## 11.3.0.0.0 Category

### 11.3.1.0.0 Category

🔹 Operations

### 11.3.2.0.0 Recommendation

Implement comprehensive logging and monitoring for all batch transformation jobs (Import, Export, Anonymization) from the start.

### 11.3.3.0.0 Justification

Batch jobs run unattended and can fail silently. Proactive monitoring and alerting (as per REQ-1-076) are essential for operational stability and quick issue resolution.

### 11.3.4.0.0 Priority

🔴 high

### 11.3.5.0.0 Implementation Notes

Ensure every batch run logs a summary: records processed, records failed, duration, and any errors encountered.

