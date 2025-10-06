# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-044 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Pending approval is escalated to the next-level su... |
| As A User Story | As an Admin, I want pending attendance approvals t... |
| User Persona | System (Actor), Admin (Configurator), Supervisor (... |
| Business Value | Ensures business continuity by preventing bottlene... |
| Functional Area | Approval Workflows |
| Story Theme | Workflow Automation and Reliability |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: A pending record is escalated to the next available supervisor

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given



```
a tenant has configured the 'approval escalation period' to 3 days (via US-071),
AND a Subordinate's attendance record has a 'pending' status for 4 days,
AND the Subordinate's direct Supervisor ('Supervisor A') has an active account,
AND 'Supervisor A' reports to another active Supervisor ('Supervisor B')
```

### 3.1.5 When

the daily scheduled escalation Cloud Function is triggered

### 3.1.6 Then



```
the system identifies the overdue attendance record,
AND the record's `supervisorId` field is updated from 'Supervisor A's ID to 'Supervisor B's ID,
AND an entry is created in the `auditLog` collection detailing the action, actor ('System'), original supervisor, and new supervisor,
AND the record no longer appears in 'Supervisor A's' pending approval queue,
AND the record now appears in 'Supervisor B's' pending approval queue.
```

### 3.1.7 Validation Notes

Verify database changes in Firestore for the attendance record and the creation of the audit log entry. Log in as Supervisor A and B to confirm UI changes in their respective dashboards.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Edge Case: The assigned supervisor is at the top of the hierarchy

### 3.2.3 Scenario Type

Edge_Case

### 3.2.4 Given



```
a tenant has configured the 'approval escalation period' to 3 days,
AND a Subordinate's attendance record has a 'pending' status for 4 days,
AND the Subordinate's direct Supervisor ('Supervisor A') has a null `supervisorId` (is a top-level manager)
```

### 3.2.5 When

the scheduled escalation function runs

### 3.2.6 Then



```
the system identifies the overdue record but finds no higher-level supervisor,
AND the record's `supervisorId` remains unchanged,
AND the record is updated with a flag such as `escalation_failed_no_supervisor`,
AND a high-severity log is written to Cloud Logging for administrative review.
```

### 3.2.7 Validation Notes

Check the attendance record in Firestore for the new flag. Verify no audit log for escalation is created. Check Cloud Logging for the error entry.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Edge Case: The next-level supervisor's account is deactivated

### 3.3.3 Scenario Type

Edge_Case

### 3.3.4 Given



```
the escalation period is 3 days and a record is 4 days old,
AND the direct Supervisor ('Supervisor A') reports to 'Supervisor B',
AND 'Supervisor B' reports to 'Supervisor C',
AND 'Supervisor B's' user account status is 'deactivated'
```

### 3.3.5 When

the scheduled escalation function runs

### 3.3.6 Then



```
the system attempts to escalate to 'Supervisor B', finds they are deactivated, and skips them,
AND the system successfully escalates the record to the next active supervisor in the chain, 'Supervisor C',
AND the record's `supervisorId` is updated to 'Supervisor C's ID,
AND the audit log reflects the escalation from 'Supervisor A' to 'Supervisor C'.
```

### 3.3.7 Validation Notes

Setup user hierarchy with a deactivated user in the middle. Verify the record skips the deactivated user and is assigned to the correct, higher-level supervisor.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Alternative Flow: Escalation period is not configured for the tenant

### 3.4.3 Scenario Type

Alternative_Flow

### 3.4.4 Given



```
a tenant has NOT configured the 'approval escalation period',
AND a Subordinate's attendance record has a 'pending' status for 10 days
```

### 3.4.5 When

the scheduled escalation function runs

### 3.4.6 Then

```javascript
the function skips processing for this tenant,
AND the attendance record remains unchanged.
```

### 3.4.7 Validation Notes

Ensure the function correctly checks for the existence of the configuration value before processing records for a tenant.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Error Condition: Race condition where record is approved just before escalation

### 3.5.3 Scenario Type

Error_Condition

### 3.5.4 Given

an attendance record is overdue and eligible for escalation

### 3.5.5 When

the supervisor approves the record at the same moment the escalation function attempts to process it

### 3.5.6 Then



```
the system (using a Firestore transaction) correctly handles the race condition,
AND the record's final status is 'approved',
AND the escalation does not occur.
```

### 3.5.7 Validation Notes

This is difficult to test manually. The implementation must use a Firestore transaction that reads the record's status before writing the update. Code review is critical here.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A visual indicator (e.g., an icon or text label like 'Escalated') on attendance records in the Supervisor's approval queue that were assigned via escalation.

## 4.2.0 User Interactions

- The original supervisor will see the pending item disappear from their list.
- The new (escalated-to) supervisor will see a new item appear in their list, ideally with the visual indicator.

## 4.3.0 Display Requirements

- The Admin's audit log report (US-063) must clearly display escalation events, including timestamp, record ID, original supervisor, and new supervisor.

## 4.4.0 Accessibility Needs

- The 'Escalated' visual indicator must have a text equivalent for screen readers.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-ESC-001

### 5.1.2 Rule Description

Escalation only applies to records with a status of 'pending' or 'correction_pending'.

### 5.1.3 Enforcement Point

Server-side Cloud Function query.

### 5.1.4 Violation Handling

Records with other statuses (e.g., 'approved', 'rejected') are ignored by the escalation process.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-ESC-002

### 5.2.2 Rule Description

The escalation period is defined in whole calendar days, based on the tenant's configured timezone.

### 5.2.3 Enforcement Point

Server-side Cloud Function logic.

### 5.2.4 Violation Handling

N/A - This is a calculation rule.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-071

#### 6.1.1.2 Dependency Reason

The escalation period must be configurable by an Admin before this feature can function.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-037

#### 6.1.2.2 Dependency Reason

The Supervisor's approval dashboard/queue must exist to see the results of the escalation.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-051

#### 6.1.3.2 Dependency Reason

The `auditLog` collection and associated logic must be implemented to record the escalation event for compliance.

## 6.2.0.0 Technical Dependencies

- A hierarchical user structure with a `supervisorId` field on each user document.
- Firebase Cloud Functions and Cloud Scheduler for time-based job execution.

## 6.3.0.0 Data Dependencies

- Tenant configuration data (escalation period, timezone).
- User profile data (to traverse the supervisor hierarchy).

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The scheduled function must complete its execution within the Cloud Function timeout limit (e.g., < 540s).
- Firestore queries must use a composite index on `status` and `creationTimestamp` to ensure efficient retrieval of eligible records without scanning the entire collection.

## 7.2.0.0 Security

- The Cloud Function must execute with the minimum necessary IAM permissions.
- All database operations must strictly respect tenant data isolation.

## 7.3.0.0 Usability

- The process is automatic; no direct user interaction is required to trigger it.

## 7.4.0.0 Accessibility

- N/A for the backend process. See UI requirements for related frontend changes.

## 7.5.0.0 Compatibility

- N/A for the backend process.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires a scheduled (time-based) Cloud Function, which is more complex than a client-callable function.
- Logic to traverse a user hierarchy, including handling edge cases like top-level or deactivated users.
- Requires a potentially costly cross-collection query that must be optimized with proper indexing.
- Handling of tenant-specific timezones for calculating 'days'.
- Need for batch processing or transactions to handle large volumes of records and prevent race conditions.

## 8.3.0.0 Technical Risks

- Poorly optimized query could lead to high Firestore costs or function timeouts.
- Incorrect handling of the user hierarchy could lead to infinite loops (if circular dependencies exist) or failed escalations.
- Race conditions if a supervisor acts on a record at the exact moment the function is processing it.

## 8.4.0.0 Integration Points

- Firebase Cloud Scheduler: To trigger the function on a recurring schedule (e.g., daily).
- Firestore Database: Reading tenant configs, user data, attendance records. Writing to attendance records and the audit log.
- Google Cloud Logging: For detailed operational and error logging.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration
- E2E (Manual)

## 9.2.0.0 Test Scenarios

- Verify successful escalation for a standard pending record.
- Verify escalation stops at a top-level supervisor.
- Verify escalation correctly skips a deactivated supervisor.
- Verify no action is taken for tenants without a configured escalation period.
- Verify the function handles a large batch of records without timing out.

## 9.3.0.0 Test Data Needs

- A test tenant with a multi-level user hierarchy (at least 3 levels).
- A user account in the hierarchy that is marked as 'deactivated'.
- Attendance records with timestamps manually set to be older than the configured escalation period.

## 9.4.0.0 Testing Tools

- Jest for TypeScript unit tests.
- Firebase Local Emulator Suite for integration testing of the Cloud Function against a local Firestore instance.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests implemented for the Cloud Function logic with >80% coverage
- Integration testing completed successfully using the Firebase Emulator Suite
- User interface changes (visual indicator) reviewed and approved
- Performance requirements (indexed query) verified
- Security requirements validated
- Documentation for the scheduled job and its configuration is created
- Story deployed and verified in staging environment via a manual E2E test plan

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🟡 Medium

## 11.3.0.0 Sprint Considerations

- This is primarily a backend-focused story. Requires a developer comfortable with Cloud Functions, Cloud Scheduler, and advanced Firestore queries.
- A small amount of frontend work is needed for the 'Escalated' indicator.
- All prerequisite stories, especially US-071, must be completed first.

## 11.4.0.0 Release Impact

Improves the reliability of the approval workflow. Can be released independently of other major features once its dependencies are met.

