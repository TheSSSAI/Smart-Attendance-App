# 1 Story Metadata

| Property | Value |
|----------|-------|
| Story Id | US-039 |
| Elaboration Date | 2025-01-15 |
| Development Readiness | Complete |

# 2 Story Narrative

| Property | Value |
|----------|-------|
| Title | Supervisor approves a single attendance record |
| As A User Story | As a Supervisor, I want to approve a single pendin... |
| User Persona | Supervisor: A user responsible for managing a team... |
| Business Value | Enables the core attendance validation workflow, e... |
| Functional Area | Attendance Management |
| Story Theme | Approval Workflows |

# 3 Acceptance Criteria

## 3.1 Criteria Id

### 3.1.1 Criteria Id

AC-001

### 3.1.2 Scenario

Happy Path: Successful approval of a pending record

### 3.1.3 Scenario Type

Happy_Path

### 3.1.4 Given

I am a Supervisor logged into the mobile app and I am viewing the 'Pending Approvals' list which contains an attendance record with a 'pending' status from my direct subordinate.

### 3.1.5 When

I tap the 'Approve' button for that specific attendance record.

### 3.1.6 Then

The system updates the record's status from 'pending' to 'approved' in the database, a success message ('Record approved successfully.') is displayed, and the record is immediately removed from my 'Pending Approvals' list.

### 3.1.7 Validation Notes

Verify in Firestore that the 'status' field of the attendance document is 'approved'. Verify the UI list updates without a manual refresh.

## 3.2.0 Criteria Id

### 3.2.1 Criteria Id

AC-002

### 3.2.2 Scenario

Audit Trail: Approval action is logged

### 3.2.3 Scenario Type

Happy_Path

### 3.2.4 Given

I am a Supervisor and I am about to approve a pending attendance record.

### 3.2.5 When

The system successfully processes my approval action.

### 3.2.6 Then

A new, immutable document is created in the `auditLog` collection containing the `actorUserId` (my ID), `actionType`: 'ATTENDANCE_APPROVAL', `targetEntityId` (the attendance record ID), a timestamp, and details of the change (old status: 'pending', new status: 'approved').

### 3.2.7 Validation Notes

Query the `auditLog` collection for a new entry corresponding to the approved record. The log must be created by a server-side process (e.g., Cloud Function) to ensure integrity.

## 3.3.0 Criteria Id

### 3.3.1 Criteria Id

AC-003

### 3.3.2 Scenario

Subordinate View: Subordinate sees the updated status

### 3.3.3 Scenario Type

Happy_Path

### 3.3.4 Given

My subordinate's attendance record has a 'pending' status.

### 3.3.5 When

I, as their Supervisor, approve that record.

### 3.3.6 Then

When my subordinate views their attendance history, the status for that record is displayed as 'Approved'.

### 3.3.7 Validation Notes

Log in as the subordinate user and navigate to their attendance history screen to confirm the status update is visible.

## 3.4.0 Criteria Id

### 3.4.1 Criteria Id

AC-004

### 3.4.2 Scenario

Error Condition: Approval attempt with no network connection

### 3.4.3 Scenario Type

Error_Condition

### 3.4.4 Given

I am a Supervisor viewing the 'Pending Approvals' list and my device is offline.

### 3.4.5 When

I tap the 'Approve' button for a record.

### 3.4.6 Then

The action does not proceed, and the app displays a clear error message, such as 'No internet connection. Please try again later.' The record remains in the pending list.

### 3.4.7 Validation Notes

Enable airplane mode on the device and attempt the action. Verify the error message appears and the local state of the record does not change.

## 3.5.0 Criteria Id

### 3.5.1 Criteria Id

AC-005

### 3.5.2 Scenario

Edge Case: Record was already processed by another user/process

### 3.5.3 Scenario Type

Edge_Case

### 3.5.4 Given

I am a Supervisor viewing a 'pending' record on my screen.

### 3.5.5 And

An Admin has already directly approved or rejected that same record in the background.

### 3.5.6 When

I tap the 'Approve' button.

### 3.5.7 Then

The system prevents the update and displays an informative message, such as 'This record has already been processed.' The record is then removed from my pending list upon the next refresh.

### 3.5.8 Validation Notes

Manually change a record's status in the Firestore console from 'pending' to 'approved', then attempt to approve it via the Supervisor's UI. The Firestore Security Rule should reject the write, and the client should handle the error gracefully.

# 4.0.0 User Interface Requirements

## 4.1.0 Ui Elements

- An 'Approve' button or icon associated with each list item in the pending approvals view.
- A loading indicator (e.g., spinner) that displays while the approval request is being processed.
- A success notification (e.g., toast or snackbar) to confirm the action was successful.
- An error notification to inform the user of failures.

## 4.2.0 User Interactions

- Tapping the 'Approve' button initiates the approval workflow.
- The UI should provide immediate visual feedback that the action has been initiated.
- The list of pending items must update automatically upon successful approval, removing the approved item without requiring a manual screen refresh.

## 4.3.0 Display Requirements

- The pending approvals list must clearly display subordinate name, date, and check-in/out times for context.

## 4.4.0 Accessibility Needs

- The 'Approve' button must have a descriptive label for screen readers, e.g., 'Approve attendance for John Doe on January 15th'.

# 5.0.0 Business Rules

## 5.1.0 Rule Id

### 5.1.1 Rule Id

BR-001

### 5.1.2 Rule Description

A Supervisor can only approve attendance records for their own direct subordinates.

### 5.1.3 Enforcement Point

Backend: Firestore Security Rules on write operations to the `/attendance/{recordId}` path.

### 5.1.4 Violation Handling

The write operation is rejected by the database. The client application should display a generic error message.

## 5.2.0 Rule Id

### 5.2.1 Rule Id

BR-002

### 5.2.2 Rule Description

An attendance record can only be approved if its current status is 'pending' or 'correction_pending'.

### 5.2.3 Enforcement Point

Backend: Firestore Security Rules on the update operation.

### 5.2.4 Violation Handling

The write operation is rejected. The client should inform the user that the record's state has changed.

# 6.0.0 Dependencies

## 6.1.0 Prerequisite Stories

### 6.1.1 Story Id

#### 6.1.1.1 Story Id

US-037

#### 6.1.1.2 Dependency Reason

This story implements the UI for viewing pending attendance records, which is the entry point for the approval action.

### 6.1.2.0 Story Id

#### 6.1.2.1 Story Id

US-028

#### 6.1.2.2 Dependency Reason

This story defines the creation of attendance records that will be approved.

### 6.1.3.0 Story Id

#### 6.1.3.1 Story Id

US-011

#### 6.1.3.2 Dependency Reason

This story establishes the Supervisor-Subordinate relationship required for permission checks.

## 6.2.0.0 Technical Dependencies

- Firebase Authentication for user roles and IDs.
- Firestore database for storing and updating attendance records.
- Firestore Security Rules engine for access control.
- Firebase Cloud Functions (recommended) for creating immutable audit log entries.

## 6.3.0.0 Data Dependencies

- Existence of user records with defined roles ('Supervisor', 'Subordinate').
- Existence of attendance records with a `status` of 'pending' and a `supervisorId` field.

## 6.4.0.0 External Dependencies

*No items available*

# 7.0.0.0 Non Functional Requirements

## 7.1.0.0 Performance

- The Firestore write operation for the status update must complete in < 1 second on a stable 4G connection (p95).
- The UI update (removing the item from the list) must feel instantaneous to the user.

## 7.2.0.0 Security

- All approval actions must be enforced by Firestore Security Rules, validating the user's role and their relationship to the subordinate.
- The request must be authenticated using a valid Firebase Auth ID token.

## 7.3.0.0 Usability

- The process to approve a record should be quick and require minimal taps.
- Feedback to the user (loading, success, error) must be clear and immediate.

## 7.4.0.0 Accessibility

- The feature must comply with WCAG 2.1 Level AA standards.

## 7.5.0.0 Compatibility

- The functionality must be consistent on all supported iOS and Android versions as defined in REQ-DEP-001.

# 8.0.0.0 Implementation Considerations

## 8.1.0.0 Complexity Assessment

Low

## 8.2.0.0 Complexity Factors

- The core logic is a simple database field update.
- Requires careful implementation of Firestore Security Rules, which is a critical control point.
- Integration with an audit logging mechanism (preferably a Cloud Function trigger) adds a minor step.

## 8.3.0.0 Technical Risks

- Incorrectly configured Firestore Security Rules could lead to a major security vulnerability (e.g., users approving their own records or records of peers).

## 8.4.0.0 Integration Points

- Firestore `attendance` collection (update).
- Firestore `auditLog` collection (create).

# 9.0.0.0 Testing Requirements

## 9.1.0.0 Testing Types

- Unit
- Widget
- Integration
- Security

## 9.2.0.0 Test Scenarios

- Verify a Supervisor can approve a record for their subordinate.
- Verify a Supervisor CANNOT approve a record for a user who is not their subordinate.
- Verify a Subordinate CANNOT approve their own record.
- Verify the audit log is created correctly upon approval.
- Verify the UI updates correctly on success and shows an error on failure.

## 9.3.0.0 Test Data Needs

- Test accounts for a Supervisor and at least two Subordinates (one direct report, one not).
- Pre-populated attendance records with 'pending' status.

## 9.4.0.0 Testing Tools

- Firebase Local Emulator Suite for testing Firestore rules and Cloud Functions locally.
- Flutter's `flutter_test` and `integration_test` packages.

# 10.0.0.0 Definition Of Done

- All acceptance criteria validated and passing
- Code reviewed and approved by team
- Unit and widget tests implemented with >80% coverage for new logic
- Firestore Security Rules for this action are written and tested
- Integration testing with the Firebase Emulator completed successfully
- User interface reviewed and approved for both iOS and Android
- Performance requirements verified
- Security requirements validated via security rule tests
- Documentation for the approval workflow updated
- Story deployed and verified in the staging environment

# 11.0.0.0 Planning Information

## 11.1.0.0 Story Points

2

## 11.2.0.0 Priority

🔴 High

## 11.3.0.0 Sprint Considerations

- This story is a core part of the MVP workflow. It should be prioritized alongside US-037 (View Pending) and US-040 (Reject Record).
- Can be developed in parallel with US-040 as the underlying mechanism is very similar.

## 11.4.0.0 Release Impact

- Critical for the initial release. The application is not viable without the ability for Supervisors to approve attendance.

