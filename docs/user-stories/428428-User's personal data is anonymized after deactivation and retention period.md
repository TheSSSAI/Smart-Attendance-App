# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-086 |
| Elaboration Date | 2025-01-27 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | User's personal data is anonymized after deactivat... |
| As A User Story | As a deactivated user, I want my personally identi... |
| User Persona | Deactivated User (Passive Beneficiary), System Adm... |
| Business Value | Ensures compliance with data protection regulation... |
| Functional Area | Data Management & Compliance |
| Story Theme | User Lifecycle Management |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Successful anonymization of a deactivated user after the retention period expires

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

A user has a status of 'deactivated' and their 'deactivatedTimestamp' is older than the tenant's configured retention period (e.g., 91 days ago for a 90-day policy).

### 3.1.5 When

The scheduled data anonymization Cloud Function is triggered.

### 3.1.6 Then

The PII fields in the user's Firestore document (`/users/{userId}`) are overwritten with non-personal, placeholder values (e.g., 'name' becomes 'Anonymized User', 'email' becomes 'anonymized+[userId]@[tenantId].local').

### 3.1.7 And

All historical records in other collections (e.g., `attendance`, `events`) referencing the original `userId` are updated to use a non-reversible, anonymized identifier (e.g., 'anonymized-{originalUserId}').

### 3.1.8 Validation Notes

Verify the user document in Firestore for updated fields. Check the audit log for the corresponding entry. Query the attendance collection to confirm the `userId` field has been updated to the anonymized identifier.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

User within the retention period is not anonymized

### 3.2.3 Scenario Type

Edge_Case

### 3.2.4 Given

A user has a status of 'deactivated' and their 'deactivatedTimestamp' is more recent than the tenant's configured retention period (e.g., 30 days ago for a 90-day policy).

### 3.2.5 When

The scheduled data anonymization Cloud Function is triggered.

### 3.2.6 Then

The user's data remains completely unchanged.

### 3.2.7 And

No audit log entry for anonymization is created for this user.

### 3.2.8 Validation Notes

Inspect the user's document and related historical records in Firestore to confirm no modifications have occurred.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

A reactivated user is not anonymized

### 3.3.3 Scenario Type

Edge_Case

### 3.3.4 Given

A user was previously 'deactivated' but now has a status of 'active'.

### 3.3.5 When

The scheduled data anonymization Cloud Function is triggered.

### 3.3.6 Then

The user's data is ignored by the anonymization process and remains unchanged.

### 3.3.7 Validation Notes

Confirm that users with 'active' status are correctly filtered out by the function's query.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Anonymization process is idempotent

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

A user's account has already been processed and has a status of 'anonymized'.

### 3.4.5 When

The scheduled data anonymization Cloud Function is triggered again.

### 3.4.6 Then

The function correctly identifies the user as already processed and performs no further write operations on their data.

### 3.4.7 And

No duplicate audit log entry for anonymization is created.

### 3.4.8 Validation Notes

Trigger the function multiple times and verify that the user's data is modified only once and only one audit log entry is created.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Admin views historical records of an anonymized user

### 3.5.3 Scenario Type

Alternative_Flow

### 3.5.4 Given

A user's data has been successfully anonymized.

### 3.5.5 And

An Admin is viewing a historical report (e.g., attendance summary) that includes records from that user.

### 3.5.6 When

The report is displayed in the web dashboard.

### 3.5.7 Then

The user's name associated with the historical records is displayed as 'Anonymized User' or a similar placeholder, not their original name.

### 3.5.8 Validation Notes

The front-end application must gracefully handle records linked to an anonymized identifier, possibly by fetching user data and recognizing the 'anonymized' status or placeholder name.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- None for the end-user.

## 4.2.0 User Interactions

- This is a backend, automated process with no direct user interaction.

## 4.3.0 Display Requirements

- Admin-facing reports and dashboards must display a placeholder like 'Anonymized User' for historical records belonging to a user who has been anonymized.

## 4.4.0 Accessibility Needs

- Not applicable as there is no direct UI.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

Anonymization can only occur on users with a 'deactivated' status.

### 5.1.3 Enforcement Point

The Firestore query within the scheduled Cloud Function.

### 5.1.4 Violation Handling

Users with any other status are excluded from the process.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

The retention period before anonymization is determined by a configurable setting at the tenant level.

### 5.2.3 Enforcement Point

The logic within the scheduled Cloud Function, which reads the tenant's configuration.

### 5.2.4 Violation Handling

If the setting is not present, the function should log an error and not process any users for that tenant.

## 5.3.0 Rule Id

### 5.3.1 Rule Id

BR-003

### 5.3.2 Rule Description

The anonymization of PII is a permanent, non-reversible action.

### 5.3.3 Enforcement Point

The data overwrite operation within the Cloud Function.

### 5.3.4 Violation Handling

N/A. The system is designed for this to be a one-way process.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-008

#### 6.1.1.2 Dependency Reason

The system must support the deactivation of users, which sets the 'deactivated' status and 'deactivatedTimestamp' that this story relies on.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-074

#### 6.1.2.2 Dependency Reason

An Admin-configurable data retention period must exist in the tenant settings for the function to determine which users to process.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-051

#### 6.1.3.2 Dependency Reason

The immutable audit log system must be in place to record the anonymization event for compliance and tracking purposes.

## 6.2.0.0 Technical Dependencies

- Firebase Cloud Functions (Scheduled Functions)
- Firebase Firestore
- A well-defined data model as per REQ-DAT-001.

## 6.3.0.0 Data Dependencies

- Tenant configuration document containing the `dataRetention.deactivatedUserPeriodInDays` value.
- User documents must contain `status` and `deactivatedTimestamp` fields.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The scheduled function must complete its execution within the Cloud Function timeout limit (e.g., 540 seconds).
- The function should process users in batches to handle tenants with a large number of deactivated users without causing performance degradation or memory issues.

## 7.2.0.0 Security

- The anonymization process must be irreversible.
- The Cloud Function must run with appropriate IAM permissions to modify data across multiple collections but should be restricted from any other actions.
- The process must be logged in the immutable audit log.

## 7.3.0.0 Usability

- Not applicable.

## 7.4.0.0 Accessibility

- Not applicable.

## 7.5.0.0 Compatibility

- Not applicable.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

High

## 8.2.0.0 Complexity Factors

- Performing a 'find and replace' for a `userId` across multiple, potentially large, Firestore collections is complex and can be resource-intensive.
- Ensuring the entire operation for a single user is atomic or at least idempotent is critical to prevent data inconsistency if the function fails midway.
- Thorough testing of a destructive, time-based, automated process requires a sophisticated test setup, likely using the Firebase Emulator Suite and time manipulation.
- The function must be designed to scale, using batch writes and efficient queries to avoid hitting Firestore or Cloud Function limits.

## 8.3.0.0 Technical Risks

- Risk of incomplete anonymization if a new collection referencing `userId` is added in the future and the anonymization function is not updated.
- Risk of performance issues or timeouts in tenants with very large datasets, potentially requiring a more complex queue-based processing pattern.
- Risk of data corruption if the function logic is flawed. A dry-run mode could be a valuable safety feature during development.

## 8.4.0.0 Integration Points

- Firebase Authentication (to potentially disable the user if not already done)
- Firestore Database (Users, Attendance, Events, AuditLog, and any other collection with a `userId` reference)
- Cloud Scheduler (to trigger the function)

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E

## 9.2.0.0 Test Scenarios

- Verify a user past the retention date is fully anonymized.
- Verify a user within the retention date is untouched.
- Verify an active user is untouched.
- Verify the function can be run multiple times without causing errors or duplicate changes (idempotency).
- Verify that an Admin viewing a report sees the anonymized placeholder instead of the user's real name.

## 9.3.0.0 Test Data Needs

- A test tenant with multiple users in various states: active, recently deactivated, long-deactivated.
- Historical data (attendance, events) linked to these test users.
- Configurable tenant settings for the retention period in the test environment.

## 9.4.0.0 Testing Tools

- Jest (for Cloud Function unit tests)
- Firebase Local Emulator Suite (for integration testing)

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for the Cloud Function logic with >80% coverage
- Integration testing completed successfully against the Firebase Emulator Suite
- The scheduled function is deployed and configured to run on a daily schedule in the staging environment
- The process is confirmed to be idempotent
- Admin-facing UI correctly displays placeholder data for anonymized records
- Documentation updated to include the anonymization logic, the fields it affects, and the collections it scans
- Story deployed and verified in staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

13

## 11.2.0.0 Priority

🟡 Medium

## 11.3.0.0 Sprint Considerations

- This is a high-risk, backend-only story. It requires a developer with strong Firestore and Cloud Functions experience.
- Sufficient time must be allocated for rigorous integration testing due to the destructive nature of the operation.
- This story should be planned for a sprint after its dependencies (US-008, US-074, US-051) are fully completed and deployed.

## 11.4.0.0 Release Impact

This feature is critical for long-term compliance and data hygiene but is not a user-facing feature for the initial launch. It can be released post-MVP but should be prioritized for compliance reasons.

