# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-032 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Subordinate's attendance is automatically checked ... |
| As A User Story | As a Subordinate, I want the system to automatical... |
| User Persona | Subordinate (Primary), Admin (Secondary - for conf... |
| Business Value | Improves data integrity by ensuring all attendance... |
| Functional Area | Attendance Management |
| Story Theme | Attendance Automation and Data Integrity |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Successful auto-checkout for a user who forgot to check out

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

An organization has enabled the auto-checkout feature for 17:30 in their configured timezone (e.g., 'America/New_York')

### 3.1.5 And

The record's status remains 'pending' for supervisor approval.

### 3.1.6 When

The scheduled auto-checkout function runs at the configured time for that timezone

### 3.1.7 Then

The Subordinate's attendance record is updated with a 'checkOutTime' equal to the configured end-of-workday time (17:30)

### 3.1.8 Validation Notes

Verify the Firestore document for the attendance record has the correct 'checkOutTime' and the 'auto-checked-out' flag. The function logs should indicate a successful update for the specific user.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Auto-checkout process ignores users who have already checked out

### 3.2.3 Scenario Type

Edge_Case

### 3.2.4 Given

An organization has enabled auto-checkout for 17:30

### 3.2.5 And

A Subordinate has checked in and manually checked out at 17:15 on the same day

### 3.2.6 When

The scheduled auto-checkout function runs at 17:30

### 3.2.7 Then

The Subordinate's attendance record is NOT modified by the function.

### 3.2.8 Validation Notes

Query the user's attendance record before and after the function runs. The document's 'checkOutTime' and 'flags' should remain unchanged.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Auto-checkout process does not run for tenants with the feature disabled

### 3.3.3 Scenario Type

Alternative_Flow

### 3.3.4 Given

An organization has NOT enabled the auto-checkout feature in their tenant configuration

### 3.3.5 And

A Subordinate has an attendance record with a 'checkInTime' but a null 'checkOutTime'

### 3.3.6 When

The scheduled auto-checkout function runs globally

### 3.3.7 Then

The function's logic skips this organization's users, and the Subordinate's attendance record remains unchanged.

### 3.3.8 Validation Notes

Verify in the function's logs that the tenant was correctly identified as having the feature disabled and was skipped. The user's Firestore record must not be modified.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Auto-checked-out record is visually distinct in the Supervisor's dashboard

### 3.4.3 Scenario Type

Happy_Path

### 3.4.4 Given

A Subordinate's attendance record has been successfully auto-checked-out

### 3.4.5 When

Their Supervisor views the list of pending attendance records

### 3.4.6 Then

The corresponding record is displayed with a clear visual indicator (e.g., an icon or label) that identifies it as an 'Auto Check-Out'.

### 3.4.7 Validation Notes

Requires UI verification on the Supervisor's dashboard. The frontend should correctly interpret the 'auto-checked-out' flag from the data.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Auto-checked-out record is visually distinct in the Subordinate's history

### 3.5.3 Scenario Type

Happy_Path

### 3.5.4 Given

A Subordinate's attendance record has been successfully auto-checked-out

### 3.5.5 When

The Subordinate views their own attendance history

### 3.5.6 Then

The corresponding record is displayed with a clear visual indicator that identifies it as an 'Auto Check-Out'.

### 3.5.7 Validation Notes

Requires UI verification in the Subordinate's view of their attendance log.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- A visual indicator (icon or text label) on attendance record list items

## 4.2.0 User Interactions

- No direct user interaction for this feature. The UI change is informational.

## 4.3.0 Display Requirements

- The Supervisor's approval dashboard must clearly distinguish auto-checked-out records from manual entries.
- The Subordinate's attendance history must clearly distinguish auto-checked-out records.

## 4.4.0 Accessibility Needs

- The visual indicator for 'auto-checkout' must have a text alternative for screen readers (e.g., 'Status: Automatically checked out').

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

Auto-checkout can only occur for records that have a check-in time but no check-out time on the current calendar day, based on the tenant's timezone.

### 5.1.3 Enforcement Point

Firebase Cloud Function (server-side)

### 5.1.4 Violation Handling

The function's query will inherently filter out records that do not meet this criteria.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

The checkout time applied by the system must be the exact time configured by the Admin in the tenant settings, not the time the function runs.

### 5.2.3 Enforcement Point

Firebase Cloud Function (server-side)

### 5.2.4 Violation Handling

The function must read the configured time from the tenant's settings and use it to construct the checkout timestamp.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-028

#### 6.1.1.2 Dependency Reason

Core check-in functionality must exist to create an open attendance record.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-069

#### 6.1.2.2 Dependency Reason

The system must have a configurable, tenant-specific timezone to schedule and execute the function at the correct local time.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-070

#### 6.1.3.2 Dependency Reason

An Admin must be able to enable/disable this feature and set the specific auto-checkout time. This story implements the backend logic that relies on that configuration.

## 6.2.0.0 Technical Dependencies

- Firebase Cloud Functions for server-side logic.
- Google Cloud Scheduler to trigger the function on a recurring schedule.
- Firebase Firestore for storing and querying attendance and configuration data.

## 6.3.0.0 Data Dependencies

- Requires access to the '/tenants/{tenantId}/config' document to read 'autoCheckoutEnabled' and 'autoCheckoutTime'.
- Requires read/write access to the '/attendance' collection to find and update open records.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The scheduled function must complete its execution within the timeout limit (e.g., 60 seconds).
- The Firestore query to find open attendance records must be efficient and use appropriate indexes to avoid performance degradation as data volume grows.

## 7.2.0.0 Security

- The Cloud Function must operate with the minimum necessary permissions.
- The function should not expose any sensitive data in its logs.

## 7.3.0.0 Usability

- The informational flag in the UI should be clear and unambiguous to both Subordinates and Supervisors.

## 7.4.0.0 Accessibility

- As per REQ-INT-001, all UI indicators must meet WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

*No items available*

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Medium

## 8.2.0.0 Complexity Factors

- Requires server-side development (Cloud Function).
- Involves time-based scheduling and timezone handling, which adds complexity.
- Requires designing a scalable Firestore query that can efficiently find open records across all tenants.
- Needs robust error handling and logging for the scheduled job.

## 8.3.0.0 Technical Risks

- Potential for timezone-related bugs if not handled carefully.
- Risk of inefficient queries causing high Firestore costs or function timeouts at scale.
- Misconfiguration of the Cloud Scheduler could cause the function to run at the wrong time or not at all.

## 8.4.0.0 Integration Points

- Google Cloud Scheduler: To trigger the function.
- Firebase Firestore: To read tenant configurations and read/write attendance records.

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Integration

## 9.2.0.0 Test Scenarios

- Verify function correctly updates a record when conditions are met.
- Verify function correctly ignores an already-closed record.
- Verify function correctly skips a tenant where the feature is disabled.
- Verify function correctly handles different timezones.
- Test function's behavior if tenant configuration is missing or malformed.

## 9.3.0.0 Test Data Needs

- Test tenants with the feature enabled and disabled.
- Test users with open attendance records.
- Test users with closed attendance records.
- Tenant configurations with different timezones and auto-checkout times.

## 9.4.0.0 Testing Tools

- Jest for unit testing the Cloud Function logic.
- Firebase Local Emulator Suite for integration testing the function with a local Firestore instance.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit tests for the Cloud Function implemented with >80% coverage and passing
- Integration testing completed successfully using the Firebase Emulator Suite
- UI changes for displaying the 'auto-checked-out' flag are implemented and reviewed
- Performance requirements verified by analyzing query execution plans
- Security requirements validated
- Required Firestore indexes are defined in 'firestore.indexes.json'
- Story deployed and verified in the staging environment via a manually triggered function run

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

5

## 11.2.0.0 Priority

🟡 Medium

## 11.3.0.0 Sprint Considerations

- This is primarily a backend story. It must be scheduled in a sprint after its prerequisite stories (US-069, US-070) are completed.
- Coordination with frontend will be needed for the small UI task of displaying the flag.

## 11.4.0.0 Release Impact

- This feature enhances data quality and user experience. It should be highlighted in release notes as a key improvement for administrators and end-users.

